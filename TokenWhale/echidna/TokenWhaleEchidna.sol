// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.13;

import "../src/TokenWhale.sol";

contract Users {
    function proxy(address target, bytes memory data) public returns (bool success, bytes memory retData) {
        return target.call(data);
    }
}

contract TokenWhaleEchidna {
    TokenWhale token;

    Users Alice = new Users();
    Users Bob = new Users();
    Users Pete = new Users();

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        token = new TokenWhale(address(this));
    }

    function transfer(uint256 amount) public {
        emit Transfer(address(this), address(Alice), amount);
        uint256 prevBal = token.balanceOf(address(this));
        amount = _between(amount, 1, prevBal);
        token.transfer(address(Alice), amount);
    }

    function approve(uint256 amount) public {
        uint256 prevBal = token.balanceOf(address(Alice));
        amount = _between(amount, 1, prevBal);
        Alice.proxy(address(token), abi.encodeWithSelector(token.approve.selector, address(this), amount));
        emit Approval(address(Alice), address(this), amount);
    }

    function transferFrom(address to, uint256 amount) public {
        uint256 prevBal = token.balanceOf(address(Alice));
        amount = _between(amount, 1, prevBal);
        token.transferFrom(address(Alice), to, amount);
        emit Transfer(address(this), to, amount);
    }

    function testSolved() public view {
        assert(!token.isComplete());
    }

    function _between(uint256 val, uint256 lower, uint256 upper) internal pure returns (uint256) {
        return lower + (val % (upper - lower + 1));
    }
}
