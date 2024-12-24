// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GuessGame {
    // Meme Coin contract interface
    IERC20 public memeCoin;

    // Game settings
    uint256 public correctNumber;  // The number to be guessed
    mapping(address => uint256) public attempts;

    // Events for transparency
    event GameStarted(address indexed player, uint256 correctNumber);
    event GuessMade(address indexed player, uint256 guess, string feedback);
    event PrizeWon(address indexed player, uint256 prize);

    // Constructor: Initialize with MemeCoin contract address and correct number
    constructor(address _memeCoinAddress, uint256 _correctNumber) {
        memeCoin = IERC20(_memeCoinAddress);
        correctNumber = _correctNumber;  // Set the correct number during deployment
        emit GameStarted(msg.sender, correctNumber);
    }

    // Function to claim initial tokens (100 meme coins)
    function claimInitialTokens() external {
        uint256 initialAmount = 100 * 10**18; // 100 tokens (assuming 18 decimals)
        require(memeCoin.balanceOf(address(this)) >= initialAmount, "Not enough tokens in contract");
        require(memeCoin.transfer(msg.sender, initialAmount), "Token transfer failed");
    }

    // Function to start a new game (for demonstration purposes)
    function startNewGame() external {
        // Resetting the attempts for a new game (correct number remains the same)
        attempts[msg.sender] = 0;
        emit GameStarted(msg.sender, correctNumber);
    }

    // Function to submit a guess and get feedback
    function guessNumber(uint256 guess) external {
        require(guess >= 1 && guess <= 100, "Guess must be between 1 and 100");

        // Charge 10 meme coins to play
        uint256 entryFee = 10 * 10**18; // 10 meme coins
        require(memeCoin.transferFrom(msg.sender, address(this), entryFee), "Payment failed");

        // Increment attempts
        attempts[msg.sender]++;

        // Provide feedback
        string memory feedback;
        if (guess < correctNumber) {
            feedback = "Your guess is too low!";
        } else if (guess > correctNumber) {
            feedback = "Your guess is too high!";
        } else {
            feedback = "Congratulations! You guessed the correct number!";
            // Award the player with 10 meme coins as a reward
            uint256 reward = 10 * 10**18; // 10 meme coins
            require(memeCoin.transfer(msg.sender, reward), "Reward transfer failed");
            emit PrizeWon(msg.sender, reward);
        }

        emit GuessMade(msg.sender, guess, feedback);
    }

    // Function to view the number of attempts by a player
    function getAttempts(address player) external view returns (uint256) {
        return attempts[player];
    }
}
