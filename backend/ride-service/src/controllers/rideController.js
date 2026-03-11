// Controller for creating new ride

const { rideRequested } = require("../events/rideEvents");

async function createRide(req, res) {

  const ride = {
    riderId: req.body.riderId,
    pickup: req.body.pickup
  };

  await rideRequested(ride);

  res.json({
    status: "ride request created"
  });

}

module.exports = { createRide };