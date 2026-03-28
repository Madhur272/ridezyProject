const { InfluxDB, Point } = require("@influxdata/influxdb-client");
require("dotenv").config();

const url = process.env.INFLUX_URL;
const token = process.env.INFLUX_TOKEN;

const org = "ridezy";
const bucket = "vehicle_data";

const client = new InfluxDB({ url, token });

const writeApi = client.getWriteApi(org, bucket);

module.exports = { writeApi, Point };