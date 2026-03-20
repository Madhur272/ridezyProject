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
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});