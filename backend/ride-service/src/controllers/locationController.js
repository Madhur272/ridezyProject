// Driver Location API
const Joi = require("joi");

// Validation schema for location update
const locationSchema = Joi.object({
  driverId: Joi.string().required(),
  lat: Joi.number().required(),
  lng: Joi.number().required()
});

const { updateDriverLocation } = require("../services/locationService");

async function updateLocation(req, res) {

  try{
    const { error } = locationSchema.validate(req.body);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    const { driverId, lat, lng } = req.body;

    await updateDriverLocation(driverId, lat, lng);

    res.json({ status: "location updated" });
  }
  catch(err){
    console.error("Error updating location:", err);
    res.status(500).json({ error: "Internal server error, failed to update location." });
  }
}

module.exports = { updateLocation };