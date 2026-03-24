const { registerUserOnChain } = require("../services/blockchainService");

async function registerUser(req, res) {

  const { userType } = req.body;

  const txHash = await registerUserOnChain(userType);

  res.json({
    message: "User registered on blockchain",
    txHash
  });
}

module.exports = { registerUser };