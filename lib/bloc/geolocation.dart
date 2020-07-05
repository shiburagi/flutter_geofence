import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/entities/geofence.dart';
import 'package:setel_geofence/resources/database.dart';

class GeolocationBloc extends BaseBloc<Geofence> {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort _port;
  LatLng _currentLocation;
  Location _location;
  bool _isWifiActive = false;
  bool get isWifiActive => _isWifiActive;
  bool _isLocationActive = false;
  bool get isLocationActive => _isLocationActive;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;
  /*
   * Initialize location changed listener
   */
  init() async {
    _location = Location();
    _location.changeSettings(
      distanceFilter: 10,
    );
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _isLocationActive = await _location.serviceEnabled();
    if (!_isLocationActive) {
      sink.add(null);
      return;
    }
    if (_serviceEnabled == _isLocationActive) {
      return;
    }

    _serviceEnabled = _isLocationActive;

    try {
      _location.onLocationChanged.listen(onLocationListen);
      networkListener();
    } catch (e, s) {
      debugPrint(s.toString());
    }
  }

  /*
   * Method to receive new location data
   */
  onLocationListen(event) async {
    debugPrint("listen $event");
    try {
      _isLocationActive = await _location.serviceEnabled();
      LatLng latLng = LatLng(event.latitude, event.longitude);
      onDataReceive(latLng);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*
   * Initialize port and server for background location service
   */
  initBackgroundLocation() async {
    if (_port != null) return;
    if (await BackgroundLocator.isRegisterLocationUpdate())
      stopLocationService();
    try {
      _port = ReceivePort();
      IsolateNameServer.registerPortWithName(_port.sendPort, _isolateName);
      _port.listen((dynamic data) {
        LocationDto dto = data;
        onDataReceive(LatLng(dto.latitude, dto.longitude));
      });
      await initPlatformState();
      networkListener();
    } catch (e, s) {
      debugPrint(s.toString());
    }
    startLocationService();
  }

  /*
   * Method to handle location data and retrieve nearest geofence,
   * If none, return null
   */
  Future onDataReceive(LatLng latLng) async {
    debugPrint("onDataReceive");
    Connectivity connectivity = Connectivity();
    String wifiBSSID;
    if ((await connectivity.checkConnectivity()) == ConnectivityResult.wifi) {
      _isWifiActive = true;
      wifiBSSID = await connectivity.getWifiBSSID();
    } else {
      _isWifiActive = false;
    }
    Geofence geofence =
        await AppDatabase.instance.getGeofenceNear(latLng, wifiBSSID);
    _currentLocation = latLng;

    sink.add(geofence);
  }

  /* 
   * initialize backgrounf locator;
   */
  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  networkListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (_currentLocation != null) onDataReceive(_currentLocation);
    });
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
    _port = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
