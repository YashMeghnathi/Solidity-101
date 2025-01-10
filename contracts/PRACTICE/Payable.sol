// SPDX-License-Identifier: MIT
pragma solidity>=0.8.0;   //  The contract works in a way where another person sends Ether to the contract, and then the contract immediately transfers that Ether to the owner.
contract Payable{
    address payable public owner ; //This declares a state variable owner that will hold the Ethereum address of the contract owner.
    constructor (){
        owner=payable(msg.sender);   //ensures that the owner is a payable address, meaning they can receive Ether.
    }
    function transferEth() payable public {// allows anyone to send Ether to the contract
        owner.transfer(msg.value);   // transfers the Ether sent to the contract to the owner's address.The contract sends the Ether to the owner
    }
    function showbalance() public view returns(uint) {
    return owner. balance; 
    }
}