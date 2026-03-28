const express = require("express");
const router = express.Router();

const {
  getVehicleData,
  getViolations
} = require("../store/dataStore");

// GET vehicle data
router.get("/vehicle/data", (req, res) => {
  res.json(getVehicleData());
});

// GET violations
router.get("/violation/list", (req, res) => {
  res.json(getViolations());
});

module.exports = router;