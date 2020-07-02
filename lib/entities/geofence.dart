class Geofence {
  double latitude;
  double longitude;
  String bssid;
  String wifiName;
  double radius;

  Geofence(
      {this.latitude, this.longitude, this.bssid, this.wifiName, this.radius});

  Geofence.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    bssid = json['bssid'];
    wifiName = json['wifiName'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['bssid'] = this.bssid;
    data['wifiName'] = this.wifiName;
    data['radius'] = this.radius;
    return data;
  }
}
