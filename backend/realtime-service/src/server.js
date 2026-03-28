const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
const dashboardRoutes = require("./routes/dashboardRoutes");

app.use(cors());
app.use(express.json());
require("./mqtt/subscriber");
app.use("/", dashboardRoutes);
const PORT = process.env.PORT || 3000;

app.get("/health", (req, res) => {
  res.json({
    status: "Service Running",
    service: process.env.SERVICE_NAME
  });
});

app.listen(PORT, () => {
  console.log(`${process.env.SERVICE_NAME} running on port ${PORT}`);
});