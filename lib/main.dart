import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shareloc/home_page.dart';
import 'package:shareloc/models/user_location.dart';
import 'package:shareloc/services/location_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      initialData: UserLocation(latitude: -6.9859062, longitude: 110.414304),
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        title: 'ShareLoc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
