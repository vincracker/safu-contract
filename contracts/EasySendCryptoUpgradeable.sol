// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

struct Order {
    uint256 id;
    address token_address;
    uint256 amount;
    bytes32 passphrase;
    address sender;
    address receiver;
    bool is_swap;
    address swap_token_address;
    uint256 swap_amount;
    uint256 swap_deadline;
}

contract EasySendCryptoUpgradeable is Initializable, AccessControlUpgradeable {
    uint256 public count;
    uint256 public fee_rate;
    uint256 public fee_collect_cap;
    address public fee_collect_address;
    mapping(bytes32 => Order) orders_mapping;
    address[] public stable_coins;

    event New_Order(
        uint256 id,
        address token_address,
        uint256 amount,
        bytes32 passphrase,
        address sender,
        address receiver,
        bool is_swap,
        address swap_token_address,
        uint256 swap_amount,
        uint256 swap_deadline
    );

    event Order_Completed(uint256 id);
    event Order_Cancelled(uint256 id);
    event Data(bytes data);

    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must be Admin");
        _;
    }

    // constructor(uint256 _fee_rate, address _fee_collect_address) {
    //     count = 0;
    //     fee_rate = _fee_rate;
    //     fee_collect_address = _fee_collect_address;
    //     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    // }

    // constructor() {
    //     _disableInitializers();
    // }

    function initialize(
        uint256 _fee_rate,
        address _fee_collect_address,
        uint256 _fee_collect_cap,
        address[] memory _stable_coins
    ) public initializer {
        __AccessControl_init();
        __Context_init();
        __ERC165_init();

        require(
            _fee_collect_address != address(0),
            "Cannot set fee_collect_address to 0"
        );

        fee_rate = _fee_rate;
        fee_collect_address = _fee_collect_address;
        fee_collect_cap = _fee_collect_cap;
        stable_coins = _stable_coins;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function set_fee_rate(uint256 _new_fee_rate) external onlyAdmin {
        fee_rate = _new_fee_rate;
    }

    function set_fee_collect_cap(uint256 _new_fee_collect_cap)
        external
        onlyAdmin
    {
        require(_new_fee_collect_cap != 0, "Cannot set fee_collect_cap to 0");
        fee_collect_cap = _new_fee_collect_cap;
    }

    function set_stable_coins(address[] memory _stable_coins)
        external
        onlyAdmin
    {
        for (uint256 i = 0; i < _stable_coins.length; i++) {
            require(
                _stable_coins[i] != address(0),
                "Invalid stable coin address"
            );
        }
        stable_coins = _stable_coins;
    }

    function set_fee_collect_address(address _fee_collect_address)
        external
        onlyAdmin
    {
        require(
            _fee_collect_address != address(0),
            "Cannot set fee_collect_address to null address"
        );
        fee_collect_address = _fee_collect_address;
    }

    function add_order(
        address _token_address,
        uint256 _amount,
        bytes32 _passphrase,
        address _receiver,
        bool _is_swap,
        address _swap_token_address,
        uint256 _swap_amount,
        uint256 _swap_deadline
    ) external payable {
        require(
            orders_mapping[_passphrase].sender == address(0),
            "Cannot use same passphrase"
        );

        if (_is_swap) {
            require(
                block.timestamp <= _swap_deadline,
                "Cannot set deadline before current moment"
            );
        }

        _transfer_token_from(
            payable(msg.sender),
            address(this),
            _amount,
            _token_address
        );

        uint256 current_count = count;

        Order memory new_order = Order(
            current_count,
            _token_address,
            _amount,
            _passphrase,
            msg.sender,
            _receiver,
            _is_swap,
            _swap_token_address,
            _swap_amount,
            _swap_deadline
        );
        orders_mapping[_passphrase] = new_order;

        count = current_count + 1;

        emit New_Order(
            new_order.id,
            _token_address,
            _amount,
            _passphrase,
            msg.sender,
            _receiver,
            _is_swap,
            _swap_token_address,
            _swap_amount,
            _swap_deadline
        );
    }

    function claim_asset(string memory passphrase_string) external {
        bytes32 passphrase = keccak256(abi.encodePacked(passphrase_string));
        Order memory unclaimed_order = orders_mapping[passphrase];
        require(unclaimed_order.receiver != address(0), "Passphrase not exist");
        require(unclaimed_order.receiver == msg.sender, "Address not receiver");
        // require(unclaimed_order.is_swap == false, "Can only swap");
        delete orders_mapping[passphrase];

        if (unclaimed_order.is_swap) {
            require(
                block.timestamp <= unclaimed_order.swap_deadline,
                "Swap expired"
            );
            uint256 swap_collect_fee = ((unclaimed_order.swap_amount *
                fee_rate) / 10000);

            if (is_stable_coin(unclaimed_order.swap_token_address)) {
                swap_collect_fee = 1000000000000000000000; //1000 stable coins
            }

            _transfer_token_from(
                payable(msg.sender),
                fee_collect_address,
                swap_collect_fee,
                unclaimed_order.swap_token_address
            );

            _transfer_token_from(
                payable(msg.sender),
                unclaimed_order.sender,
                unclaimed_order.swap_amount - swap_collect_fee,
                unclaimed_order.swap_token_address
            );
        }

        uint256 collect_fee = ((unclaimed_order.amount * fee_rate) / 10000);
        if (is_stable_coin(unclaimed_order.token_address)) {
            collect_fee = 1000000000000000000000; //1000 stable coins
        }
        _transfer_token_to(
            payable(fee_collect_address),
            collect_fee,
            unclaimed_order.token_address
        );

        _transfer_token_to(
            payable(unclaimed_order.receiver),
            unclaimed_order.amount - collect_fee,
            unclaimed_order.token_address
        );

        emit Order_Completed(unclaimed_order.id);
    }

    function retrieve_unclaimed_order(bytes32 passphrase) external {
        Order memory unclaimed_order = orders_mapping[passphrase];
        delete orders_mapping[passphrase];

        require(
            unclaimed_order.sender == msg.sender,
            "Not allow retrieve asset"
        );
        _transfer_token_to(
            payable(unclaimed_order.sender),
            unclaimed_order.amount,
            unclaimed_order.token_address
        );
        emit Order_Cancelled(unclaimed_order.id);
    }

    function is_passphrase_unique(bytes32 passphrase)
        external
        view
        returns (bool)
    {
        if (orders_mapping[passphrase].sender == address(0)) {
            return true;
        } else {
            return false;
        }
    }

    function is_stable_coin(address token_address) public view returns (bool) {
        for (uint256 i = 0; i < stable_coins.length; i++) {
            if (stable_coins[i] == token_address) {
                return true;
            }
        }
        return false;
    }

    function _transfer_token_from(
        address from,
        address to,
        uint256 amount,
        address token_address
    ) internal {
        if (token_address == address(0)) {
            require(msg.value == amount, "Amount and value not match");
        } else {
            IERC20 token = IERC20(token_address);
            require(token.balanceOf(from) >= amount, "Insufficient balance");
            bool res = token.transferFrom(from, to, amount);
            require(res, "TransferFrom failed");
        }
    }

    function _transfer_token_to(
        address payable to,
        uint256 amount,
        address token_address
    ) internal {
        if (token_address == address(0)) {
            (bool sent, bytes memory data) = to.call{value: amount}("");
            require(sent, "Failed to send Ether");
            emit Data(data);
        } else {
            IERC20 token = IERC20(token_address);
            require(
                token.balanceOf(address(this)) >= amount,
                "Insufficient balance"
            );
            bool res = token.transfer(to, amount);
            require(res, "Transfer failed");
        }
    }
}
