import axios from "axios";

const API = axios.create({
  baseURL: "http://localhost:4011"
});

export const getVehicleData = () => API.get("/vehicle/data");
export const getViolations = () => API.get("/violation/list");