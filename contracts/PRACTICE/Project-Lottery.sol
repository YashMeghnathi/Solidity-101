// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
contract Lottery{
    address  public owner;
    address payable []public players;
    address payable public winner;
    constructor (){
        owner = msg.sender;// we are setting the owner variable to the address of the person who deployed the contract
    }
    function participate () public payable{
        require(msg.value==1 ether,"pay 1 ether");
        players.push(payable(msg.sender));//msg.sender: In this case, msg.sender refers to the address of the person calling the participate() function. 
                                           // It can be any participant (not necessarily the owner). 
                                               //This could be Bob, Alice, or Charlie who are joining the lottery.

    }
    function getBal() public view returns(uint){
        require (owner==msg.sender,"you are not the owner");
        return address(this).balance; 
    }
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));// not to use this method as it can be manipulated easily by miners(pseudo-random numbers) can be predicted easily
    }//With an oracle service like Chainlink VRF, you get a provably fair random number that cannot be influenced by miners or external actors.
    function Winner() public {
        require(owner==msg.sender,"you are not the owner");
        require (players.length>=3,"atleast 3 players are required");
uint r = random();
uint index = r%players.length;
winner=players[index];
winner.transfer(getBal());
players=new address payable[](0); //resets the lottery

    }
}


// FLOW OF CONTRACT


// 1. Deployment (by Alice - Contract Owner)
// Alice installs MetaMask and creates a wallet.
// Alice funds her wallet with ETH (to cover gas fees for deploying).
// Alice goes to Remix IDE (https://remix.ethereum.org).
// Alice writes the contract (Lottery contract) in Remix.
// Alice selects the compiler version and compiles the contract in Remix.
// Alice connects MetaMask to Remix by choosing Injected Web3.
// Alice deploys the contract by clicking the "Deploy" button in Remix (confirm the transaction in MetaMask).
// Alice gets the contract address after deployment (shown in Remix).
// 2. Participating in the Lottery (by Bob, Charlie, Dave, etc.)
// Bob/Charlie/Dave installs MetaMask and sets up a wallet.
// Bob/Charlie/Dave funds their MetaMask wallet with 1 ether (for participating in the lottery + gas fees).
// Bob/Charlie/Dave gets the contract address from Alice (contract owner).
// Bob/Charlie/Dave goes to Remix or Etherscan (if using Remix, select Injected Web3 and enter the contract address).
// Bob/Charlie/Dave finds the participate() function in Remix/Etherscan.
// Bob/Charlie/Dave calls the participate() function and sends 1 ether to the contract (confirm the transaction in MetaMask).
// Bob/Charlie/Dave’s participation is confirmed once the transaction is mined (they can check on Etherscan).
// 3. Owner Selecting the Winner (by Alice)
// Alice checks the players array to ensure there are at least 3 participants (Bob, Charlie, Dave).
// Alice calls the Winner() function on Remix or Etherscan to select a random winner.
// Winner is selected randomly using the random() function (based on block data and players array).
// The winner’s address is transferred the total balance of the contract (prize) via winner.transfer(getBal()).
// Players array is reset after the winner is chosen, and the lottery is ready for the next round.
// 4. Confirming the Winner
// The winner (Bob/Charlie/Dave) receives the total prize (ether) in their wallet.
// Everyone checks Etherscan to confirm the winner and the prize transaction.
// The lottery contract is now reset, and new participants can join the next round.
// This flow covers the steps from deployment to participation and winning in the lottery.


