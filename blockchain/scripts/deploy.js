async function main() {

  const [deployer] = await ethers.getSigners();

  console.log("Deploying with:", deployer.address);

  // Deploy Token
  const Token = await ethers.getContractFactory("RidezyToken");
  const token = await Token.deploy();
  await token.waitForDeployment();

  console.log("Token deployed:", token.target);

  // Deploy UserRegistry
  const Registry = await ethers.getContractFactory("UserRegistry");
  const registry = await Registry.deploy();
  await registry.waitForDeployment();

  console.log("UserRegistry deployed:", registry.target);

  // Deploy VehicleNFT
  const Vehicle = await ethers.getContractFactory("VehicleNFT");
  const vehicle = await Vehicle.deploy();
  await vehicle.waitForDeployment();

  console.log("VehicleNFT deployed:", vehicle.target);

  // Deploy Ride Payment Escrow
  const Escrow = await ethers.getContractFactory("RidePaymentEscrow");
  const escrow = await Escrow.deploy();
  await escrow.waitForDeployment();

  console.log("Escrow deployed:", escrow.target);

  // Deploy Credibility Scoring 
  const Score = await ethers.getContractFactory("CredibilityScoring");
  const score = await Score.deploy();
  await score.waitForDeployment();

  console.log("CredibilityScoring deployed:", score.target);

  // Deploy Vehicle Wallet
  const Wallet = await ethers.getContractFactory("VehicleWallet");
  const wallet = await Wallet.deploy();
  await wallet.waitForDeployment();

  console.log("VehicleWallet deployed:", wallet.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});