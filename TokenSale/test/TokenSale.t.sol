// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenSale.sol";

contract TokenSaleTest is Test {
    TokenSale public tokenSale;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        tokenSale = (new TokenSale){value: 1 ether}();
        exploitContract = new ExploitContract(tokenSale);
        vm.deal(address(exploitContract), 4 ether);
    }

    // Use the instance of tokenSale and exploitContract
    function testIncrement() public {
        // Put your solution here
        exploitContract.attack();
        _checkSolved();
    }

    // function testIncrement() public {
    //     uint256 numTokens = 115792089237316195423570985008687907853269984665640564039458;

    //     uint256 total = 0;
    //     unchecked {
    //         total += numTokens * 1 ether;
    //     }
    //     //vm.assume(total < 4 ether);
    //     vm.assume(numTokens != 0);
    //     //tokenSale.buy{value: total}(numTokens);
    //     console.log(total);
    //     assertTrue(total >= 4 ether);
    // }

    // function invariant_lessToken() public {
    //     assertGe(4 ether, alice.balance);
    // }

    function _checkSolved() internal {
        assertTrue(tokenSale.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
