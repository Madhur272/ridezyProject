const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({

  walletAddress:{
    type:String,
    required:true,
    unique:true
  },

  userType:{
    type:String,
    enum:["RIDER","DRIVER","VEHICLE_OWNER"]
  },

  email:String,
  phone:String,

  verificationStatus:{
    type:String,
    enum:["PENDING","VERIFIED","REJECTED"],
    default:"PENDING"
  },

  credibilityScore:{
    type:Number,
    default:75
  }

},{timestamps:true});

module.exports = mongoose.model("User",UserSchema);