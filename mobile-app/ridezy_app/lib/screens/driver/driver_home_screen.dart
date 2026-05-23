import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../services/api_service.dart';
import '../../services/socket_service.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  Map? currentRide;

  @override
  void initState() {
    super.initState();

    SocketService.connect();

    SocketService.socket.onConnect((_) {

      SocketService.socket.on("ride_request", (data) {

        setState(() {
          currentRide = data;
        });
      });
    });
  }

  Future respond(String action) async {

    if (currentRide == null) return;

    await ApiService.respondToRide({
      "rideId": currentRide!['rideId'],
      "driverId": currentRide!['driverId'],
      "action": action,
    });

    setState(() {
      currentRide = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
      ),

      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                Text(
                  "Today's Earnings",
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 10),

                Text(
                  "₹2,450",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [

                        Text("AI Safety Analytics"),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Lane Violations"),
                            Text("1")
                          ],
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Harsh Braking"),
                            Text("0")
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          if (currentRide != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Text(
                        "New Ride Request",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Ride ID: ${currentRide!['rideId']}",
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton(
                            onPressed: () => respond("ACCEPT"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Accept"),
                          ),

                          ElevatedButton(
                            onPressed: () => respond("REJECT"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Reject"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}