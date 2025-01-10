// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Auction is ReentrancyGuard{
    address public owner;
    struct bidder{
        string name;
        uint id;
    }
     mapping(address => bidder) public bidderInfo;

    bidder[] public bidders;
    uint  public timeend;
    string public item;
    address public highestbidder;
    uint public highestbid;
    event BidPlaced(address indexed bidder, uint amount);
    event AuctionEnded(address indexed winner, uint amount);
    event NewBidderAdded(address indexed bidder, string name, uint id);

    constructor(uint _timeend, string memory _item){
        owner=msg.sender;
        timeend=block.timestamp+_timeend;
        item=_item;
    }
    modifier onlyOwner(){
        require(owner==msg.sender,"you are not the owner");
        _;
    }
    modifier AuctionTime(){
        require(block.timestamp<timeend,"ended");          // abki ka time< khatam hone ke time se(time hai khatam hone mein)

        _;
    }
    modifier Endtime(){
        require(block.timestamp>=timeend,"still going on");// abhi ka time bada hai > khatam hone ke time se (time khatam auction ka)
        _;
    }
    function addbidder(string memory _name, uint _id) public  onlyOwner{
        bidders.push(bidder(_name,_id));
                bidderInfo[msg.sender] = bidder(_name, _id);
                        emit NewBidderAdded(msg.sender, _name, _id);  // Log the event


    }
    function bid() public payable AuctionTime{
        require(msg.value > highestbid, "There already is a higher bid");

        if (highestbid != 0) {
            address previousHighestBidder = highestbidder;
            uint previousHighestBid = highestbid;

            highestbidder = msg.sender;
            highestbid = msg.value;

            payable(previousHighestBidder).transfer(previousHighestBid);
        } else {
            highestbidder = msg.sender;
            highestbid = msg.value;
        }
                emit BidPlaced(msg.sender, msg.value);  // Log the bid event

    }
    function endAuction() public onlyOwner Endtime {
        // Transfer the highest bid to the owner
        payable(owner).transfer(highestbid);
                emit AuctionEnded(highestbidder, highestbid);  // Log the auction end event

    }
    function getAuctionDetails() public view returns (string memory, uint, address, uint) {
        return (item, timeend, highestbidder, highestbid);
    }
    function getBidderData(address _bidder) public view returns (string memory name, uint id) {
        bidder memory Bidder = bidderInfo[_bidder];
        return (Bidder.name, Bidder.id);
    }
    }
    // can extend time of auction here// new feature
    // can let people know of endin the auction //new feature


