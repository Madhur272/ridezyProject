// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VehicleWallet is Ownable {

    struct Wallet {
        uint256 balance;
        address owner;
    }

    // vehicleId → wallet
    mapping(uint256 => Wallet) public vehicleWallets;

    event WalletCreated(uint256 vehicleId, address owner);
    event Deposit(uint256 vehicleId, uint256 amount);
    event Withdrawal(uint256 vehicleId, uint256 amount);

    // Create wallet for vehicle
    function createWallet(uint256 vehicleId, address owner) external onlyOwner {

        require(vehicleWallets[vehicleId].owner == address(0), "Already exists");

        vehicleWallets[vehicleId] = Wallet({
            balance: 0,
            owner: owner
        });

        emit WalletCreated(vehicleId, owner);
    }

    // Deposit earnings
    function deposit(uint256 vehicleId) external payable {

        require(vehicleWallets[vehicleId].owner != address(0), "Wallet not found");
        require(msg.value > 0, "No amount sent");

        vehicleWallets[vehicleId].balance += msg.value;

        emit Deposit(vehicleId, msg.value);
    }

    // Withdraw earnings
    function withdraw(uint256 vehicleId, uint256 amount) external {

        Wallet storage w = vehicleWallets[vehicleId];

        require(msg.sender == w.owner, "Not owner");
        require(w.balance >= amount, "Insufficient balance");

        w.balance -= amount;

        payable(msg.sender).transfer(amount);

        emit Withdrawal(vehicleId, amount);
    }

    // Get balance
    function getBalance(uint256 vehicleId) external view returns (uint256) {
        return vehicleWallets[vehicleId].balance;
    }
}