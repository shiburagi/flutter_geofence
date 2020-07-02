import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geofence.dart';

class GeofenceAddPage extends StatefulWidget {
  GeofenceAddPage({Key key}) : super(key: key);

  @override
  _GeofenceAddPageState createState() => _GeofenceAddPageState();
}

class _GeofenceAddPageState extends BlocState<GeofenceAddPage, GeofenceBloc> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Geofence"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => bloc.addGeofence(formKey),
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        label: "Latitude",
                        validator: bloc.latitudeValidator,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: buildTextField(
                        label: "Longitude",
                        validator: bloc.longitudeValidator,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                buildTextField(
                  label: "WIFI BSSID",
                  validator: bloc.bssidValidator,
                  keyboardType: TextInputType.text,
                ),
                buildTextField(
                  label: "WIFI NAME",
                  validator: bloc.wifiNameValidator,
                  keyboardType: TextInputType.text,
                ),
                buildTextField(
                  label: "Radius",
                  validator: bloc.radiusValidator,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {String label, Function validator, TextInputType keyboardType}) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
