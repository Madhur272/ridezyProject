import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'rider_map.dart';

class RiderHome extends StatelessWidget {

  void bookRide(BuildContext context) async {

    final res = await ApiService.createRide({
      "rideId": "ride_${DateTime.now().millisecondsSinceEpoch}",
      "pickup": {
        "lat": 28.45,
        "lng": 77.02
      },
      "driverAddress": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    });

    print(res);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RiderMap()),
    );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Ridezy Rider")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => bookRide(context),
          child: Text("Book Ride"),
        ),
      ),
    );
  }
}



// influx db, redis cli, mqtt