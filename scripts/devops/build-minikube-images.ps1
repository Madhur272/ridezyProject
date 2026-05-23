$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\..")

$backendServices = @(
  "api-gateway",
  "auth-service",
  "blockchain-service",
  "vehicle-service",
  "payment-service",
  "reputation-service",
  "ride-matching-service",
  "ride-service",
  "analytics-service",
  "realtime-service",
  "iot-service"
)

Write-Host "Pointing Docker CLI at Minikube's Docker daemon..."
minikube docker-env --shell powershell | Invoke-Expression

Write-Host "Building blockchain node image..."
docker build `
  -t ridezyproject-blockchain:latest `
  (Join-Path $repoRoot "blockchain")

foreach ($service in $backendServices) {
  Write-Host "Building $service image..."
  docker build `
    -f (Join-Path $repoRoot "backend\Dockerfile.service") `
    --build-arg "SERVICE_NAME=$service" `
    -t "ridezyproject-$service`:latest" `
    (Join-Path $repoRoot "backend")
}

Write-Host "Minikube images are ready."
