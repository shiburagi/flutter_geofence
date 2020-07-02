import 'dart:developer';

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

  // GEOFENCES : BEGIN
  storeGeofence(Geofence s) async {
    var store = geofencesStore;
    return await store.add(db, s.toJson());
  }

  Future<List<Geofence>> getGeofences() async {
    var store = geofencesStore;
    List<RecordSnapshot> snapshots = await store.find(db);
    return snapshots.map((e) => Geofence.fromJson(e as Map)).toList();
  }

  Future<Geofence> getGeofence(String bssid) async {
    var store = geofencesStore;
    RecordSnapshot snapshot = await store.findFirst(db,
        finder: Finder(filter: Filter.equals("bssid", bssid)));
    return snapshot == null ? null : Geofence.fromJson(snapshot.value);
  }

  Future deleteGeofence(int index) async {
    var store = geofencesStore;
    try {
      return await store.record(index).delete(db);
    } catch (e) {
      return null;
    }
  }
  // GEOFENCES : END

}
