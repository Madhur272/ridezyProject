const express = require("express");
const router = express.Router();

const { registerUser } = require("../controllers/blockchainController");


router.post("/register", registerUser);

module.exports = router;