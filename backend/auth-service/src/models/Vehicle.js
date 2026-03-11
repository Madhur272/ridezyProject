const mongoose = require("mongoose");

const VehicleSchema = new mongoose.Schema({

  ownerWallet:String,

  make:String,
  model:String,
  year:Number,

  nftTokenId:String,

  status:{
    type:String,
    enum:["AVAILABLE","IN_RIDE","MAINTENANCE"]
  },

  location:{
    type:{
      type:String,
      enum:["Point"],
      default:"Point"
    },
    coordinates:[Number]
  }

},{timestamps:true})

VehicleSchema.index({location:"2dsphere"})

module.exports = mongoose.model("Vehicle",VehicleSchema)