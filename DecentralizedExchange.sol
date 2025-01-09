// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedExchange {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public rate; // Exchange rate: tokenA to tokenB

    constructor(address _tokenA, address _tokenB, uint256 _rate) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        rate = _rate;
    }

    function swapAForB(uint256 amountA) public {
        require(amountA > 0, "Amount must be greater than 0");

        uint256 amountB = (amountA * rate) / 1e18;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    function swapBForA(uint256 amountB) public {
        require(amountB > 0, "Amount must be greater than 0");

        uint256 amountA = (amountB * 1e18) / rate;
        tokenB.transferFrom(msg.sender, address(this), amountB);
        tokenA.transfer(msg.sender, amountA);
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
