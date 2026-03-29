const express = require("express");
const cors = require("cors");
require("dotenv").config();
const http = require("http");

const app = express();
const dashboardRoutes = require("./routes/dashboardRoutes");

// Middleware
app.use(cors());
app.use(express.json());

// MQTT subscriber
require("./mqtt/subscriber");

// Routes
app.use("/", dashboardRoutes);

// Health check
app.get("/health", (req, res) => {
  res.json({
    status: "Service Running",
    service: process.env.SERVICE_NAME
  });
});

//  Create HTTP server 
const server = http.createServer(app);

// Attach WebSocket
const { initSocket } = require("./socket/socket");
initSocket(server);

// Use server.listen instead of app.listen
const PORT = process.env.PORT || 4011;

server.listen(PORT, () => {
  console.log(`${process.env.SERVICE_NAME} running on port ${PORT}`);
});