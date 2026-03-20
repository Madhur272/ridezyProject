// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RidePaymentEscrow is Ownable {

    enum RideStatus { CREATED, COMPLETED, DISPUTED, CANCELLED }

    struct Ride {
        address rider;
        address driver;
        uint256 amount;
        RideStatus status;
    }

    mapping(uint256 => Ride) public rides;

    event RideCreated(uint256 rideId, address rider, uint256 amount);
    event RideCompleted(uint256 rideId, address driver);
    event RideDisputed(uint256 rideId);
    event RideCancelled(uint256 rideId);

    // Rider locks payment
    function createRide(uint256 rideId, address driver) external payable {

        require(rides[rideId].rider == address(0), "Ride exists");
        require(msg.value > 0, "Payment required");

        rides[rideId] = Ride({
            rider: msg.sender,
            driver: driver,
            amount: msg.value,
            status: RideStatus.CREATED
        });

        emit RideCreated(rideId, msg.sender, msg.value);
    }

    // Complete ride → release payment
    function completeRide(uint256 rideId) external {

        Ride storage ride = rides[rideId];

        require(ride.status == RideStatus.CREATED, "Invalid state");
        require(msg.sender == ride.rider, "Only rider can confirm");

        ride.status = RideStatus.COMPLETED;

        payable(ride.driver).transfer(ride.amount);

        emit RideCompleted(rideId, ride.driver);
    }

    // Raise dispute
    function raiseDispute(uint256 rideId) external {

        Ride storage ride = rides[rideId];

        require(
            msg.sender == ride.rider || msg.sender == ride.driver,
            "Unauthorized"
        );

        ride.status = RideStatus.DISPUTED;

        emit RideDisputed(rideId);
    }

    // Admin resolves dispute
    function resolveDispute(uint256 rideId, bool payDriver) external onlyOwner {

        Ride storage ride = rides[rideId];

        require(ride.status == RideStatus.DISPUTED, "Not disputed");

        if (payDriver) {
            payable(ride.driver).transfer(ride.amount);
        } else {
            payable(ride.rider).transfer(ride.amount);
        }

        ride.status = RideStatus.COMPLETED;
    }

    // Cancel ride (before start)
    function cancelRide(uint256 rideId) external {

        Ride storage ride = rides[rideId];

        require(msg.sender == ride.rider, "Only rider");
        require(ride.status == RideStatus.CREATED, "Cannot cancel");

        ride.status = RideStatus.CANCELLED;

        payable(ride.rider).transfer(ride.amount);

        emit RideCancelled(rideId);
    }
}