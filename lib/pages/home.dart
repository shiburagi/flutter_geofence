import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "add_geofence",
        onPressed: () {
          Navigator.of(context).pushNamed("/geofence/add");
        },
        label: Text("Add Geofence"),
        icon: Icon(Icons.my_location),
      ),
    );
  }
}
