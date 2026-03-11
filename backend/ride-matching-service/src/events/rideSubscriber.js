const { subscribe } = require("./subscriber");

function handleRideRequest(data) {

  console.log("New ride request received:", data);

  // later we will run driver matching algorithm here

}

function startRideSubscriber() {

  subscribe("ride_requested", handleRideRequest);

}

module.exports = { startRideSubscriber };