import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class DriverHome extends StatefulWidget {
  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {

  @override
  void initState() {
    super.initState();

    SocketService.connect();

    SocketService.socket.on("ride_request", (data) {
      print("New Ride: $data");

      // 👉 Later: show popup here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Dashboard")),
      body: Center(
        child: Text("Waiting for ride requests..."),
      ),
    );
  }
}