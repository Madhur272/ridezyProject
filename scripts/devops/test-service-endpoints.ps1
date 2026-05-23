$ErrorActionPreference = "Stop"

function Start-Forward {
  param(
    [string] $Service,
    [int] $LocalPort,
    [int] $RemotePort
  )

  $job = Start-Job -ScriptBlock {
    param($Svc, $LPort, $RPort)
    kubectl port-forward "svc/$Svc" "$LPort`:$RPort"
  } -ArgumentList $Service, $LocalPort, $RemotePort

  Start-Sleep -Seconds 2
  return $job
}

function Stop-Forward {
  param($Job)

  if ($null -ne $Job) {
    Stop-Job $Job -ErrorAction SilentlyContinue
    Remove-Job $Job -Force -ErrorAction SilentlyContinue
  }
}

function Invoke-Json {
  param(
    [string] $Method,
    [string] $Uri,
    [object] $Body = $null
  )

  $params = @{
    Method = $Method
    Uri = $Uri
    UseBasicParsing = $true
    TimeoutSec = 20
  }

  if ($null -ne $Body) {
    $params.ContentType = "application/json"
    $params.Body = ($Body | ConvertTo-Json -Depth 10)
  }

  try {
    $response = Invoke-WebRequest @params
    return @{
      status = [int] $response.StatusCode
      body = $response.Content
    }
  }
  catch {
    if ($_.Exception.Response) {
      $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
      return @{
        status = [int] $_.Exception.Response.StatusCode
        body = $reader.ReadToEnd()
      }
    }

    throw
  }
}

function Test-HttpService {
  param(
    [string] $Service,
    [int] $Port,
    [scriptblock] $Tests
  )

  Write-Host "`n== $Service =="
  $job = Start-Forward -Service $Service -LocalPort $Port -RemotePort $Port

  try {
    & $Tests "http://127.0.0.1:$Port"
  }
  finally {
    Stop-Forward $job
  }
}

function Show-Result {
  param(
    [string] $Name,
    [hashtable] $Result
  )

  $body = $Result.body
  if ($body.Length -gt 220) {
    $body = $body.Substring(0, 220)
  }

  Write-Host "$Name -> $($Result.status) $body"
}

$driverAddress = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
$rideId = "smoke-$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"

Test-HttpService "api-gateway" 4000 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "GET /api/v1/analytics/health" (Invoke-Json GET "$Base/api/v1/analytics/health")
}

Test-HttpService "auth-service" 4001 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "POST /auth/register" (Invoke-Json POST "$Base/auth/register" @{ userType = 1 })
}

Test-HttpService "blockchain-service" 4002 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
}

Test-HttpService "vehicle-service" 4003 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
}

Test-HttpService "payment-service" 4004 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
}

Test-HttpService "reputation-service" 4007 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "POST /violation/report" (Invoke-Json POST "$Base/violation/report" @{
    driverAddress = $driverAddress
    penalty = 1
  })
}

Test-HttpService "ride-matching-service" 4008 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "POST /match/match" (Invoke-Json POST "$Base/match/match" @{
    pickup = @{
      lat = 28.6139
      lng = 77.2090
    }
  })
  Show-Result "POST /driver/respond expected 404" (Invoke-Json POST "$Base/driver/respond" @{
    rideId = "missing-ride"
    driverId = "driver-1"
    action = "ACCEPT"
  })
}

Test-HttpService "ride-service" 4009 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "POST /location/driver-location" (Invoke-Json POST "$Base/location/driver-location" @{
    driverId = "driver-1"
    lat = 28.6139
    lng = 77.2090
  })
  Show-Result "POST /ride/create" (Invoke-Json POST "$Base/ride/create" @{
    rideId = $rideId
    pickup = @{
      lat = 28.6139
      lng = 77.2090
    }
    driverAddress = $driverAddress
  })
  Show-Result "POST /ride/complete" (Invoke-Json POST "$Base/ride/complete" @{
    rideId = $rideId
    driverAddress = $driverAddress
  })
}

Test-HttpService "analytics-service" 4010 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
}

Test-HttpService "realtime-service" 4011 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
  Show-Result "GET /vehicle/data" (Invoke-Json GET "$Base/vehicle/data")
  Show-Result "GET /violation/list" (Invoke-Json GET "$Base/violation/list")
  Show-Result "POST /notify-driver" (Invoke-Json POST "$Base/notify-driver" @{
    driverId = "driver-1"
    rideId = $rideId
  })
}

Test-HttpService "iot-service" 4012 {
  param($Base)
  Show-Result "GET /health" (Invoke-Json GET "$Base/health")
}

Write-Host "`n== blockchain RPC =="
$rpcJob = Start-Forward -Service "blockchain" -LocalPort 8545 -RemotePort 8545
try {
  Show-Result "POST eth_blockNumber" (Invoke-Json POST "http://127.0.0.1:8545" @{
    jsonrpc = "2.0"
    id = 1
    method = "eth_blockNumber"
    params = @()
  })
}
finally {
  Stop-Forward $rpcJob
}

Write-Host "`nEndpoint smoke tests completed."
