import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RiderHome extends StatelessWidget {

  void bookRide() async {

    final res = await ApiService.createRide({
      "rideId": "ride_${DateTime.now().millisecondsSinceEpoch}",
      "pickup": {
        "lat": 28.45,
        "lng": 77.02
      },
      "driverAddress": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    });

    print(res);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Ridezy Rider")),
      body: Center(
        child: ElevatedButton(
          onPressed: bookRide,
          child: Text("Book Ride"),
        ),
      ),
    );
  }
}