import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:setel_geofence/entities/geofence.dart';

class AppDatabase {
  static const String GPS_LOG_KEY = "GpsLog";
  static const String TRANSLATION_KEY = "Translations";
  static const String QUEUE_NOTIFICATION_KEY = "QueueNotification";

  Database db;
  static AppDatabase _instance = AppDatabase();

  static AppDatabase get instance => _instance;
  Future<AppDatabase> init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'setel_geofence.db');
    db = await databaseFactoryIo.openDatabase(dbPath);
    return this;
  }

  StoreRef get geofencesStore => intMapStoreFactory.store('geofences');
  StoreRef get locationStore => intMapStoreFactory.store('locations');

  // GEOFENCES : BEGIN
  addGeofence(Geofence geofence) async {
    var store = geofencesStore;
    return await store.add(db, geofence.toJson());
  }

  updateGeofence(Geofence geofence) async {
    var store = geofencesStore;
    return await store.update(db, geofence.toJson(),
        finder: Finder(filter: Filter.equals("bssid", geofence.bssid)));
  }

  Future<List<Geofence>> getGeofences() async {
    var store = geofencesStore;
    List<RecordSnapshot> snapshots = await store.find(db);
    return snapshots.map((e) => Geofence.fromJson(e.value as Map)).toList();
  }

  Future<Geofence> getGeofence(String bssid) async {
    var store = geofencesStore;
    RecordSnapshot snapshot = await store.findFirst(db,
        finder: Finder(filter: Filter.equals("bssid", bssid)));
    return snapshot == null ? null : Geofence.fromJson(snapshot.value);
  }

  Future<Geofence> getGeofenceNear(LatLng latLng, String bssid) async {
    var store = geofencesStore;
    final Distance distance = const Distance();

    RecordSnapshot snapshot = await store.findFirst(db,
        finder: Finder(filter: Filter.custom((record) {
      try {
        Geofence geofence = Geofence.fromJson(record.value);
        log("$latLng");

        double meter = distance.as(
          LengthUnit.Meter,
          LatLng(geofence.latitude, geofence.longitude),
          latLng,
        );
        log("$meter, $bssid");
        if (meter <= geofence.radius || bssid == geofence.bssid) {
          return true;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return false;
    })));
    debugPrint("filter: $snapshot");

    return snapshot == null ? null : Geofence.fromJson(snapshot.value);
  }

  Future deleteGeofenceAt(int index) async {
    var store = geofencesStore;
    try {
      return await store.record(index).delete(db);
    } catch (e) {
      return null;
    }
  }

  Future<int> deleteGeofence(Geofence geofence) async {
    var store = geofencesStore;
    try {
      return await store.delete(db,
          finder: Finder(filter: Filter.equals("bssid", geofence.bssid)));
    } catch (e) {
      return null;
    }
  }
  // GEOFENCES : END

}
