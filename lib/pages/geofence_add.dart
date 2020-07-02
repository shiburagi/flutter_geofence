import 'package:flutter/material.dart';

class GeofenceAddPage extends StatefulWidget {
  GeofenceAddPage({Key key}) : super(key: key);

  @override
  _GeofenceAddPageState createState() => _GeofenceAddPageState();
}

class _GeofenceAddPageState extends State<GeofenceAddPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "add_geofence",
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(),
      ),
    );
  }
}
