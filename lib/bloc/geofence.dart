import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/resources/database.dart';

import '../entities/geofence.dart';

class GeofenceBloc extends BaseBloc<List<Geofence>> {
  retrieveData() {
    AppDatabase.instance.getGeofences().then((value) => sink.add(value));
  }

  Stream<List<Geofence>> startStream() {
    if (data == null) retrieveData();
    return stream;
  }

  Geofence _geofence;
  String bssidValidator(String value) {
    if (value.isEmpty) return "BSSID is required";

    _geofence.bssid = value;
    return null;
  }

  String wifiNameValidator(String value) {
    if (value.isEmpty) return "WIfI Name is required";

    _geofence.wifiName = value;
    return null;
  }

  String radiusValidator(String value) {
    if (value.isEmpty) return "Radius is required";
    _geofence.radius = double.tryParse(value);
    return null;
  }

  String latitudeValidator(String value) {
    if (value.isEmpty) return "Latitude is required";
    _geofence.latitude = double.tryParse(value);

    return null;
  }

  String longitudeValidator(String value) {
    if (value.isEmpty) return "Longitude is required";
    _geofence.longitude = double.tryParse(value);

    return null;
  }

  void addGeofence(GlobalKey<FormState> formKey) async {
    _geofence ??= Geofence();
    if (formKey.currentState.validate()) {
      await AppDatabase.instance.addGeofence(_geofence);
      List<Geofence> geofences = await AppDatabase.instance.getGeofences();
      formKey.currentState.reset();
      debugPrint("geofences: ${geofences.length}");
    }
  }
}
