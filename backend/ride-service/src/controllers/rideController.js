// Controller for creating new ride
const { ethers } = require("ethers");
const { rideRequested } = require("../events/rideEvents");
const { createRideOnChain, completeRideOnChain } = require("../services/rideService");
const { rewardDriver } = require("../services/blockchainService");

// async function createRide(req, res) {

//   const ride = {
//     rideId: req.body.rideId,
//     pickup: req.body.pickup
//   };

//   await rideRequested(ride);

//   res.json({
//     status: "ride request created"
//   });

// }

async function createRide(req, res) {

  const { rideId, pickup, driverAddress } = req.body;

  // 1️⃣ Lock payment on blockchain
  const txHash = await createRideOnChain(
    rideId,
    driverAddress,
    ethers.parseEther("0.01")
  );

  // 2️⃣ Trigger matching event
  const ride = {
    rideId: req.body.rideId,
    pickup: req.body.pickup
  };

  await rideRequested(ride);

  res.json({
    message: "Ride created",
    txHash
  });
}


async function completeRide(req, res) {

  const { rideId, driverAddress } = req.body;

  // 1️⃣ Release payment
  const tx1 = await completeRideOnChain(rideId);

  // 2️⃣ Reward driver
  const tx2 = await rewardDriver(driverAddress);

  res.json({
    message: "Ride completed",
    paymentTx: tx1,
    rewardTx: tx2
  });
}

module.exports = { createRide, completeRide };