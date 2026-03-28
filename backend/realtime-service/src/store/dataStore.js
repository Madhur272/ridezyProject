const vehicleDataMap = {};
const violations = [];

function addVehicleData(data) {

  // keep last 50 entries
  vehicleDataMap[data.driverId] = data; 
}

function getVehicleData() {
   return Object.values(vehicleDataMap);
}

function addViolation(v) {

  violations.unshift(v);

  if (violations.length > 50) {
    violations.pop();
  }
}

function getViolations() {
  return violations;
}

module.exports = {
  addVehicleData,
  getVehicleData,
  addViolation,
  getViolations
};