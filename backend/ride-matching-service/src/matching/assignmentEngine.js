const redis = require("../config/redis");
const axios = require("axios");

async function assignNextDriver(rideId) {

  const queueData = await redis.get(`ride_queue:${rideId}`);

  if (!queueData) {
    console.log("No driver queue found");
    return;
  }

  let queue = JSON.parse(queueData);

  if (queue.length === 0) {
    console.log("All drivers exhausted");
    return;
  }

  const nextDriver = queue.shift();

  // Update queue
  await redis.set(`ride_queue:${rideId}`, JSON.stringify(queue));

  // Save ride state
  await redis.set(
    `ride:${rideId}`,
    JSON.stringify({
      rideId,
      driverId: nextDriver.driverId,
      status: "WAITING"
    }),
    "EX",
    30
  );

  // Notify driver
  await redis.publish("driver_notifications", JSON.stringify({
    rideId,
    driverId: nextDriver.driverId
  }));
    await axios.post("http://realtime-service:4011/notify-driver", {
    rideId,
    driverId: nextDriver.driverId
  });

  console.log("Trying driver:", nextDriver.driverId);

  // Timeout
  setTimeout(async () => {

    const ride = await redis.get(`ride:${rideId}`);
    if (!ride) return;

    const parsed = JSON.parse(ride);

    if (parsed.status === "WAITING") {

      console.log("Timeout → trying next driver");

      await assignNextDriver(rideId);

    }

  }, 10000);

}

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
  await axios.post("http://realtime-service:4011/notify-driver", payload);

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

module.exports = { assignDriver, assignNextDriver };