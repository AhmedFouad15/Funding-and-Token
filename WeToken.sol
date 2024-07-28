// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC20.sol";

/* Basic token contract please refer to Solidity docs for more info
I changed the data of the token and added only owner error and added it into mint so only owner can mint
and total supply which cant be exceded and current supply which changes when burn or mint happens
**IMPORTANT NOTE**
The burn function reduce the current supply so if some tokens is burned it can be minted again so if you want
to not be able to re mint the burned token you can delete the change of current supply
*/
contract ERC20 is IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );


    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "WEToken";
    string public symbol = "WE";
    uint8 public decimals = 0;
    uint256 public currentsupply;
    uint256 public totalSupply = 10000000;
    address public  immutable  i_owner;

error NotOwner();

 constructor() {
        i_owner = msg.sender;
    }

modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool)
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal onlyOwner {
          balanceOf[to] += amount;
          emit Transfer(address(0), to, amount);
          currentsupply = amount + currentsupply;

    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        currentsupply = currentsupply - amount ;
        emit Transfer(from, address(0), amount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
    // you can delete the if and only pu this command  _mint(to, amount); then close the function
       if (currentsupply + amount <= totalSupply){
         _mint(to, amount);
    } else{
          revert("Exceeds Total Supply");
       }
       
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
