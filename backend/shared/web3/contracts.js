const wallet = require("./wallet");
const { ethers } = require("ethers");

// Import ABIs
const UserRegistry = require("./abi/UserRegistry.json");
const Escrow = require("./abi/RidePaymentEscrow.json");
const Credibility = require("./abi/CredibilityScoring.json");
const DAO = require("./abi/DAOGovernance.json");
const RidezyToken = require("./abi/RidezyToken.json");
const VehicleNFT = require("./abi/VehicleNFT.json");
const VehicleWallet = require("./abi/VehicleWallet.json");

const UserRegistryABI = UserRegistry.abi;
const EscrowABI = Escrow.abi;
const CredibilityABI = Credibility.abi;
const DAOABI = DAO.abi;
const RidezyTokenABI = RidezyToken.abi;
const VehicleNFTABI = VehicleNFT.abi;
const VehicleWalletABI = VehicleWallet.abi;


// Contract addresses (from deployment)
const USER_REGISTRY_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const ESCROW_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";
const CREDIBILITY_ADDRESS = "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9";
const DAO_ADDRESS = "0x0165878A594ca255338adfa4d48449f69242Eb8F";
const RIDE_TOKEN_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
const VEHICLE_NFT_ADDRESS = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
const VEHICLE_WALLET_ADDRESS = "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707";

const userRegistry = new ethers.Contract(
  USER_REGISTRY_ADDRESS,
  UserRegistryABI,
  wallet
);

const escrow = new ethers.Contract(
  ESCROW_ADDRESS,
  EscrowABI,
  wallet
);

const credibility = new ethers.Contract(
  CREDIBILITY_ADDRESS,
  CredibilityABI,
  wallet
);  

const dao = new ethers.Contract(
  DAO_ADDRESS,
  DAOABI,
  wallet
);

const ridezyToken = new ethers.Contract(
  RIDE_TOKEN_ADDRESS,
  RidezyTokenABI,
  wallet
);

const vehicleNFT = new ethers.Contract(
  VEHICLE_NFT_ADDRESS,  
    VehicleNFTABI,
    wallet
);

const vehicleWallet = new ethers.Contract(
    VEHICLE_WALLET_ADDRESS,
    VehicleWalletABI,
    wallet
);

module.exports = {
  userRegistry,
  escrow, 
  credibility,
  dao,
  ridezyToken,
  vehicleNFT,
  vehicleWallet
};