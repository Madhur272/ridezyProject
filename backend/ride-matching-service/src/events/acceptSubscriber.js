const { subscribe } = require("./subscriber");

async function handleAcceptance(data) {

  console.log("Driver accepted:", data.driverId);

}

function startAcceptSubscriber() {
  subscribe("ride_accepted", handleAcceptance);
}

module.exports = { startAcceptSubscriber };