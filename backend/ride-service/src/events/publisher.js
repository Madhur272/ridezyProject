const redis = require("../../../shared/redisClient");
const pino = require("pino");

const logger = pino({
 level: "info"
});

module.exports = logger;


async function publishEvent(channel, payload) {

  await redis.publish(channel, JSON.stringify(payload));

  logger.info(`Event published to ${channel}`, payload);

}

module.exports = { publishEvent };