const { escrow } = require("../../shared/web3/contracts");

async function createRideOnChain(rideId, driverAddress, amount) {

  const tx = await escrow.createRide(
    rideId,
    driverAddress,
    {
      value: amount
    }
  );

  await tx.wait();

  console.log("Escrow locked:", tx.hash);

  return tx.hash;
}

async function completeRideOnChain(rideId) {

  const tx = await escrow.completeRide(rideId);

  await tx.wait();

  console.log("Payment released:", tx.hash);

  return tx.hash;
}

module.exports = { 
    createRideOnChain,
    completeRideOnChain
};