import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";

function MapView({ vehicles }) {

  return (
    <MapContainer
      center={[28.45, 77.02]}
      zoom={13}
      style={{ height: "400px", width: "100%" }}
    >
      
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />

      {vehicles.map((v, i) => {

        if (!v.lat || !v.lng) return null;

        return (
          <Marker key={i} position={[v.lat, v.lng]}>
            <Popup>
              Driver: {v.driverId} <br />
              Speed: {v.speed}
            </Popup>
          </Marker>
        );

      })}

    </MapContainer>
  );
}

export default MapView;