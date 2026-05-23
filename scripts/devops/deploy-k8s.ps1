param(
  [switch] $SkipBuild
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\..")

if (-not $SkipBuild) {
  & (Join-Path $scriptDir "build-minikube-images.ps1")
}

Write-Host "Applying Kubernetes manifests..."
kubectl apply -k (Join-Path $repoRoot "k8s")

$deployments = @(
  "mongo",
  "redis",
  "influxdb",
  "mqtt",
  "blockchain",
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

foreach ($deployment in $deployments) {
  Write-Host "Waiting for deployment/$deployment..."
  kubectl -n ridezy rollout status "deployment/$deployment" --timeout=180s
}

Write-Host "Cluster surface:"
kubectl -n ridezy get pods,svc

Write-Host "Local access:"
Write-Host "  powershell -ExecutionPolicy Bypass -File scripts\devops\port-forward-k8s.ps1"
Write-Host "  API gateway: http://127.0.0.1:4000"
Write-Host "  Realtime Socket.IO: http://127.0.0.1:4011"
