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
      appBar: AppBar(
        title: Text("Geofence List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          key: const Key("add geofence"),
          heroTag: "action_geofence",
          onPressed: () => Navigator.of(context).pushNamed("/geofence/add"),
          icon: Icon(Icons.add),
          label: Text("Add Geofence")),
      body: StreamBuilder<List<Geofence>>(
          stream: bloc.startStream(),
          builder: (context, snapshot) {
            return snapshot.data?.isEmpty ?? true
                ? Center(
                    child: Card(
                      margin: EdgeInsets.all(8).copyWith(bottom: 32),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        child: Text(
                          "No geofence found.",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ),
                  )
                : buildGeofenceList();
          }),
    );
  }

  ListView buildGeofenceList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Geofence geofence = bloc.data[index];
        String radiusText;
        if (geofence.radius >= 1000)
          radiusText = "${geofence.radius / 1000.0}km";
        else
          radiusText = "${geofence.radius}m";
        return Card(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8).copyWith(left: 16),
            title: Text(
              geofence.wifiName ?? geofence.bssid,
              key: const Key("WiFi name"),
            ),
            subtitle: Text(
                "${geofence.latitude}, ${geofence.longitude} ($radiusText)"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 32,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => bloc.edit(context, geofence)),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () => bloc.delete(geofence)),
              ],
            ),
          ),
        );
      },
      itemCount: bloc.data?.length ?? 0,
    );
  }
}
