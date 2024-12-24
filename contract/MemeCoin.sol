// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TheUnlimitedCoin is ERC20 {

    // Constructor to mint an initial supply to the contract itself
    constructor() ERC20("THEBESTCOIN", "TBC") {
        _mint(address(this), 10000000000000 * 10**18); // Total supply of 10 trillion tokens
    }

    // Function to claim tokens. No limit on claims per address.
    function claimTokens(uint256 amount) external {
        _transfer(address(this), msg.sender, amount);
    }

    // Function to mint new tokens from any address to any address
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}