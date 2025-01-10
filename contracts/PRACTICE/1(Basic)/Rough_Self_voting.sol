// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract voting is ReentrancyGuard {
    address private owner;
    uint public votingStartTime;
    uint public votingEndTime;

    struct candids {
        string name;
        string partyname;
    }

    struct voter {
        string name;
        uint id;
        address voterAddress;
    }

    voter[] public voterd; // Array to store voter information
    candids[] public Candidates; // Array to store candidate information

    constructor() {
        owner = msg.sender;
        votingStartTime = block.timestamp;
        votingEndTime = votingStartTime + 1 weeks; // Voting lasts for 1 week
    }

    event Voted(address indexed voter, uint indexed candidateIndex);
    event CandidateAdded(string name, string partyname);

    modifier onlyDuringVotingPeriod() {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting period has ended");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    modifier hasVotingEnded() {
        require(block.timestamp > votingEndTime, "Voting period is still active");
        _;
    }

    mapping(address => bool) public voters; // Maps voter addresses to whether they have voted
    mapping(uint => uint) public candidateVotes; // Maps candidate indexes to the number of votes

    // Add a candidate (only by the owner)
    function addCandid(string memory _name, string memory _partyname) public onlyOwner {
        Candidates.push(candids(_name, _partyname));
        emit CandidateAdded(_name, _partyname);
    }

    // Add a voter (only by the owner)
    function addvoter(string memory _name, uint _id, address _voterAddress) public onlyOwner {
        require(voters[_voterAddress] == false, "Voter already exists");
        require(_voterAddress != address(0), "Invalid address");
        
        voterd.push(voter(_name, _id, _voterAddress)); // Store the voter information in the array
        voters[_voterAddress] = false; // Mark the voter as not voted
    }

    // Vote for a candidate (only during the voting period)
    function vote(uint _candidateIndex) public onlyDuringVotingPeriod nonReentrant {
        require(voters[msg.sender] == false, "You have already voted!"); // Ensure the sender hasn't already voted
        require(_candidateIndex < Candidates.length, "Invalid candidate index"); // Ensure the candidate index is valid
        
        voters[msg.sender] = true; // Mark the sender as voted
        candidateVotes[_candidateIndex]++; // Increment the vote count for the selected candidate
        emit Voted(msg.sender, _candidateIndex); // Emit a Voted event
    }

    // Get the result of the voting (only by the owner)
    function result() public view onlyOwner returns (string memory winnerName, string memory winnerParty) {
        uint maxVotes = 0;
        uint winnerIndex = 0;

        // Determine the winner by finding the candidate with the most votes
        for (uint i = 0; i < Candidates.length; i++) {
            if (candidateVotes[i] > maxVotes) {
                maxVotes = candidateVotes[i];
                winnerIndex = i;
            }
        }

        winnerName = Candidates[winnerIndex].name;
        winnerParty = Candidates[winnerIndex].partyname;
    }

    // Reset the voting (only by the owner, after the voting period has ended)
    function resetVoting() public onlyOwner hasVotingEnded nonReentrant {
        // Reset the votes for all candidates
        for (uint i = 0; i < Candidates.length; i++) {
            candidateVotes[i] = 0;
        }

        // Reset the voting status for each registered voter
        for (uint i = 0; i < voterd.length; i++) {
            voters[voterd[i].voterAddress] = false; // Reset the voting status for each voter using their address
        }
    }
}
