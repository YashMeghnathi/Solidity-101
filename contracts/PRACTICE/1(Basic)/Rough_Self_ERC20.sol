// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
contract ERC20{
    string public name="simpleERC20";
    string public symbol="serc20";
    uint public digit=18;
    mapping(address=>uint) balanceof;
    uint public totalsupply;
    constructor(uint _initialsupply){
        totalsupply= _initialsupply * 10 ** uint256(digit);
        balanceof[msg.sender] = totalsupply;

    }
    function supply(address _to, uint amount) public returns (bool){
       require(_to != address(0), "Invalid address");
      require(balanceof[msg.sender]>amount,"insuffi bakl");
      balanceof[msg.sender]-=amount;
      balanceof[_to]+=amount;
      return true;
    }
    function bal() public view returns(uint){
       return balanceof[msg.sender];
    }
}