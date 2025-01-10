// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract Crowdfunding is ReentrancyGuard{

    address public manager;
    string public purpose;
    uint public deadline;

    mapping(address=>uint) public donators;

    uint public noofdonators;

    modifier onlyManager(){
        require(msg.sender==manager,"Only the manager can call this function");
        _;
    }

    modifier donationON (){
     require(block.timestamp<deadline,"The donation period has ended");
     _;
    }

    modifier donationOFF (){
            require(block.timestamp >= deadline, "The donation period is still ongoing");
            _;
    }
    event DonationMade(address indexed donator, uint amount );
    event FundsWithdrawn(address indexed manager, uint amount);
    event PurposeUpdated(string newPurpose);


    constructor(string memory _purpose,uint _deadline){
        manager=msg.sender;
        purpose=_purpose;
        deadline=block.timestamp+_deadline;
    }

    function donate() public payable donationON {
        require(msg.value>=10 ether,"at least pay 10 ether");

        if(donators[msg.sender]==0)
        {
            noofdonators++;
        }
             donators[msg.sender] += msg.value;//how much he has given from his address
      emit DonationMade(msg.sender,msg.value);
     }
    
    function withdraw() public onlyManager donationOFF {
        uint balance=address(this).balance;
        payable(manager).transfer(balance);
        emit FundsWithdrawn (msg.sender, balance);
     }

    function updatePurpose(string memory _newPurpose) public onlyManager{
         purpose=_newPurpose;
             emit PurposeUpdated(_newPurpose);
     }

    function donatorshistory() public view returns(uint){
            require(donators[msg.sender] > 0, "You haven't donated yet"); // for overflow handle some can direct see these without dnating so this prevent overflow
            return  donators[msg.sender] ;
     }

    function returndonators() public view returns(uint){
        return noofdonators;
     }

    function getBal() public view returns(uint256){
        return address(this).balance;

     }
        
    
}

// can add minimum donation limit now it is 10 ether fix 
//but with changing purpose can change it just add it in constructor
// can add refund function
// can add total funds raised
// can add donation goal



