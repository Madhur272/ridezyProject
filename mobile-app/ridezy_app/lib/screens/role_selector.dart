import 'package:flutter/material.dart';
import 'rider_home.dart';
import 'driver_home.dart';

class RoleSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Ridezy")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RiderHome()),
                );
              },
              child: Text("Continue as Rider"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DriverHome()),
                );
              },
              child: Text("Continue as Driver"),
            ),

          ],
        ),
      ),
    );
  }
}