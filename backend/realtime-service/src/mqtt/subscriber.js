const mqtt = require("mqtt");
const { writeApi, Point } = require("../db/influx");
const axios = require("axios");
const { getIO } = require("../socket/socket");
require("dotenv").config();

const {
  addVehicleData,
  addViolation
} = require("../store/dataStore");

const client = mqtt.connect(process.env.MQTT_URL);

client.on("connect", () => {
  console.log("Connected to MQTT broker");
  client.subscribe("vehicle/data");
});

client.on("message", async (topic, message) => {

  const data = JSON.parse(message.toString());

  console.log("Vehicle Data:", data);

  addVehicleData(data);

  // EMIT REAL-TIME UPDATE HERE
  const io = getIO();
  if (io) {
    io.emit("vehicle_update", data);
  }
  // Store in InfluxDB
  const point = new Point("vehicle_metrics")
    .tag("driverId", data.driverId)
    .floatField("speed", data.speed)
    .floatField("acceleration", data.acceleration)
    .floatField("lat", data.lat)
    .floatField("lng", data.lng);

  writeApi.writePoint(point);

  // Detect violations
  await processViolations(data);

});

async function processViolations(data) {

  // 🚨 Speed violation
  if (data.speed > 70) {

    console.log("Speed violation!");
    const violation = {
      driverId: data.driverId,
      type: "speed",
      value: data.speed,
      time: Date.now()
    };

    addViolation(violation)

    await axios.post("http://localhost:4007/violation/report", {
      driverAddress: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      penalty: 5
    });

  }

  // 🚨 Harsh braking
  if (data.acceleration < -2.5) {

    console.log("Harsh braking!");
    const violation = {
      driverId: data.driverId,
      type: "speed",
      value: data.speed,
      time: Date.now()
    };

    addViolation(violation)


    await axios.post("http://localhost:4007/violation/report", {
      driverAddress: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      penalty: 3
    });

  }
}

process.on("SIGINT", async () => {
  await writeApi.close();
  process.exit(0);
});