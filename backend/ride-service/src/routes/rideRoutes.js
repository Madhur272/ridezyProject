const express = require("express");
const router = express.Router();

const { createRide, completeRide } = require("../controllers/rideController");

router.post("/create", createRide);

router.post("/complete", completeRide);

module.exports = router;