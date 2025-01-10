// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Auction is ReentrancyGuard {
    address public owner;
    
    // Newly Added: Auction State Flag to track if the auction has ended
    bool public auctionEnded;  // New feature

    struct bidder {
        string name;
        uint id;
    }

    mapping(address => bidder) public bidderInfo;
    uint public timeend;
    string public item;
    address public highestbidder;
    uint public highestbid;

    // Events
    event BidPlaced(address indexed bidder, uint amount);
    event AuctionEnded(address indexed winner, uint amount);
    event NewBidderAdded(address indexed bidder, string name, uint id);

    // Newly Added: Event for extending auction time
    event AuctionExtended(uint newEndTime);  // New feature

    constructor(uint _timeend, string memory _item) {
        owner = msg.sender;
        timeend = block.timestamp + _timeend;
        item = _item;
        
        // Newly Added: Auction state set to "not ended" when initialized
        auctionEnded = false;  // New feature
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }

    modifier AuctionTime() {
        require(block.timestamp < timeend && !auctionEnded, "Auction has ended");
        _;
    }

    modifier Endtime() {
        require(block.timestamp >= timeend, "Auction is still ongoing");
        _;
    }

    function addbidder(string memory _name, uint _id) public onlyOwner {
        bidderInfo[msg.sender] = bidder(_name, _id);
        emit NewBidderAdded(msg.sender, _name, _id);
    }

    function bid() public payable AuctionTime {
        require(msg.value > highestbid, "Your bid must be higher than the current highest bid");

        if (highestbid != 0) {
            address previousHighestBidder = highestbidder;
            uint previousHighestBid = highestbid;

            highestbidder = msg.sender;
            highestbid = msg.value;

            // Using `call` for safety against reentrancy
            (bool success, ) = previousHighestBidder.call{value: previousHighestBid}("");
            require(success, "Previous bid refund failed");
        } else {
            highestbidder = msg.sender;
            highestbid = msg.value;
        }

        emit BidPlaced(msg.sender, msg.value);
    }

    function endAuction() public onlyOwner Endtime {
        require(!auctionEnded, "Auction has already ended");
        
        // Newly Added: Mark the auction as ended
        auctionEnded = true;  // New feature
        
        payable(owner).transfer(highestbid);
        emit AuctionEnded(highestbidder, highestbid);
    }

    // Newly Added: Function to extend auction time
    function extendAuction(uint additionalTime) public onlyOwner {
        require(!auctionEnded, "Auction has already ended");
        
        timeend += additionalTime;
        emit AuctionExtended(timeend);  // New feature
    }


    function getBidderData(address _bidder) public view returns (string memory name, uint id) {
        bidder memory Bidder = bidderInfo[_bidder];
        return (Bidder.name, Bidder.id);
    }
}
