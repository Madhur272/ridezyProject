const redis = require("../config/redis");

async function respondToRide(req, res) {

  const { rideId, driverId, action } = req.body;

  const ride = await redis.get(`ride:${rideId}`);

  if (!ride) {
    return res.status(404).json({ error: "Ride not found" });
  }

  const parsed = JSON.parse(ride);

  // Ensure correct driver
  if (parsed.driverId !== driverId) {
    return res.status(403).json({ error: "Not your ride" });
  }

  if (action === "ACCEPT") {

    parsed.status = "ACCEPTED";

    await redis.set(`ride:${rideId}`, JSON.stringify(parsed));

    await redis.publish("ride_accepted", JSON.stringify(parsed));

    return res.json({ message: "Ride accepted" });

  }

  if (action === "REJECT") {

    await redis.publish("ride_rejected", JSON.stringify(parsed));

    return res.json({ message: "Ride rejected" });

  }

}

module.exports = { respondToRide };