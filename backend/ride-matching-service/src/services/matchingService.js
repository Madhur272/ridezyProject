// const Vehicle = require("../../../vehicle-service/src/models/Vehicle")

// async function findNearbyDrivers(lng, lat) {

//   const drivers = await Vehicle.find({
//     status: "AVAILABLE",
//     location: {
//       $near: {
//         $geometry: {
//           type: "Point",
//           coordinates: [lng, lat]
//         },
//         $maxDistance: 5000
//       }
//     }
//   });

//   return drivers;
// }

// module.exports = { findNearbyDrivers }
