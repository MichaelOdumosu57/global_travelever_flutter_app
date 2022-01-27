import 'package:flutter/material.dart';
import 'package:global_traveler_app/data/moor_db.dart';
import 'package:global_traveler_app/screens/home.dart';
import 'package:provider/provider.dart';
// import 'package:travel_app/data/sharedprefs.dart';
// import 'package:travel_app/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SPSettings settings = SPSettings();

    return Provider(
      create: (context) => BlogDb(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Raleway',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: const SettingsScreen(),
          home: HomeScreen()),
    );
  }
}
