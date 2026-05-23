const { credibility } = require("../../shared/web3/contracts");
const wallet = require("../../shared/web3/wallet");

async function freshNonce() {
  const nonce = await wallet.provider.send("eth_getTransactionCount", [
    wallet.address,
    "pending"
  ]);

  return Number(BigInt(nonce));
}

async function recordViolation(driverAddress, penalty) {
  const score = await credibility.getScore(driverAddress);

  if (score.score === 0n) {
    console.log("Driver not registered. Registering...");

    const tx1 = await credibility.registerDriver(driverAddress, {
      nonce: await freshNonce()
    });
    await tx1.wait();
  }

  const tx2 = await credibility.recordViolation(driverAddress, penalty, {
    nonce: await freshNonce()
  });
  await tx2.wait();

  console.log("Violation recorded:", tx2.hash);
  return tx2.hash;
}

module.exports = { recordViolation };
