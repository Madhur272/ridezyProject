import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/socket_service.dart';

class RiderMapScreen extends StatefulWidget {
  const RiderMapScreen({super.key});

  @override
  State<RiderMapScreen> createState() => _RiderMapScreenState();
}

class _RiderMapScreenState extends State<RiderMapScreen> {

  LatLng driverLocation = const LatLng(28.4595, 77.0266);

  @override
  void initState() {
    super.initState();

    SocketService.connect();

    SocketService.socket.on("vehicle_update", (data) {

      setState(() {
        driverLocation = LatLng(
          data['lat'],
          data['lng'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Ride Tracking"),
      ),

      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: driverLocation,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("driver"),
                position: driverLocation,
              )
            },
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "AI Driving Status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Safe Driving Detected",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}