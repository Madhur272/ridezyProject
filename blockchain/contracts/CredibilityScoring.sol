// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CredibilityScoring is Ownable {

    struct DriverScore {
        uint256 score;        // 0–100
        uint256 totalRides;
        uint256 violations;
        uint256 lastUpdated;
    }

    mapping(address => DriverScore) public driverScores;

    event DriverRegistered(address driver);
    event ScoreUpdated(address driver, uint256 newScore);
    event ViolationRecorded(address driver, uint256 penalty);

    // Register driver with default score
    function registerDriver(address driver) external onlyOwner {

        require(driverScores[driver].score == 0, "Already registered");

        driverScores[driver] = DriverScore({
            score: 75,
            totalRides: 0,
            violations: 0,
            lastUpdated: block.timestamp
        });

        emit DriverRegistered(driver);
    }

    // Record violation (AI/IoT triggered)
    function recordViolation(address driver, uint256 penalty) external onlyOwner {

        DriverScore storage d = driverScores[driver];

        require(d.score > 0, "Driver not registered");

        d.violations += 1;

        if (d.score > penalty) {
            d.score -= penalty;
        } else {
            d.score = 0;
        }

        d.lastUpdated = block.timestamp;

        emit ViolationRecorded(driver, penalty);
        emit ScoreUpdated(driver, d.score);
    }

    // Reward driver after ride completion
    function rewardDriver(address driver, uint256 reward) external onlyOwner {

        DriverScore storage d = driverScores[driver];

        require(d.score > 0, "Driver not registered");

        d.totalRides += 1;

        d.score += reward;

        if (d.score > 100) {
            d.score = 100;
        }

        d.lastUpdated = block.timestamp;

        emit ScoreUpdated(driver, d.score);
    }

    // Get score
    function getScore(address driver) external view returns (DriverScore memory) {
        return driverScores[driver];
    }
}