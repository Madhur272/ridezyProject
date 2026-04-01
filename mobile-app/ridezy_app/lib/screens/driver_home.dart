import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import '../services/api_service.dart';

class DriverHome extends StatefulWidget {
  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {

  Map? currentRide;

  @override
  void initState() {
    super.initState();

    SocketService.connect();
    
    // WAIT for connection before listening
    SocketService.socket.on("connect", (_) {
      SocketService.socket.onAny((event, data) {
        print("📡 Event: $event | Data: $data");
      });
    
      print("Listening for ride_request...");

      SocketService.socket.on("ride_request", (data) {

        print("🔥 New Ride Received: $data");

        setState(() {
          currentRide = data;
        });

      });

    });

}

  Future respondToRide(String action) async {

    if (currentRide == null) return;

    await ApiService.respondToRide({
      "rideId": currentRide!["rideId"],
      "driverId": currentRide!["driverId"],
      "action": action
    });

    setState(() {
      currentRide = null;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Driver Dashboard")),

      body: Stack(
        children: [

          Center(
            child: Text("Waiting for ride requests..."),
          ),

          if (currentRide != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
   
                      Text(
                        "New Ride Request 🚗",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 10),

                      Text("Ride ID: ${currentRide!["rideId"]}"),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () => respondToRide("ACCEPT"),
                            child: Text("Accept"),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => respondToRide("REJECT"),
                            child: Text("Reject"),
                          ),

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