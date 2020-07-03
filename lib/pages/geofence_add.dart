import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geofence.dart';
import 'package:setel_geofence/entities/geofence.dart';
import 'package:setel_geofence/views/loading.dart';

class GeofenceAddPage extends StatefulWidget {
  GeofenceAddPage({Key key}) : super(key: key);

  @override
  _GeofenceAddPageState createState() => _GeofenceAddPageState();
}

class _GeofenceAddPageState extends BlocState<GeofenceAddPage, GeofenceBloc> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiBSSIDController = TextEditingController();

  bool isEdit = false;
  @override
  void didChangeDependencies() {
    Geofence geofence = ModalRoute.of(context).settings.arguments;
    isEdit = geofence != null;
    if (isEdit) {
      latitudeController.text = geofence.latitude.toString();
      longitudeController.text = geofence.longitude.toString();
      radiusController.text = geofence.radius.toString();
      wifiNameController.text = geofence.wifiName.toString();
      wifiBSSIDController.text = geofence.bssid.toString();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Geofence"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        key: const Key("submit"),
        heroTag: "action_geofence",
        onPressed: () => bloc.addGeofence(formKey, isEdit),
        label: Text(isEdit ? "Save" : "Create"),
        icon: Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: buildForm(context),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 64, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text("Location",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold))),
                OutlineButton(
                  key: const Key("using current GPS"),
                  onPressed: () async {
                    LoadingView.of(context).showLoader();
                    Position position = await Geolocator().getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitudeController.text = "${position.latitude}";
                    longitudeController.text = "${position.longitude}";
                    LoadingView.of(context).hideLoader();
                  },
                  child: Text("Using Current GPS"),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    key: const Key("latitude"),
                    label: "Latitude",
                    controller: latitudeController,
                    validator: bloc.latitudeValidator,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: buildTextField(
                    key: const Key("longitude"),
                    label: "Longitude",
                    controller: longitudeController,
                    validator: bloc.longitudeValidator,
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            buildTextField(
              key: const Key("radius"),
              label: "Radius",
              controller: radiusController,
              validator: bloc.radiusValidator,
              keyboardType: TextInputType.number,
            ),
            Divider(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                    child: Text("WiFi",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold))),
                OutlineButton(
                  key: const Key("from connected WiFi"),
                  onPressed: () async {
                    LoadingView.of(context).showLoader();

                    String wifiBSSID = await (Connectivity().getWifiBSSID());
                    String wifiName = await (Connectivity().getWifiName());
                    wifiNameController.text = wifiName;
                    wifiBSSIDController.text = wifiBSSID;
                    LoadingView.of(context).hideLoader();
                  },
                  child: Text("From connected WiFi"),
                )
              ],
            ),
            buildTextField(
              key: const Key("WiFi name"),
              label: "Name",
              controller: wifiNameController,
              validator: bloc.wifiNameValidator,
              keyboardType: TextInputType.text,
            ),
            buildTextField(
              key: const Key("BSSID"),
              label: "BSSID",
              controller: wifiBSSIDController,
              validator: bloc.bssidValidator,
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    Key key,
    String label,
    Function validator,
    TextInputType keyboardType,
    TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        key: key,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
