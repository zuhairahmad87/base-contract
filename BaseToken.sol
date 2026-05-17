// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BaseToken
 * @dev Simple ERC-20 token contract optimized for Base chain
 * Easy to deploy and use token standard
 */

contract BaseToken {
    string public name = "Base Token";
    string public symbol = "BASE";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /**
     * @dev Transfer tokens to another address
     * @param to The recipient address
     * @param value The amount of tokens to transfer
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve tokens for spending by another address
     * @param spender The address authorized to spend tokens
     * @param value The amount of tokens to approve
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid address");
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens on behalf of another address
     * @param from The sender address
     * @param to The recipient address
     * @param value The amount of tokens to transfer
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Burn tokens (remove from circulation)
     * @param value The amount of tokens to burn
     */
    function burn(uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        totalSupply -= value;

        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
        return true;
    }

    /**
     * @dev Mint new tokens (only owner)
     * @param to The recipient address
     * @param value The amount of tokens to mint
     */
    function mint(address to, uint256 value) public onlyOwner returns (bool) {
        require(to != address(0), "Invalid address");

        balanceOf[to] += value;
        totalSupply += value;

        emit Transfer(address(0), to, value);
        return true;
    }
}
