// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Escrow is ReentrancyGuard{
    address public buyer;
    address public worker;
    uint public amount;
     bool public taskCompleted = false;
       uint256 public taskCompletionTime;
    uint256 public refundDeadline;

 
    
 constructor(address _worker, uint256 _amount) {
        buyer = msg.sender; 
        worker = _worker;   
        amount = _amount;   
    }
    event addMoney(address indexed buyer, uint amount);
    event taskComplete(address indexed worker,uint completionTime);
    event WorkConfirmed(address indexed buyer, address indexed worker, uint256 confirmationTime);
    event refunding(address indexed buyer,address indexed worker, uint amount) ; 
    
    modifier onlyBuyer(){
        require(buyer==msg.sender,"you are not the buyer");_;}
     modifier onlyWorker(){
        require(worker==msg.sender,"you are not the Worker");_;
    }
    

    function amountAdd () public payable onlyBuyer {
         require(msg.value == amount, "Incorrect amount sent");// ensures that the buyer is sending exactly the amount they promised when interacting with the contract
         emit addMoney(msg.sender,msg.value);
    }
    function completetask() public onlyWorker{

    taskCompleted=true;
     taskCompletionTime = block.timestamp; // Mark the time the task is completed
        refundDeadline = taskCompletionTime + 3 days; 
        emit taskComplete(worker,taskCompletionTime);

    } 
    function confirmWork() public onlyBuyer {
          require(taskCompleted, "Task not completed yet");// if completed means true then only goes to next line
        
         require(block.timestamp <= refundDeadline, "Refund window has closed");
        payable(worker).transfer(amount); // Send funds to the worker
        emit WorkConfirmed(msg.sender,worker,block.timestamp);
    }
    function refund() public onlyBuyer{
          require(!taskCompleted, "Task is already completed, no refund allowed");
  require(block.timestamp <= refundDeadline, "Refund window has closed");
                 emit refunding(buyer,worker,amount);

        payable(buyer).transfer(amount); 
            
    }
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    
}
}
// can add reentrant modifier from impirt
// can add task status