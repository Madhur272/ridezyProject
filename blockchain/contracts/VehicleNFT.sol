// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VehicleNFT is ERC721, Ownable {

    uint256 public tokenCounter;

    struct Vehicle {
        uint256 tokenId;
        address owner;
        string metadataURI; 
        uint256 createdAt;
    }

    mapping(uint256 => Vehicle) public vehicles;

    event VehicleRegistered(uint256 tokenId, address owner);

    constructor() ERC721("Ridezy Vehicle", "RZV") 
    {
        tokenCounter = 0;
    }

    function registerVehicle(string memory _metadataURI) external {

        uint256 tokenId = tokenCounter;

        _safeMint(msg.sender, tokenId);

        vehicles[tokenId] = Vehicle({
            tokenId: tokenId,
            owner: msg.sender,
            metadataURI: _metadataURI,
            createdAt: block.timestamp
        });

        tokenCounter++;

        emit VehicleRegistered(tokenId, msg.sender);
    }

    function getVehicle(uint256 tokenId) external view returns (Vehicle memory) {
        return vehicles[tokenId];
    }
}