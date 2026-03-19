// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UserRegistry is Ownable {

    enum UserType { RIDER, DRIVER, VEHICLE_OWNER }
    enum VerificationStatus { PENDING, VERIFIED, REJECTED }

    struct User {
        address wallet;
        UserType userType;
        VerificationStatus status;
        uint256 createdAt;
    }

    mapping(address => User) public users;

    event UserRegistered(address user, UserType userType);
    event UserVerified(address user);
    event UserRejected(address user);

    constructor() Ownable(msg.sender) {}

    // Register user
    function registerUser(UserType _userType) external {

        require(users[msg.sender].wallet == address(0), "Already registered");

        users[msg.sender] = User({
            wallet: msg.sender,
            userType: _userType,
            status: VerificationStatus.PENDING,
            createdAt: block.timestamp
        });

        emit UserRegistered(msg.sender, _userType);
    }

    // Verify user (only admin/backend)
    function verifyUser(address _user) external onlyOwner {

        require(users[_user].wallet != address(0), "User not found");

        users[_user].status = VerificationStatus.VERIFIED;

        emit UserVerified(_user);
    }

    // Reject user
    function rejectUser(address _user) external onlyOwner {

        require(users[_user].wallet != address(0), "User not found");

        users[_user].status = VerificationStatus.REJECTED;

        emit UserRejected(_user);
    }

    // Get user details
    function getUser(address _user) external view returns (User memory) {
        return users[_user];
    }
}