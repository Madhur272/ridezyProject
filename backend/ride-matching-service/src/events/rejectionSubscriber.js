const { subscribe } = require("./subscriber");

function handleRejection(data) {

  console.log("Driver rejected ride:", data);

  // NEXT STEP → assign next driver (we'll implement next)

}

function startRejectionSubscriber() {
  subscribe("ride_rejected", handleRejection);
}

module.exports = { startRejectionSubscriber };