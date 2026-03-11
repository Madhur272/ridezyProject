const { publishEvent } = require("./publisher");

async function rideRequested(rideData) {

  await publishEvent("ride_requested", rideData);

}

module.exports = { rideRequested };