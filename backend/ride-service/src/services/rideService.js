const { escrow } = require("../../shared/web3/contracts");
const wallet = require("../../shared/web3/wallet");

async function freshNonce() {
  const nonce = await wallet.provider.send("eth_getTransactionCount", [
    wallet.address,
    "pending"
  ]);

  return Number(BigInt(nonce));
}

async function createRideOnChain(rideId, driverAddress, amount) {

  const tx = await escrow.createRide(
    rideId,
    driverAddress,
    {
      value: amount,
      nonce: await freshNonce()
    }
  );

  await tx.wait();

  console.log("Escrow locked:", tx.hash);

  return tx.hash;
}

async function completeRideOnChain(rideId) {

  const tx = await escrow.completeRide(rideId, {
    nonce: await freshNonce()
  });

  await tx.wait();

  console.log("Payment released:", tx.hash);

  return tx.hash;
}

module.exports = { 
    createRideOnChain,
    completeRideOnChain
};
