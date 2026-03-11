const Redis = require("ioredis");

const subscriber = new Redis({
  host: "127.0.0.1",
  port: 6379
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