import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geofence.dart';
import 'package:setel_geofence/entities/geofence.dart';

class GeofenceListPage extends StatefulWidget {
  GeofenceListPage({Key key}) : super(key: key);

  @override
  _GeofenceListPageState createState() => _GeofenceListPageState();
}

class _GeofenceListPageState extends BlocState<GeofenceListPage, GeofenceBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "action_geofence",
          onPressed: () => Navigator.of(context).pushNamed("/geofence/add"),
          icon: Icon(Icons.add),
          label: Text("Add Geofence")),
      body: StreamBuilder<List<Geofence>>(
          stream: bloc.startStream(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemBuilder: (context, index) {
                Geofence geofence = bloc.data[index];
                return ListTile(
                  title: Text(geofence.wifiName ?? geofence.bssid),
                  subtitle: Text(
                      "${geofence.latitude}, ${geofence.longitude} (${geofence.radius}km)"),
                );
              },
              itemCount: bloc.data?.length ?? 0,
            );
          }),
    );
  }
}
