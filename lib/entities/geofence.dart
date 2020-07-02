import 'dart:math';

class Geofence {
  Point point;
  String bssid;
  String wifiName;
  double radius;

  Geofence({this.point, this.bssid, this.wifiName, this.radius});

  Geofence.fromJson(Map<String, dynamic> json) {
    point = json['point'];
    bssid = json['bssid'];
    wifiName = json['wifiName'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['point'] = this.point;
    data['bssid'] = this.bssid;
    data['wifiName'] = this.wifiName;
    data['radius'] = this.radius;
    return data;
  }
}
