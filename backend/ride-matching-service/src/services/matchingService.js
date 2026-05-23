const redis = require("../config/redis");
const distance = require("../utils/distance");

const DEFAULT_RADIUS_KM = Number(process.env.MATCHING_RADIUS_KM || 5);

async function findNearbyDrivers(lng, lat, radiusKm = DEFAULT_RADIUS_KM) {
  const driverIds = await redis.smembers("drivers:active");
  const drivers = [];

  for (const driverId of driverIds) {
    const location = await redis.get(`driver:location:${driverId}`);

    if (!location) {
      await redis.srem("drivers:active", driverId);
      continue;
    }

    const parsed = JSON.parse(location);
    const km = distance(lat, lng, parsed.lat, parsed.lng);

    if (km <= radiusKm) {
      drivers.push({
        driverId,
        lat: parsed.lat,
        lng: parsed.lng,
        distanceKm: Number(km.toFixed(3)),
        lastSeenAt: parsed.timestamp
      });
    }
  }

  return drivers.sort((a, b) => a.distanceKm - b.distanceKm);
}

module.exports = { findNearbyDrivers };
