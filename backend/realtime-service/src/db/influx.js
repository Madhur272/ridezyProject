const { InfluxDB, Point } = require("@influxdata/influxdb-client");
require("dotenv").config();

const url = process.env.INFLUX_URL || "http://127.0.0.1:8086";
const token = process.env.INFLUX_TOKEN || "ridezy-local-dev-token";

const org = process.env.INFLUX_ORG || "ridezy";
const bucket = process.env.INFLUX_BUCKET || "vehicle_data";

const client = new InfluxDB({ url, token });

const writeApi = client.getWriteApi(org, bucket);

module.exports = { writeApi, Point };
