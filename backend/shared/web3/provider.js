const { ethers } = require("ethers");

const provider = new ethers.JsonRpcProvider(
  process.env.BLOCKCHAIN_RPC_URL || "http://127.0.0.1:8545"
);

module.exports = provider;
