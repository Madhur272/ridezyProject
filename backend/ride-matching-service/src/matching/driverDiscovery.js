const redis = require("../../../shared/redisClient");

async function getActiveDrivers() {

  const driverIds = await redis.smembers("drivers:active");

  return driverIds;

}

async function getDriverLocation(driverId) {

  const key = `driver:location:${driverId}`;

  const location = await redis.get(key);

  if (!location) return null;

  return JSON.parse(location);

}

module.exports = { getActiveDrivers, getDriverLocation };