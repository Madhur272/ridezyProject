const { userRegistry } = require("../../../shared/web3/contracts");
const wallet = require("../../../shared/web3/wallet");

async function freshNonce() {
  const nonce = await wallet.provider.send("eth_getTransactionCount", [
    wallet.address,
    "pending"
  ]);

  return Number(BigInt(nonce));
}

async function registerUserOnChain(userType) {
  try {
    const tx = await userRegistry.registerUser(userType, {
      nonce: await freshNonce()
    });

    await tx.wait();

    console.log("User registered on blockchain:", tx.hash);

    return {
      status: "registered",
      txHash: tx.hash
    };
  } catch (err) {
    if (err.reason === "Already registered" || err.shortMessage?.includes("Already registered")) {
      return {
        status: "already_registered",
        txHash: null
      };
    }

    throw err;
  }
}

module.exports = { registerUserOnChain };
