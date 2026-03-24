const express = require("express");
const cors = require("cors");
require("dotenv").config();

const connectDB = require("./config/db");
const Ride = require("./models/Ride");
const Users = require("./models/Users");
const Vehicle = require("./models/Vehicle");
const blockchain = require("./routes/blockchainRouter");
const app = express();


app.use(cors());
app.use(express.json());
connectDB();
Ride(); 
Users();  
Vehicle(); 
app.use("/auth", blockchain);

const PORT = process.env.PORT || 4001;

app.get("/health", (req, res) => {
  res.json({
    status: "Service Running",
    service: process.env.SERVICE_NAME
  });
});

app.listen(PORT, () => {
  console.log(`${process.env.SERVICE_NAME} running on port ${PORT}`);
});