const express = require("express");
const cors = require("cors");
require("dotenv").config();
const redis = require("./config/redis");

const pino = require("pino");
const logger = pino({
 level: "info"
});
module.exports = logger;

const matchingRoutes = require("./routes/matchingRoutes");
const { startRideSubscriber }  = require("./events/rideSubscriber");
const { subscribe } = require("./events/subscriber");
const driverRoutes = require("./routes/driverRoutes");
const { startRejectionSubscriber } = require("./events/rejectionSubscriber");
const { startAcceptSubscriber } = require("./events/acceptSubscriber");


startRideSubscriber();
startRejectionSubscriber();
startAcceptSubscriber();

subscribe("ride_requested", (data) => {
  logger.info("New Ride Request:", data);
});

const app = express();

app.use(cors());
app.use(express.json());
app.use("/match", matchingRoutes);
// app.use('/ride', startRideSubscriber);
app.use("/driver", driverRoutes);
const PORT = process.env.PORT || 4008;

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