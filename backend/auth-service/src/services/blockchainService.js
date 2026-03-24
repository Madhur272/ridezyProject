const { userRegistry } = require("../../../shared/web3/contracts");

async function registerUserOnChain(userType) {

  const tx = await userRegistry.registerUser(userType);

  await tx.wait();

  console.log("User registered on blockchain:", tx.hash);

  return tx.hash;
}

module.exports = { registerUserOnChain };