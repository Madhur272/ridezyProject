const express = require("express");
const cors = require("cors");
require("dotenv").config();

const locationRoutes = require("./routes/locationRoutes");
const app = express();

app.use(cors());
app.use(express.json());
app.use("/location", locationRoutes);

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