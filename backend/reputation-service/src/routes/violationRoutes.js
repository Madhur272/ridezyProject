const express = require("express");
const router = express.Router();

const { reportViolation, reportBatchViolation } = require("../controllers/violationController");

router.post("/report", reportViolation);

router.post("/batch", reportBatchViolation);

module.exports = router;