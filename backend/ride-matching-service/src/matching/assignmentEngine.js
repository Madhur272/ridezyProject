const redis = require("../../../shared/redisClient");

async function assignDriver(rideId, driver) {

  const payload = {
    rideId,
    driverId: driver.driverId
  };

  // 1️⃣ Save ride state
  await redis.set(
    `ride:${rideId}`,
    JSON.stringify({
      rideId,
      driverId: driver.driverId,
      status: "WAITING"
    }),
    "EX",
    30
  );

  // 2️⃣ Notify driver
  await redis.publish(
    "driver_notifications",
    JSON.stringify(payload)
  );

  console.log("Driver notified", payload);

  // 3️⃣ Timeout logic (retry if driver doesn't accept)
  setTimeout(async () => {

    try {
      const ride = await redis.get(`ride:${rideId}`);

      if (!ride) return;

      const parsed = JSON.parse(ride);

      if (parsed.status === "WAITING") {

        console.log("Driver timeout → retry", parsed);

        await redis.publish(
          "ride_timeout",
          JSON.stringify(parsed)
        );

      }

    } catch (err) {
      console.error("Timeout error:", err);
    }

  }, 10000); // 10 seconds
}

module.exports = { assignDriver };