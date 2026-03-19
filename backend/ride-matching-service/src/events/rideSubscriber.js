const redis = require("../../../shared/redisClient");
const { subscribe } = require("./subscriber");

const { rankDrivers } = require("../matching/driverRanking");
const { assignDriver } = require("../matching/assignmentEngine");

const pino = require("pino");

const logger = pino({
 level: "info"
});

module.exports = logger;

async function handleRideRequest(data) {

  logger.info("Ride request received:", data);

  // 1️⃣ Get all active drivers
  const driverIds = await redis.smembers("drivers:active");

  logger.info("Active drivers:", driverIds);

  const drivers = [];

  // 2️⃣ Get driver locations from Redis
  for (const id of driverIds) {

    const location = await redis.get(`driver:location:${id}`);

    if (location) {
      const parsed = JSON.parse(location);

      drivers.push({
        driverId: id,
        lat: parsed.lat,
        lng: parsed.lng
      });
    }
  }

  logger.info("Driver locations:", drivers);

  // 3️⃣ Rank drivers
  const ranked = await rankDrivers(drivers, data.pickup);

  logger.info("Ranked drivers:", ranked);

  const bestDriver = ranked[0];

  if (!bestDriver) {
    logger.info("No drivers available");
    return;
  }

  // 4️⃣ Assign driver
  await assignDriver(data.rideId, bestDriver);

  logger.info("Driver assigned:", bestDriver);

}

function startRideSubscriber() {
  subscribe("ride_requested", handleRideRequest);
}

module.exports = { startRideSubscriber };