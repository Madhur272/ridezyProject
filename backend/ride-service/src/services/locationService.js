// Driver Location Update Service

const redis = require("../config/redis");

async function updateDriverLocation(driverId, lat, lng) {

  const key = `driver:location:${driverId}`;

  const locationData = {
    lat,
    lng,
    timestamp: Date.now()
  };

  await redis.set(key, JSON.stringify(locationData), "EX", 100); // Set location with 10 second expiry

  await redis.sadd("drivers:active", driverId);

}

module.exports = { updateDriverLocation };