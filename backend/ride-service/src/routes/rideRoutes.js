const express = require("express");
const router = express.Router();

const { createRide } = require("../controllers/rideController");

router.post("/create", createRide);

module.exports = router;