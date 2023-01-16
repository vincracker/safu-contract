// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../contracts/EasySendCrypto.sol";
import "../contracts/ERC20.sol";

contract EasySendCryptoTest is Test {
    EasySendCrypto public easySendCrypto;
    ERC20Token public testERC20;

    address fee_collect_address = 0x99dbB9D1A7FFd38467F94443a9dEe088c6AB34B9;
    address test_wallet_1 = 0xd710C48977aEA6dC5AA281b80A37A45901373814;
    address test_wallet_2 = 0x63C99dc287157dc8BFF689BcC3Fa88435eE131A4;

    function setUp() public {
        easySendCrypto = new EasySendCrypto();
        easySendCrypto.initialize(10, fee_collect_address);
        testERC20 = new ERC20Token();
    }

    function test_constructor() public {
        assertEq(easySendCrypto.fee_rate(), 10);
        assertEq(easySendCrypto.fee_collect_address(), fee_collect_address);
    }

    function test_set_fee_rate() public {
        uint256 _new_fee_rate = 20;
        vm.prank(test_wallet_1);
        vm.expectRevert("Must be Admin");
        easySendCrypto.set_fee_rate(_new_fee_rate);

        vm.prank(address(this));
        easySendCrypto.set_fee_rate(_new_fee_rate);
        assertEq(easySendCrypto.fee_rate(), _new_fee_rate);
    }

    function test_set_fee_collect_address() public {
        address _new_fee_collect_wallet = 0x63C99dc287157dc8BFF689BcC3Fa88435eE131A4;
        vm.prank(test_wallet_1);
        vm.expectRevert("Must be Admin");
        easySendCrypto.set_fee_collect_address(_new_fee_collect_wallet);

        vm.prank(address(this));
        easySendCrypto.set_fee_collect_address(_new_fee_collect_wallet);
        assertEq(easySendCrypto.fee_collect_address(), _new_fee_collect_wallet);
    }

    function test_transfer_order() public {
        // mint 1 ether to test wallet 1
        vm.deal(test_wallet_1, 1 ether);

        uint256 test_wallet_1_balance = test_wallet_1.balance;
        uint256 test_wallet_2_balance = test_wallet_2.balance;
        uint256 fee_collect_addr_balance = fee_collect_address.balance;

        string memory pp_string = "test";
        bytes32 pp = keccak256(abi.encodePacked(pp_string));

        vm.prank(test_wallet_1);
        vm.expectRevert("Amount and value not match");
        easySendCrypto.add_order{value: 0.5 ether}(
            address(0),
            1 ether,
            pp,
            test_wallet_2,
            false,
            address(0),
            0,
            0
        );

        // add a transfer order
        vm.prank(test_wallet_1);
        easySendCrypto.add_order{value: 1 ether}(
            address(0),
            1 ether,
            pp,
            test_wallet_2,
            false,
            address(0),
            0,
            0
        );

        assertEq(test_wallet_1_balance - test_wallet_1.balance, 1 ether);
        assertEq(address(easySendCrypto).balance, 1 ether);

        vm.prank(address(this));
        vm.expectRevert("Address not receiver");
        easySendCrypto.claim_asset(pp_string);

        vm.prank(test_wallet_2);
        vm.expectRevert("Passphrase not exist");
        easySendCrypto.claim_asset("test2");

        vm.prank(test_wallet_2);
        easySendCrypto.claim_asset(pp_string);

        assertEq(
            test_wallet_2.balance - test_wallet_2_balance,
            1 ether - 0.1 ether
        );
        assertEq(
            fee_collect_address.balance - fee_collect_addr_balance,
            0.1 ether
        );
    }

    function test_swap_order() public {
        // mint 1 ether to test wallet 1, 1 ether erc20 to test_wallet_2
        vm.deal(test_wallet_1, 1 ether);
        vm.prank(address(this));
        testERC20.mint(test_wallet_2, 1e18);

        // give contract allowance
        vm.prank(test_wallet_2);
        testERC20.approve(address(easySendCrypto), 1e18);

        string memory pp_string = "test";
        bytes32 pp = keccak256(abi.encodePacked(pp_string));

        uint256 test_wallet_1_eth_balance = test_wallet_1.balance;
        uint256 test_wallet_2_eth_balance = test_wallet_2.balance;
        uint256 fee_collect_addr_eth_balance = fee_collect_address.balance;

        uint256 test_wallet_1_erc20_balance = testERC20.balanceOf(
            test_wallet_1
        );
        uint256 test_wallet_2_erc20_balance = testERC20.balanceOf(
            test_wallet_2
        );
        uint256 fee_collect_addr_erc20_balance = testERC20.balanceOf(
            fee_collect_address
        );

        // add a swap order 1 eth -> 1 erc20
        vm.prank(test_wallet_1);
        easySendCrypto.add_order{value: 1 ether}(
            address(0),
            1 ether,
            pp,
            test_wallet_2,
            true,
            address(testERC20),
            1 ether,
            10000
        );

        assertEq(test_wallet_1_eth_balance - test_wallet_1.balance, 1 ether);
        assertEq(address(easySendCrypto).balance, 1 ether);

        vm.prank(address(this));
        vm.expectRevert("Address not receiver");
        easySendCrypto.claim_asset(pp_string);

        vm.prank(test_wallet_2);
        vm.expectRevert("Passphrase not exist");
        easySendCrypto.claim_asset("test2");

        vm.warp(20000);
        vm.prank(test_wallet_2);
        vm.expectRevert("Swap expired");
        easySendCrypto.claim_asset(pp_string);

        vm.warp(100);

        vm.prank(test_wallet_2);
        easySendCrypto.claim_asset(pp_string);

        assertEq(
            testERC20.balanceOf(test_wallet_1) - test_wallet_1_erc20_balance,
            1 ether - 0.1 ether
        );

        assertEq(test_wallet_1_eth_balance - test_wallet_1.balance, 1 ether);

        assertEq(
            test_wallet_2.balance - test_wallet_2_eth_balance,
            1 ether - 0.1 ether
        );

        assertEq(
            test_wallet_2_erc20_balance - testERC20.balanceOf(test_wallet_2),
            1 ether
        );

        assertEq(
            testERC20.balanceOf(fee_collect_address) -
                fee_collect_addr_erc20_balance,
            0.1 ether
        );
        assertEq(
            fee_collect_address.balance - fee_collect_addr_eth_balance,
            0.1 ether
        );
    }

    function test_retrieve_unclaimed_order() public {
        vm.deal(test_wallet_1, 1 ether);

        uint256 test_wallet_1_balance = test_wallet_1.balance;
        uint256 test_wallet_2_balance = test_wallet_2.balance;
        uint256 fee_collect_addr_balance = fee_collect_address.balance;

        string memory pp_string = "test";
        bytes32 pp = keccak256(abi.encodePacked(pp_string));

        // add a transfer order
        vm.prank(test_wallet_1);
        easySendCrypto.add_order{value: 1 ether}(
            address(0),
            1 ether,
            pp,
            test_wallet_2,
            false,
            address(0),
            0,
            0
        );

        assertEq(test_wallet_1_balance - test_wallet_1.balance, 1 ether);
        assertEq(address(easySendCrypto).balance, 1 ether);

        vm.prank(test_wallet_2);
        vm.expectRevert("Not allow retrieve asset");
        easySendCrypto.retrieve_unclaimed_order(pp);

        vm.prank(test_wallet_1);
        easySendCrypto.retrieve_unclaimed_order(pp);

        assertEq(test_wallet_1_balance - test_wallet_1.balance, 0);
        assertEq(address(easySendCrypto).balance, 0);
    }
}
