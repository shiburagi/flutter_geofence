import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/resources/database.dart';
import 'package:setel_geofence/views/dialog.dart';

import '../entities/geofence.dart';

class GeofenceBloc extends BaseBloc<List<Geofence>> {
  retrieveData() async {
    List<Geofence> geofences = await AppDatabase.instance.getGeofences();
    sink.add(geofences);
  }

  Stream<List<Geofence>> startStream() {
    if (data == null) retrieveData();
    return stream;
  }

  Geofence _geofence;
  set geofence(geofence) => this._geofence = geofence;
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

  void addGeofence(GlobalKey<FormState> formKey,
      {Geofence referGeofence}) async {
    bool isEdit = referGeofence != null;
    _geofence ??= Geofence();
    if (formKey.currentState.validate()) {
      if (!isEdit &&
          await AppDatabase.instance.getGeofence(_geofence.bssid) != null) {
        //check if the bssid already exist in DB
        showSimpleNotification(Text("BSSID already exist in the list."),
            background: Theme.of(context).errorColor);
        return;
      }
      if (isEdit) {
        await AppDatabase.instance
            .updateGeofence(referGeofence.bssid, _geofence);
        showSimpleNotification(Text("Geofence updated"),
            background: Theme.of(context).accentColor);
      } else
        await AppDatabase.instance.addGeofence(_geofence);
      showSimpleNotification(Text("Geofence saved"),
          background: Theme.of(context).accentColor);
      await retrieveData();

      if (isEdit)
        Navigator.of(context).pop();
      else
        formKey.currentState.reset();
    }
  }

  /*
   * Method to trigger remove action and delete geofence record in db
   */
  delete(BuildContext context, Geofence geofence) async {
    bool isConfirm = await showConfirmationDialog(
        context, "Are you sure want delete this geofence?");
    if (isConfirm == true &&
        await AppDatabase.instance.deleteGeofence(geofence) > 0)
      await retrieveData();
  }

  /*
   * Method to trigger edit action
   */
  edit(BuildContext context, Geofence geofence) {
    Navigator.of(context).pushNamed("/geofence/add", arguments: geofence);
  }
}
