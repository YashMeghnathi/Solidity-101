// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
contract SimpleBank{
    address public owner;
    constructor(){
        owner=msg.sender;
    }
    mapping(address=>uint) public usersdepo;
    


    function deposit() payable public {
        usersdepo[msg.sender] += msg.value; //increases the deposit of the caller he gives 3 ether and then give 5 -  usersdepo[msg.sender] += msg.value(3); and then 5 so total 8
    }
    function getbal() public view returns(uint){
       return address(this).balance;
    }
    function withdraw() public {// gives to the owner 
            require(msg.sender == owner, "Only the owner can transfer funds");

       payable(owner).transfer(address(this).balance);
    }
        function transferTo(address payable _to, uint _amount) public {// gives directly to someone but by only owner
        require(msg.sender == owner, "Only the owner can transfer funds");
        require(address(this).balance >= _amount, "Insufficient balance in the contract");
        _to.transfer(_amount);  // Transfer the specified amount to the provided address
    }
    function tocheckownerbal() public view returns(uint){
        return owner.balance;
    }
    function togetusersdepo(address _user) public view returns(uint){
        return usersdepo[_user];
    }

}



// pragma solidity >=0.8.0;
// contract TimeRestrictedAccess{

//     address public owner;
//     uint public startTime;
//     constructor(uint _startTime){
//         owner=msg.sender;
//         startTime=_startTime;
//     }
//     function deposit() payable public {
//         require(block.timestamp>=startTime,"time not started");
//     }
//     function getBal() public view returns(uint){
//         return address(this).balance;
//     }
//         function withdraw() public {
//         require(msg.sender == owner, "Only the owner can withdraw");
//         payable(owner).transfer(address(this).balance);
//     }


// }