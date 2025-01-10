// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
contract CrowdFunding{
    mapping(address=>uint256) public Contributers;
    address public manager;
    uint public minContri;
    uint public deadline;
    uint public Target;
    uint public raisedAmnt;
    uint public noOFcontibutors;

    constructor( uint _deadline, uint _Target ){
        deadline=block.timestamp+_deadline;
         Target=_Target;
         minContri=10 ether;
         manager=msg.sender;
    }
    struct Request{
        string description ;
        address payable recipient;
        uint value ;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;

    }
    mapping(uint=>Request) public requests;
uint public numRequests;

    function SendEth() payable public{
        require(msg.value>=minContri,"atleast give 10 ethers");// function is about it gives how much a person has donated and count money and donatons
        require(block.timestamp<deadline,"time has ended");//
        if(Contributers[msg.sender]==0){// it is like that when anyone has to send ether again it sets there count to 0 as already given,if he is new or not
        noOFcontibutors++;}//
        Contributers[msg.sender]+=msg.value;//how much he has given from his address
        raisedAmnt+=msg.value;// ra=0+10(msg.value)=10// ra=10+10=20==ra==20+12=32==ra
    }
    function getBal() public view returns(uint256){
        return address(this).balance;
    }
    function Refund() public{
        require(block.timestamp>deadline && raisedAmnt<Target,"refund available");
        require(Contributers[msg.sender]>0);// for those who havent give any money
     address payable user= payable (msg.sender);// creating new user S BECAUSE WE HAVE to EXPLICITLY create a payable for msg.sender
    user.transfer(Contributers[msg.sender]);// transferring back
    Contributers[msg.sender]=0;
    }
    function createreq( string memory _description,
        address payable _recipient,
        uint _value )public {
            require(msg.sender==manager,"you are not the manager");
             Request storage newRequest= requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;

        }
    function voteRequest(uint _requestNo) public{
        require(Contributers[msg.sender]>0,"YOu must be contributor");
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public {
         require(Contributers[msg.sender]>0,"YOu must be contributor");
         require(raisedAmnt>=Target);
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.completed==false,"The request has been completed");
        require(thisRequest.noOfVoters > noOFcontibutors/2,"Majority does not support");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
    }


}