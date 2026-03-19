const distance = require("../utils/distance");

async function rankDrivers(drivers, pickup) {

  const ranked = drivers.map(driver => {

    const dist = distance(
      pickup.lat,
      pickup.lng,
      driver.lat,
      driver.lng
    );

    return {
      ...driver,
      distance: dist
    };

  });

  ranked.sort((a,b) => a.distance - b.distance);

  return ranked;

}

module.exports = { rankDrivers };