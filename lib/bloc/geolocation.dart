import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/entities/geofence.dart';
import 'package:setel_geofence/resources/database.dart';

class GeolocationBloc extends BaseBloc<Geofence> {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port;

  /*
   * Initialize port and server fro location service
   */
  init() async {
    if (port != null) return;
    await Permission.location.request();
    if (await BackgroundLocator.isRegisterLocationUpdate())
      stopLocationService();
    try {
      debugPrint("init");
      port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
      port.listen((dynamic data) {
        debugPrint("listen");

        onDataReceive(data);
      });
      await initPlatformState();
    } catch (e, s) {
      debugPrint(s.toString());
    }
    debugPrint("init end");
    startLocationService();
  }

  /*
   * Method to handle location data and retrieve nearest geofence,
   * If none, return null
   */
  Future onDataReceive(LocationDto dto) async {
    debugPrint("onDataReceive");
    String wifiBSSID = await (Connectivity().getWifiBSSID());
    Geofence geofence = await AppDatabase.instance
        .getGeofenceNear(dto.latitude, dto.longitude, wifiBSSID);

    sink.add(geofence);
  }

  /* 
   * initialize backgrounf locator;
   */
  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  /*
   * Method to handle user interaction on location notification
   */
  static void notificationCallback() {}

  void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
          notificationTitle: "Setel Geofence",
          notificationMsg: "Track location in background",
          wakeLockTime: 20,
          autoStop: false,
          distanceFilter: 10,
          interval: 1),
    );
  }

  /*
   * Method to stop using location.
   */
  void stopLocationService() {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    port = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
