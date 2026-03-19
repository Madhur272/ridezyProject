const express = require("express");
const router = express.Router();

const { respondToRide } = require("../controllers/driverController");

router.post("/respond", respondToRide);

module.exports = router;