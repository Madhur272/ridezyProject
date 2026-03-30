const express = require("express");
const router = express.Router();

const { getIO } = require("../socket/socket");

router.post("/notify-driver", (req, res) => {

  const io = getIO();

  const { rideId, driverId } = req.body;

  io.emit("ride_request", {
    rideId,
    driverId
  });

  res.json({ message: "Driver notified" });

});

module.exports = router;