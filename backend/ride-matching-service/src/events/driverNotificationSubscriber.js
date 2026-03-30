const { subscribe } = require("./subscriber");

function handleDriverNotification(data) {

  console.log("Driver notification:", data);

  // 🚀 Send to realtime service (later via Redis/pubsub bridge)
}

function startDriverNotificationSubscriber() {
  subscribe("driver_notifications", handleDriverNotification);
}

module.exports = { startDriverNotificationSubscriber };