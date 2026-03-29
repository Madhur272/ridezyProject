import React, { useEffect, useState } from "react";
import { getVehicleData } from "../services/api";
import { io } from "socket.io-client";

function Dashboard() {

  const [vehicles, setVehicles] = useState([]);

  useEffect(() => {

    const socket = io("http://localhost:4011");

    socket.on("vehicle_update", (data) => {

      setVehicles(prev => {

        const updated = [...prev];

        const index = updated.findIndex(v => v.driverId === data.driverId);

        if (index !== -1) {
          updated[index] = data;
        } else {
          updated.push(data);
        }

        return updated;
      });

    });

    return () => socket.disconnect();

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