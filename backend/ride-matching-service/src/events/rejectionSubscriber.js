const { subscribe } = require("./subscriber");
const { assignNextDriver } = require("../matching/assignmentEngine");

async function handleRejection(data) {

  console.log("Driver rejected:", data.driverId);

  await assignNextDriver(data.rideId);

}

function startRejectionSubscriber() {
  subscribe("ride_rejected", handleRejection);
}

module.exports = { startRejectionSubscriber };