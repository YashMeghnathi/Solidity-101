// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20{
    address public admin;
    constructor() ERC20 ("My Token","YIZzz"){
        _mint(msg.sender, 10000*10**18);
        admin=msg.sender;
    }
    function mint(address _to,uint _value) public {
        require(msg.sender==admin);
        _mint(_to, _value );
    }
     function burn(uint amount) public {
    _burn(msg.sender,amount);
 }

}