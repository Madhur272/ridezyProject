import React, { useState } from "react";
import Dashboard from "./components/Dashboard";
import MapView from "./components/MapView";

function App() {

  const [vehicles, setVehicles] = useState([]);

  return (
    <div style={{ padding: "20px" }}>
      <h1>Ridezy Admin Dashboard</h1>

      <div style={{ display: "flex", gap: "20px" }}>

        <div style={{ flex: 1 }}>
          <Dashboard setVehicles={setVehicles} />
        </div>

        <div style={{ flex: 1 }}>
          <MapView vehicles={vehicles} />
        </div>

      </div>
    </div>
  );
}

export default App;