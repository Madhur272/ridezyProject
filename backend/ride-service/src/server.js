const express = require("express");
const cors = require("cors");
require("dotenv").config();
const redis = require("./config/redis");

const locationRoutes = require("./routes/locationRoutes");
const { subscribe } = require("./events/subscriber");
const rideRoutes = require("./routes/rideRoutes");

const pino = require("pino");

const logger = pino({
 level: "info"
});

module.exports = logger;

const app = express();

subscribe("ride_requests", (data) => {
  logger.info("New Ride Request:", data);
});

app.use(cors());
app.use(express.json());
app.use("/location", locationRoutes);
app.use("/ride", rideRoutes);

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