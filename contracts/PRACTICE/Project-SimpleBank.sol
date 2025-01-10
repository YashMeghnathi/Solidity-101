// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {

    // Mapping to store the balances of each user
    mapping(address => uint256) public balances;

    // Deposit function to send Ether to the contract
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0"); // how much user a has   depodited in contract
        
        // Increase the sender's balance by the amount sent
        balances[msg.sender] += msg.value;
    }

    // Withdraw function to send Ether from the contract to another person or the sender
    function withdraw(uint256 amount, address payable recipient) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        
        // Decrease the sender's balance
        balances[msg.sender] -= amount;

        // Transfer Ether to the recipient (this could be another user, not msg.sender)
        recipient.transfer(amount);
    }

    // Function to check the contract's balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance; // This is the balance of the contract
    }

    // Function to check an individual's balance (of the caller)
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Function to check another user's balance
    function getUserBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}




