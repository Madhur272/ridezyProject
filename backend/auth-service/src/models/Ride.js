const mongoose = require("mongoose");

const RideSchema = new mongoose.Schema({

  riderId:String,
  driverId:String,
  vehicleId:String,

  pickupLocation:{
    type:{
      type:String,
      enum:["Point"],
      default:"Point"
    },
    coordinates:[Number]
  },

  dropLocation:{
    type:{
      type:String,
      enum:["Point"],
      default:"Point"
    },
    coordinates:[Number]
  },

  status:{
    type:String,
    enum:[
      "BOOKED",
      "MATCHING",
      "IN_PROGRESS",
      "COMPLETED",
      "CANCELLED"
    ]
  },

  fare:Number

},{timestamps:true})

RideSchema.index({pickupLocation:"2dsphere"})

module.exports = mongoose.model("Ride",RideSchema)