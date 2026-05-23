param(
  [switch] $IncludePlatform
)

$ErrorActionPreference = "Stop"

$services = @(
  @{ name = "api-gateway"; local = 4000; remote = 4000 },
  @{ name = "auth-service"; local = 4001; remote = 4001 },
  @{ name = "blockchain-service"; local = 4002; remote = 4002 },
  @{ name = "vehicle-service"; local = 4003; remote = 4003 },
  @{ name = "payment-service"; local = 4004; remote = 4004 },
  @{ name = "reputation-service"; local = 4007; remote = 4007 },
  @{ name = "ride-matching-service"; local = 4008; remote = 4008 },
  @{ name = "ride-service"; local = 4009; remote = 4009 },
  @{ name = "analytics-service"; local = 4010; remote = 4010 },
  @{ name = "realtime-service"; local = 4011; remote = 4011 },
  @{ name = "iot-service"; local = 4012; remote = 4012 }
)

if ($IncludePlatform) {
  $services += @(
    @{ name = "blockchain"; local = 8545; remote = 8545 },
    @{ name = "mongo"; local = 27017; remote = 27017 },
    @{ name = "redis"; local = 6379; remote = 6379 },
    @{ name = "influxdb"; local = 8086; remote = 8086 },
    @{ name = "mqtt"; local = 1883; remote = 1883 }
  )
}

$jobs = @()

try {
  foreach ($service in $services) {
    $jobs += Start-Job -ScriptBlock {
      param($Name, $LocalPort, $RemotePort)
      kubectl port-forward "svc/$Name" "$LocalPort`:$RemotePort"
    } -ArgumentList $service.name, $service.local, $service.remote
  }

  Start-Sleep -Seconds 3

  Write-Host "Forwarded Ridezy services:"
  foreach ($service in $services) {
    Write-Host "  $($service.name): 127.0.0.1:$($service.local)"
  }

  Write-Host ""
  Write-Host "Press Ctrl+C to stop port forwarding."

  while ($true) {
    foreach ($job in $jobs) {
      if ($job.State -ne "Running") {
        Receive-Job $job
        throw "Port-forward job $($job.Id) stopped."
      }
    }

    Start-Sleep -Seconds 5
  }
}
finally {
  foreach ($job in $jobs) {
    Stop-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job -Force -ErrorAction SilentlyContinue
  }
}
