// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint256) private balances;
    address[] private depositors;
    uint256 public totalBalance;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        if (balances[msg.sender] == 0) {
            depositors.push(msg.sender);
        }

        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        totalBalance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Invalid recipient address");
        require(amount <= balances[msg.sender], "Insufficient balance");

        if (balances[to] == 0) {
            depositors.push(to);
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;

        assert(totalBalance == address(this).balance);
    }

    function checkInvariant() public view onlyOwner {
        uint256 calculatedTotalBalance = 0;
        for (uint256 i = 0; i < depositors.length; i++) {
            calculatedTotalBalance += balances[depositors[i]];
        }
        assert(calculatedTotalBalance == totalBalance);
    }

    function unsafeFunction() public pure {
        revert("This function is unsafe and should not be called");
    }
}
