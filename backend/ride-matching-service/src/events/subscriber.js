const Redis = require("ioredis");
require("dotenv").config();

const subscriber = new Redis({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT,
});

function subscribe(channel, handler) {

  subscriber.subscribe(channel);

  subscriber.on("message", (receivedChannel, message) => {

    if (receivedChannel === channel) {

      const data = JSON.parse(message);

      handler(data);

    }

  });

}

module.exports = { subscribe };