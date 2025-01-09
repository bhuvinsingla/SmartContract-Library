// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint256 public required;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => mapping(address => bool)) public approvals;

    uint256 public transactionCount;

    constructor(address[] memory _owners, uint256 _required) {
        owners = _owners;
        required = _required;
    }

    function submitTransaction(address to, uint256 value) public {
        require(isOwner(msg.sender), "Not an owner");
        transactionCount++;
        transactions[transactionCount] = Transaction(to, value, false);
    }

    function approveTransaction(uint256 transactionId) public {
        require(isOwner(msg.sender), "Not an owner");
        approvals[transactionId][msg.sender] = true;
    }

    function executeTransaction(uint256 transactionId) public {
        Transaction storage txn = transactions[transactionId];
        require(!txn.executed, "Transaction already executed");
        require(isApproved(transactionId), "Not enough approvals");

        txn.executed = true;
        payable(txn.to).transfer(txn.value);
    }

    function isOwner(address account) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == account) return true;
        }
        return false;
    }

    function isApproved(uint256 transactionId) public view returns (bool) {
        uint256 count = 0;
        for (uint256 i = 0; i < owners.length; i++) {
            if (approvals[transactionId][owners[i]]) count++;
        }
        return count >= required;
    }
}
