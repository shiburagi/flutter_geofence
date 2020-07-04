import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geolocation.dart';
import 'package:setel_geofence/entities/geofence.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BlocState<HomePage, GeolocationBloc>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bloc.init();
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bloc.init();
    }
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
        key: const Key("geofence list"),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all(color: color)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    isInside ? "Inside" : "Outside",
                    key: const Key("status"),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: color),
                  ),
                ),
                Divider(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildIndicator("Location", bloc.isLocationActive),
                    buildIndicator("WiFi", bloc.isWifiActive),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildIndicator(String label, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.red,
                shape: BoxShape.circle),
          ),
          SizedBox(
            width: 16,
          ),
          Text(label),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
