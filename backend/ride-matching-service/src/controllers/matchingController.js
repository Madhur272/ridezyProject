const { findNearbyDrivers } = require("../services/matchingService");

async function matchDriver(req, res) {

  const { lng, lat } = req.body;

  const drivers = await findNearbyDrivers(lng, lat);

  res.json({
    availableDrivers: drivers
  });

}

module.exports = { matchDriver };