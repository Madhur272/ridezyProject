const mqtt = require("mqtt");

const client = mqtt.connect("mqtt://localhost:1883");

client.on("connect", () => {
  console.log("Connected to MQTT broker");

  client.subscribe("vehicle/data");
});

client.on("message", (topic, message) => {

  const data = JSON.parse(message.toString());

  console.log("Vehicle Data:", data);

});