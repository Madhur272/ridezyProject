const redis = require("../../../shared/redisClient");

async function publishEvent(channel, payload) {

  await redis.publish(channel, JSON.stringify(payload));

  console.log(`Event published to ${channel}`, payload);

}

module.exports = { publishEvent };