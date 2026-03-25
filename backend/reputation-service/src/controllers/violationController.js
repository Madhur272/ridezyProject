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

module.exports = { reportViolation };