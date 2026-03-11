const express = require("express");
const router = express.Router();

const { matchDriver } = require("../controllers/matchingController");

router.post("/match", matchDriver);

module.exports = router;