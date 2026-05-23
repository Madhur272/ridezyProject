const { ethers } = require("ethers");

const provider = new ethers.JsonRpcProvider(
  process.env.BLOCKCHAIN_RPC_URL || "http://blockchain:8545"
);

module.exports = provider;
