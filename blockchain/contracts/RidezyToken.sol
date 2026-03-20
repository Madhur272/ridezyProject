// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import OpenZeppelin ERC20
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RidezyToken is ERC20, Ownable {

    constructor() 
        ERC20("Ridezy Token", "RZY") 
    {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function rewardDriver(address driver, uint256 amount) public onlyOwner {
        _mint(driver, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
} 