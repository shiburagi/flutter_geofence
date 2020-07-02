import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/resources/database.dart';

import '../entities/geofence.dart';

class GeofenceBloc extends BaseBloc<List<Geofence>> {
  Geofence _geofence;
  String bssidValidator(value) {
    if (value.isEmpty) return "BSSID is required";

    _geofence.bssid = value;
    return null;
  }

  String wifiNameValidator(value) {
    if (value.isEmpty) return "WIfI Name is required";

    _geofence.wifiName = value;
    return null;
  }

  String radiusValidator(String value) {
    if (value.isEmpty) return "Radius is required";
    _geofence.radius = double.tryParse(value);
    return null;
  }

  String latitudeValidator(value) {
    if (value.isEmpty) return "Latitude is required";

    return null;
  }

  String longitudeValidator(value) {
    if (value.isEmpty) return "Longitude is required";

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
