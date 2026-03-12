const express = require("express");
const cors = require("cors");
require("dotenv").config();

const pino = require("pino");
const logger = pino({
 level: "info"
});
module.exports = logger;

const matchingRoutes = require("./routes/matchingRoutes");
const { startRideSubscriber } = require("./events/rideSubscriber");
const { subscribe } = require("./events/subscriber");

startRideSubscriber();

subscribe("ride_requests", (data) => {
  logger.info("New Ride Request:", data);
});

const app = express();

app.use("/match", matchingRoutes);
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get("/health", async (req, res) => {

 try {

   await redis.ping();

   res.json({
     status: "ok",
     redis: "connected"
   });

 } catch (err) {

   res.status(500).json({
     status: "error",
     redis: "disconnected"
   });

 }

});

app.listen(PORT, () => {
  logger.info(`${process.env.SERVICE_NAME} running on port ${PORT}`);
});