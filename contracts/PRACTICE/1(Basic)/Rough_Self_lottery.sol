// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Lottery is ReentrancyGuard {
    address private manager;
    address payable[] public players;
    address payable public Winner;
    uint public minimumval;
    uint public lotteryEndTime;
    
    // Event declarations
    event Participated(address indexed player, uint amount);
    event WinnerDeclared(address indexed winner, uint amount);
    event LotteryEnded(uint prizeAmount, address indexed winner);

    constructor(uint _minimumval, uint _durationInMinutes) {
        manager = msg.sender;
        minimumval = _minimumval;
        lotteryEndTime = block.timestamp + _durationInMinutes * 1 minutes; // Lottery duration in minutes
    }

    modifier onlyManager() {
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    modifier hasEnded() {
        require(block.timestamp >= lotteryEndTime, "Lottery has not ended yet");
        _;
    }

    function participate() payable public {
        require(msg.value > minimumval, "At least pay the minimum value");
        require(block.timestamp < lotteryEndTime, "Lottery has already ended");
        players.push(payable(msg.sender));
        emit Participated(msg.sender, msg.value); // Emit participation event
    }

    function checkBal() public view returns(uint) {
        return address(this).balance;
    }

    // Simplified randomness using block.prevrandao (not recommended for production)
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function win() public onlyManager hasEnded nonReentrant {
        require(players.length > 3, "Not enough players");

        uint r = random();  // Use simplified random number generation
        uint index = r % players.length;  // Select winner based on randomness
        Winner = players[index];
        uint prizeAmount = address(this).balance;

        Winner.transfer(prizeAmount);
        emit WinnerDeclared(Winner, prizeAmount);
        emit LotteryEnded(prizeAmount, Winner); // Emit lottery end event

        // Reset the lottery for the next round
        delete players;
        lotteryEndTime = block.timestamp + 5 minutes; // Next lottery duration reset
    }
}

// can add lottery end after time end
//what if there is no participants
// chainlink vrf