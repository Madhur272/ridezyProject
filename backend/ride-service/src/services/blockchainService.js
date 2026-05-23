const { credibility } = require("../../shared/web3/contracts");
const wallet = require("../../shared/web3/wallet");

async function freshNonce() {
  const nonce = await wallet.provider.send("eth_getTransactionCount", [
    wallet.address,
    "pending"
  ]);

  return Number(BigInt(nonce));
}

async function rewardDriver(driverAddress) {

  const tx = await credibility.rewardDriver(driverAddress, 5, {
    nonce: await freshNonce()
  });

  await tx.wait();

  console.log("Driver rewarded:", tx.hash);

  return tx.hash;
}

module.exports = { rewardDriver };
