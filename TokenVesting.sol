// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenVesting {
    address public beneficiary;
    uint256 public start;
    uint256 public duration;
    uint256 public released;
    IERC20 public token;

    constructor(address _beneficiary, uint256 _start, uint256 _duration, address _token) {
        beneficiary = _beneficiary;
        start = _start;
        duration = _duration;
        token = IERC20(_token);
    }

    function release() public {
        uint256 unreleased = releasableAmount();
        require(unreleased > 0, "No tokens to release");

        released += unreleased;
        token.transfer(beneficiary, unreleased);
    }

    function releasableAmount() public view returns (uint256) {
        return vestedAmount() - released;
    }

    function vestedAmount() public view returns (uint256) {
        if (block.timestamp < start) {
            return 0;
        } else if (block.timestamp >= start + duration) {
            return token.balanceOf(address(this));
        } else {
            return (token.balanceOf(address(this)) * (block.timestamp - start)) / duration;
        }
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
