import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/socket_service.dart';

class RiderMap extends StatefulWidget {
  @override
  _RiderMapState createState() => _RiderMapState();
}

class _RiderMapState extends State<RiderMap> {

  GoogleMapController? mapController;

  LatLng driverLocation = LatLng(28.45, 77.02);

  @override
  void initState() {
    super.initState();

    SocketService.connect();

    SocketService.socket.on("vehicle_update", (data) {

      setState(() {
        driverLocation = LatLng(data["lat"], data["lng"]);
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Track Driver")),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: driverLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId("driver"),
            position: driverLocation,
          )
        },
      ),
    );
  }
}