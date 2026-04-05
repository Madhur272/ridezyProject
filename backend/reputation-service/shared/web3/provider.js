const { ethers } = require("ethers");

const provider = new ethers.JsonRpcProvider("http://blockchain:8545");

module.exports = provider;