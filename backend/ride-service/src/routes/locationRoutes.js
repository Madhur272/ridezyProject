//Router for handling driver location updates

const express = require("express");
const router = express.Router();

const { updateLocation } = require("../controllers/locationController");

router.post("/driver-location", updateLocation);

module.exports = router;