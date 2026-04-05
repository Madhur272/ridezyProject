const { contracts } = require("../../shared/web3/contracts");

async function rewardDriver(driverAddress) {

  const tx = await contracts.credibility.rewardDriver(driverAddress, 5);

  await tx.wait();

  console.log("Driver rewarded:", tx.hash);

  return tx.hash;
}

module.exports = { rewardDriver };