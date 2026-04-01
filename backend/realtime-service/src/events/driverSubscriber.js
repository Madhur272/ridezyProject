const Redis = require("ioredis");
const { getIO } = require("../socket/socket");

const sub = new Redis();

function startDriverSubscriber() {
  
  sub.subscribe("driver_notifications");

  sub.on("message", (channel, message) => {

    if (channel === "driver_notifications") {

      const data = JSON.parse(message);

      console.log("Received driver notification:", data);

      const io = getIO(); 

      if (io) {

        io.emit("ride_request", data); 
        console.log("Sent to driver via socket");

      } else {
        console.log("Socket not initialized");
      }

    }
  });
}

module.exports = { startDriverSubscriber };