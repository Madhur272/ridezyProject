const { contracts } = require("../../shared/web3/contracts");

async function recordViolation(driverAddress, penalty) {

  const tx = await contracts.credibility.recordViolation(driverAddress, penalty);

  await tx.wait();

  console.log("Violation recorded on chain:", tx.hash);

  return tx.hash;
}

module.exports = { recordViolation };