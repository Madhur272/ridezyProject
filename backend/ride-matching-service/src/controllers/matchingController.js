const { findNearbyDrivers } = require("../services/matchingService");

async function matchDriver(req, res) {
  try {
    const { pickup } = req.body;

    if (!pickup || typeof pickup.lng !== "number" || typeof pickup.lat !== "number") {
      return res.status(400).json({
        error: "pickup.lat and pickup.lng are required"
      });
    }

    const drivers = await findNearbyDrivers(pickup.lng, pickup.lat);

    return res.json({
      availableDrivers: drivers
    });
  } catch (err) {
    console.error("Failed to match driver:", err);

    return res.status(500).json({
      error: "Failed to match driver"
    });
  }
}

module.exports = { matchDriver };
