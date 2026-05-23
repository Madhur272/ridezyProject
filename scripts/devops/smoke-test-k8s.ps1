$ErrorActionPreference = "Stop"

$checkScript = @'
const checks = [
  ["api-gateway", "http://api-gateway:4000/health"],
  ["auth-service", "http://auth-service:4001/health"],
  ["blockchain-service", "http://blockchain-service:4002/health"],
  ["vehicle-service", "http://vehicle-service:4003/health"],
  ["payment-service", "http://payment-service:4004/health"],
  ["reputation-service", "http://reputation-service:4007/health"],
  ["ride-matching-service", "http://ride-matching-service:4008/health"],
  ["ride-service", "http://ride-service:4009/health"],
  ["analytics-service", "http://analytics-service:4010/health"],
  ["realtime-service", "http://realtime-service:4011/health"],
  ["iot-service", "http://iot-service:4012/health"]
];

(async () => {
  let failed = false;

  for (const [name, url] of checks) {
    try {
      const response = await fetch(url);
      const text = await response.text();
      console.log(`${name} ${response.status} ${text.slice(0, 160)}`);
      if (!response.ok) failed = true;
    } catch (err) {
      failed = true;
      console.error(`${name} failed: ${err.message}`);
    }
  }

  process.exit(failed ? 1 : 0);
})();
'@

$encodedScript = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($checkScript))

kubectl -n ridezy exec deployment/api-gateway -- node -e "eval(Buffer.from(process.argv[1], 'base64').toString('utf8'))" $encodedScript
