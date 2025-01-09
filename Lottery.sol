// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public participants;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 0.1 ether, "Must send 0.1 ether to participate");

        participants.push(msg.sender);
    }

    function drawWinner() public restricted {
        require(participants.length > 0, "No participants in the lottery");

        uint256 winnerIndex = random() % participants.length;
        payable(participants[winnerIndex]).transfer(address(this).balance);
        participants = new address  }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, participants.length)));
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }
}
