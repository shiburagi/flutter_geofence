import 'package:flutter/material.dart';
import 'package:setel_geofence/pages/home.dart';
import 'package:setel_geofence/pages/geofence_add.dart';

void main() {
  runApp(MyApp());
}

Map<String, WidgetBuilder> routes = {
  "/": (c) => HomePage(),
  "/geofence/add": (c) => GeofenceAddPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
    );
  }
}
