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
    uint16 public fee_rate;
    uint256 public fee_collect_cap;
    address public fee_collect_address;
    mapping(bytes32 => Order) orders_mapping;
    address[] public stable_coins;

    uint16 constant FEE_RATE_BASE = 10000;

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
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "EasySendCryptoUpgradeable.sol: Must be Admin"
        );
        _;
    }

    constructor() {
        _disableInitializers();
    }

    /// @notice The contract Initializer
    /// @param _fee_rate The uint16 number for fee rate (0-10000)
    /// @param _fee_collect_address The address receive fee
    /// @param _fee_collect_cap The maximum amount of fee can be collected if the swaping/transfering ERC20 token is stable coin
    /// @param _stable_coins The array of address of stable coins
    function initialize(
        uint16 _fee_rate,
        address _fee_collect_address,
        uint256 _fee_collect_cap,
        address[] memory _stable_coins
    ) public initializer {
        __AccessControl_init();
        __Context_init();
        __ERC165_init();

        require(
            _fee_collect_address != address(0),
            "EasySendCryptoUpgradeable.sol: Cannot set fee_collect_address to 0"
        );
        require(
            _fee_rate <= FEE_RATE_BASE,
            "EasySendCryptoUpgradeable.sol: Cannot set fee_rate more than 10000."
        );

        fee_rate = _fee_rate;
        fee_collect_address = _fee_collect_address;
        fee_collect_cap = _fee_collect_cap;
        stable_coins = _stable_coins;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice The setter function for fee_rate, only admin can call this function
    /// @param _new_fee_rate The new fee_rate value
    function set_fee_rate(uint16 _new_fee_rate) external onlyAdmin {
        require(
            _new_fee_rate <= FEE_RATE_BASE,
            "EasySendCryptoUpgradeable.sol: Cannot set fee_rate more than 10000."
        );
        fee_rate = _new_fee_rate;
    }

    /// @notice The setter function for fee_rate_cap, only admin can call this function
    /// @param _new_fee_collect_cap The new fee_collect_cap value
    function set_fee_collect_cap(uint256 _new_fee_collect_cap)
        external
        onlyAdmin
    {
        require(
            _new_fee_collect_cap != 0,
            "EasySendCryptoUpgradeable.sol: Cannot set fee_collect_cap to 0"
        );
        fee_collect_cap = _new_fee_collect_cap;
    }

    /// @notice The setter function for stable_coins, only admin can call this function
    /// @param _stable_coins The new stable_coins arrays
    function set_stable_coins(address[] memory _stable_coins)
        external
        onlyAdmin
    {
        for (uint256 i = 0; i < _stable_coins.length; i++) {
            require(
                _stable_coins[i] != address(0),
                "EasySendCryptoUpgradeable.sol: Invalid stable coin address"
            );
        }
        stable_coins = _stable_coins;
    }

    /// @notice The setter function for fee_collect_address, only admin can call this function
    /// @param _fee_collect_address The new fee_collect_address
    function set_fee_collect_address(address _fee_collect_address)
        external
        onlyAdmin
    {
        require(
            _fee_collect_address != address(0),
            "EasySendCryptoUpgradeable.sol: Cannot set fee_collect_address to null address"
        );
        fee_collect_address = _fee_collect_address;
    }

    /// @notice The function for user to add order for transfering or swaping. The is_swap flag is used to determine the order type.
    /// @notice Transfer order doesn't need to set swap_token_address, swap_amount and swap_deadline.
    /// @notice If Swap order expried. The sender need to cancel to claim the tokens back.
    /// @param _token_address The token address of the order sender send
    /// @param _amount The amount of token to be sent from sender
    /// @param _passphrase The passphrase hash of the order (Hashed from keccak256,not reversible)
    /// @param _receiver The address of the order receiver
    /// @param _is_swap The swap flag of the order
    /// @param _swap_token_address The token address of the order receiver send
    /// @param _swap_amount The amount of ERC20 token to be sent from receiver (0 if is_swap is false)
    /// @param _swap_deadline The swap deadline of the order (0 if is_swap is false)
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
            _receiver != address(0),
            "EasySendCryptoUpgradeable.sol: Cannot set receiver to null address"
        );
        require(
            orders_mapping[_passphrase].sender == address(0),
            "EasySendCryptoUpgradeable.sol: Cannot use same passphrase"
        );
        require(_amount > 0, "Amount should not be zero.");

        if (_is_swap) {
            require(
                block.timestamp <= _swap_deadline,
                "EasySendCryptoUpgradeable.sol: Cannot set deadline before current moment"
            );
            require(_swap_amount > 0, "Swap amount should not be zero.");
        }

        _transfer_token_from(
            payable(msg.sender),
            address(this),
            _amount,
            _token_address
        );

        Order memory new_order = Order(
            count++,
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

    /// @notice The function for user to claim or swap tokens. The is_swap flag is used to determine the order type.
    /// @notice Receiver need to privide the original passphrase string to claim the tokens.
    /// @param passphrase_string The original passphrase string of the order passphrase hash
    function claim_asset(string memory passphrase_string) external {
        // Hash the passphrase string
        bytes32 passphrase_hash = keccak256(
            abi.encodePacked(passphrase_string)
        );
        Order memory unclaimed_order = orders_mapping[passphrase_hash];

        // Check if the passphrase exist
        require(
            unclaimed_order.receiver != address(0),
            "EasySendCryptoUpgradeable.sol: Passphrase not exist"
        );

        // Check if the msg.sender is receiver of the order
        require(
            unclaimed_order.receiver == msg.sender,
            "EasySendCryptoUpgradeable.sol: Sender is not receiver"
        );

        // Prevent reentrancy attack
        delete orders_mapping[passphrase_hash];

        // check if the order is swap order
        if (unclaimed_order.is_swap) {
            // Check if the swap order is expired
            require(
                block.timestamp <= unclaimed_order.swap_deadline,
                "EasySendCryptoUpgradeable.sol: Swap order expired"
            );
            // calculate the fee for token sent
            uint256 swap_collect_fee = ((unclaimed_order.swap_amount *
                fee_rate) / FEE_RATE_BASE);

            // if the token is stable coin, the fee is limited to 1000 stable coins
            if (is_stable_coin(unclaimed_order.token_address)) {
                if (swap_collect_fee > 1000000000000000000000) {
                    swap_collect_fee = 1000000000000000000000; //1000 stable coins
                }
            }

            // Send the fee to fee_collect_address
            _transfer_token_from(
                payable(msg.sender),
                fee_collect_address,
                swap_collect_fee,
                unclaimed_order.swap_token_address
            );

            // Send the remain amount to sender of the order
            _transfer_token_from(
                payable(msg.sender),
                unclaimed_order.sender,
                unclaimed_order.swap_amount - swap_collect_fee,
                unclaimed_order.swap_token_address
            );
        }

        // Calculate the fee for token received
        uint256 collect_fee = ((unclaimed_order.amount * fee_rate) /
            FEE_RATE_BASE);

        // if the token is stable coin, the fee is limited to 1000 stable coins
        if (is_stable_coin(unclaimed_order.token_address)) {
            if (collect_fee > 1000000000000000000000) {
                collect_fee = 1000000000000000000000; //1000 stable coins
            }
        }
        // Send the fee to fee_collect_address
        _transfer_token_to(
            payable(fee_collect_address),
            collect_fee,
            unclaimed_order.token_address
        );

        // Send the token to receiver
        _transfer_token_to(
            payable(unclaimed_order.receiver),
            unclaimed_order.amount - collect_fee,
            unclaimed_order.token_address
        );

        emit Order_Completed(unclaimed_order.id);
    }

    /// @notice The function for user to cancel the order. The sender of the order can cancel the order before the receiver claim the order.
    /// @param passphrase_hash The passphrase hash of the order
    function retrieve_unclaimed_order(bytes32 passphrase_hash) external {
        Order memory unclaimed_order = orders_mapping[passphrase_hash];
        delete orders_mapping[passphrase_hash];

        require(
            unclaimed_order.sender == msg.sender,
            "EasySendCryptoUpgradeable.sol: Not allow retrieve asset"
        );
        _transfer_token_to(
            payable(unclaimed_order.sender),
            unclaimed_order.amount,
            unclaimed_order.token_address
        );
        emit Order_Cancelled(unclaimed_order.id);
    }

    /// @notice The function for user to check if the passphrase is unique.
    /// @param passphrase_hash The passphrase hash of the order
    function is_passphrase_unique(bytes32 passphrase_hash)
        external
        view
        returns (bool)
    {
        return orders_mapping[passphrase_hash].sender == address(0);
    }

    /// @notice The function for user to check if the token is stable coin.
    /// @param token_address The address of the token
    function is_stable_coin(address token_address) public view returns (bool) {
        for (uint256 i = 0; i < stable_coins.length; i++) {
            require(
                stable_coins[i] != address(0),
                "EasySendCryptoUpgradeable.sol: Stable coin is not null address"
            );
            if (stable_coins[i] == token_address) {
                return true;
            }
        }
        return false;
    }

    /// @notice The function for transfer token from sender to receiver.
    function _transfer_token_from(
        address from,
        address to,
        uint256 amount,
        address token_address
    ) internal {
        if (token_address == address(0)) {
            require(msg.value == amount, "EasySendCryptoUpgradeable.sol: Amount and value not match");
        } else {
            IERC20 token = IERC20(token_address);
            require(token.balanceOf(from) >= amount, "EasySendCryptoUpgradeable.sol: Insufficient balance");
            bool res = token.transferFrom(from, to, amount);
            require(res, "EasySendCryptoUpgradeable.sol: TransferFrom failed");
        }
    }

    /// @notice The function for transfer token from contract to receiver.
    function _transfer_token_to(
        address payable to,
        uint256 amount,
        address token_address
    ) internal {
        if (token_address == address(0)) {
            (bool sent, bytes memory data) = to.call{value: amount}("");
            require(sent, "EasySendCryptoUpgradeable.sol: Failed to send Ether");
            emit Data(data);
        } else {
            IERC20 token = IERC20(token_address);
            require(
                token.balanceOf(address(this)) >= amount,
                "EasySendCryptoUpgradeable.sol: Insufficient balance"
            );
            bool res = token.transfer(to, amount);
            require(res, "EasySendCryptoUpgradeable.sol: Transfer failed");
        }
    }
}
