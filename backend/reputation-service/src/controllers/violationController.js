const { recordViolation } = require("../services/blockchainService");

async function reportViolation(req, res) {

  try {

    const { driverAddress, penalty } = req.body;

    const txHash = await recordViolation(driverAddress, penalty);

    res.json({
      message: "Violation recorded",
      txHash
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      error: "Failed to record violation"
    });

  }
}

async function reportBatchViolation(req, res) {

  try {

    const { violations } = req.body;

    for (const v of violations) {

      await recordViolation(v.driver, v.penalty);

    }

    res.json({ message: "Batch processed" });

  } catch (err) {

    console.error(err);

    res.status(500).json({ error: "Batch failed" });

  }
}

module.exports = { reportViolation, reportBatchViolation };