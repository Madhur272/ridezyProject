import React, { useEffect, useState } from "react";
import { getVehicleData } from "../services/api";

function Dashboard() {

  const [vehicles, setVehicles] = useState([]);

  useEffect(() => {

    const fetchData = async () => {

      const res = await getVehicleData();

      setVehicles(res.data); // ✅ important
    };

    fetchData();

    const interval = setInterval(fetchData, 3000);

    return () => clearInterval(interval);

  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <h2>Vehicle Dashboard</h2>

      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))",
        gap: "20px"
      }}>
        {vehicles.map((v, i) => (
          <div key={i} style={{
            border: "1px solid #ccc",
            borderRadius: "10px",
            padding: "15px",
            boxShadow: "0 2px 6px rgba(0,0,0,0.1)"
          }}>
            <h3>{v.driverId}</h3>
            <p><b>Speed:</b> {v.speed} km/h</p>
            <p><b>Lat:</b> {v.lat.toFixed(4)}</p>
            <p><b>Lng:</b> {v.lng.toFixed(4)}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Dashboard;