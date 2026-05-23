const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
const SERVICE_NAME = process.env.SERVICE_NAME || "api-gateway";

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 4000;

const routes = [
  {
    prefix: "/api/v1/auth",
    target: process.env.AUTH_SERVICE_URL || "http://auth-service:4001/auth"
  },
  {
    prefix: "/api/v1/rides",
    target: process.env.RIDE_SERVICE_URL || "http://ride-service:4009/ride"
  },
  {
    prefix: "/api/v1/locations",
    target: process.env.LOCATION_SERVICE_URL || "http://ride-service:4009/location"
  },
  {
    prefix: "/api/v1/matching",
    target: process.env.MATCHING_SERVICE_URL || "http://ride-matching-service:4008/match"
  },
  {
    prefix: "/api/v1/drivers",
    target: process.env.DRIVER_MATCHING_SERVICE_URL || "http://ride-matching-service:4008/driver"
  },
  {
    prefix: "/api/v1/reputation",
    target: process.env.REPUTATION_SERVICE_URL || "http://reputation-service:4007/violation"
  },
  {
    prefix: "/api/v1/realtime",
    target: process.env.REALTIME_SERVICE_URL || "http://realtime-service:4011"
  },
  {
    prefix: "/api/v1/payments",
    target: process.env.PAYMENT_SERVICE_URL || "http://payment-service:4004"
  },
  {
    prefix: "/api/v1/vehicles",
    target: process.env.VEHICLE_SERVICE_URL || "http://vehicle-service:4003"
  },
  {
    prefix: "/api/v1/iot",
    target: process.env.IOT_SERVICE_URL || "http://iot-service:4012"
  },
  {
    prefix: "/api/v1/analytics",
    target: process.env.ANALYTICS_SERVICE_URL || "http://analytics-service:4010"
  },
  {
    prefix: "/api/v1/blockchain",
    target: process.env.BLOCKCHAIN_SERVICE_URL || "http://blockchain-service:4002"
  }
];

function ok(res, data, statusCode = 200) {
  return res.status(statusCode).json({
    success: true,
    data,
    meta: {
      service: SERVICE_NAME,
      timestamp: new Date().toISOString()
    }
  });
}

function fail(res, statusCode, message, details) {
  return res.status(statusCode).json({
    success: false,
    error: {
      message,
      details
    },
    meta: {
      service: SERVICE_NAME,
      timestamp: new Date().toISOString()
    }
  });
}

app.get("/health", (req, res) => {
  ok(res, {
    status: "ok",
    routes: routes.map(({ prefix, target }) => ({ prefix, target }))
  });
});

for (const route of routes) {
  app.use(route.prefix, async (req, res) => {
    const suffix = req.originalUrl.slice(route.prefix.length);
    const targetUrl = `${route.target}${suffix || ""}`;
    const headers = { ...req.headers };

    delete headers.host;
    delete headers["content-length"];

    try {
      const upstream = await fetch(targetUrl, {
        method: req.method,
        headers,
        body: ["GET", "HEAD"].includes(req.method) ? undefined : JSON.stringify(req.body)
      });

      const text = await upstream.text();

      res.status(upstream.status);
      upstream.headers.forEach((value, key) => {
        if (!["content-encoding", "content-length", "transfer-encoding"].includes(key.toLowerCase())) {
          res.setHeader(key, value);
        }
      });

      if (!text) {
        return res.end();
      }

      try {
        return res.json(JSON.parse(text));
      } catch {
        return res.send(text);
      }
    } catch (err) {
      return fail(res, 502, "Upstream service unavailable", {
        target: route.target,
        reason: err.message
      });
    }
  });
}

app.use((req, res) => {
  fail(res, 404, "Route not found", {
    path: req.originalUrl
  });
});

app.listen(PORT, () => {
  console.log(`${SERVICE_NAME} running on port ${PORT}`);
});
