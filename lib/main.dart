import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:setel_geofence/bloc/geofence.dart';
import 'package:setel_geofence/pages/geofence_list.dart';
import 'package:setel_geofence/pages/home.dart';
import 'package:setel_geofence/pages/geofence_add.dart';
import 'package:setel_geofence/resources/database.dart';
import 'package:setel_geofence/views/loading.dart';

void main() {
  runApp(MyApp());
}

Map<String, WidgetBuilder> routes = {
  "/": (context) => SplashBuilder(
        onStart: (context) async {
          await AppDatabase.instance.init();
          return true;
        },
        hasAccess: (access) => access,
        landingRoute: "/home",
      ),
  "/home": (context) => HomePage(),
  "/geofence": (context) => GeofenceListPage(),
  "/geofence/add": (context) => LoadingView(child: GeofenceAddPage()),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderBoilerplate(
      providers: [
        registerProvider(GeofenceBloc()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Setel Geofence',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: routes,
        ),
      ),
    );
  }
}
