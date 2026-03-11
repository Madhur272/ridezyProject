// Driver Location API

const { updateDriverLocation } = require("../services/locationService");

async function updateLocation(req, res) {

  const { driverId, lat, lng } = req.body;

  await updateDriverLocation(driverId, lat, lng);

  res.json({
    status: "location updated"
  });

}

module.exports = { updateLocation };