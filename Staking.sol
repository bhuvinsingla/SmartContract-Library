// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking {
    IERC20 public stakingToken;
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewards;

    uint256 public rewardRate = 10; // 10% annual

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Cannot stake 0 tokens");

        stakingToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        require(amount <= stakes[msg.sender], "Withdraw amount exceeds stake");

        stakes[msg.sender] -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    function calculateReward(address user) public view returns (uint256) {
        return (stakes[user] * rewardRate) / 100;
    }

    function claimReward() public {
        uint256 reward = calculateReward(msg.sender);
        rewards[msg.sender] += reward;
        stakingToken.transfer(msg.sender, reward);
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
