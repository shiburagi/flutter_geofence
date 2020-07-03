import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';

class GeolocationBloc extends BaseBloc {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port;

  init() async {
    if (port != null) return;
    await Permission.location.request();
    try {
      debugPrint("init");
      port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
      port.listen((dynamic data) {
        // debugPrint("data");
        LocationDto dto = data;
      });
      initPlatformState();
    } catch (e, s) {
      debugPrint(s.toString());
    }
    debugPrint("init end");
    startLocationService();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  void startLocationService() {
    debugPrint("startLocationService");

    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
          //Scroll down to see the different options
          notificationTitle: "Start Location Tracking example",
          notificationMsg: "Track location in background exapmle",
          wakeLockTime: 1,
          autoStop: false,
          interval: 1),
    );
  }
}
