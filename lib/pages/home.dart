import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geolocation.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BlocState<HomePage, GeolocationBloc> {
  @override
  void didChangeDependencies() {
    bloc.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "action_geofence",
        onPressed: () {
          Navigator.of(context).pushNamed("/geofence");
        },
        label: Text("Geofence List"),
        icon: Icon(Icons.my_location),
      ),
    );
  }
}
