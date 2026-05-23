// const { ethers } = require("ethers");
// const provider = require("./provider");

// const PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

// const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// module.exports = wallet;


const { ethers } = require("ethers");
const provider = require("./provider");

const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = new ethers.Wallet(PRIVATE_KEY, provider);
