// Controller for creating new ride

const { rideRequested } = require("../events/rideEvents");

async function createRide(req, res) {

  const ride = {
    rideId: req.body.rideId,
    pickup: req.body.pickup
  };

  await rideRequested(ride);

  res.json({
    status: "ride request created"
  });

}

module.exports = { createRide };