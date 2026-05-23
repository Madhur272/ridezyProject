const { registerUserOnChain } = require("../services/blockchainService");

async function registerUser(req, res) {

  const { userType } = req.body;

  const result = await registerUserOnChain(userType);

  res.json({
    message: result.status === "already_registered"
      ? "User already registered on blockchain"
      : "User registered on blockchain",
    status: result.status,
    txHash: result.txHash
  });
}

module.exports = { registerUser };
