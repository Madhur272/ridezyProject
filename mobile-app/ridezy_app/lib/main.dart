// import 'package:flutter/material.dart';
// import 'screens/role_selector.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RoleSelector(),
//     );

//   }
// }

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const RidezyApp());
}

class RidezyApp extends StatelessWidget {
  const RidezyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ridezy',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}