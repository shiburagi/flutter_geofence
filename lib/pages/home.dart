import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geolocation.dart';
import 'package:setel_geofence/entities/geofence.dart';

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
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: buildMainContent(),
      ),
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

  StreamBuilder<Geofence> buildMainContent() {
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) {
        bool isInside = snapshot.data != null;
        Color color = isInside ? Colors.teal : Theme.of(context).errorColor;
        return ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  Scaffold.of(context).appBarMaxHeight -
                  32),
          child: Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: color)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                isInside ? "Inside" : "Outside",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
