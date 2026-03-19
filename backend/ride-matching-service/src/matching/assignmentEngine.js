const redis = require("../../../shared/redisClient");

async function assignDriver(rideId, driver) {

  const payload = {

    rideId,
    driverId: driver.driverId

  };

  await redis.publish(
    "driver_notifications",
    JSON.stringify(payload)
  );

  console.log("Driver notified", payload);

}

module.exports = { assignDriver };