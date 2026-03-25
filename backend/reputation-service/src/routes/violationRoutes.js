const express = require("express");
const router = express.Router();

const { reportViolation } = require("../controllers/violationController");

router.post("/report", reportViolation);

module.exports = router;