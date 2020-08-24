import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final Set<Marker> _markers = {};
  Position _currentPosition;
  String _currentAddressName;

  final Geolocator position = Geolocator()..forceAndroidLocationManager;

  void _getLocation() async {
    position
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _markers.clear();
        _currentPosition = position;
        final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        );
        _markers.add(marker);
      });
      _getAddressName();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressName() async {
    try {
      List<Placemark> p = await position.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddressName =
            "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.subAdministrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your location'),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: FlatButton(
          child: Text('Check in'),
          onPressed: () {
            if (_currentPosition != null) {
              print(
                  'latitude: ${_currentPosition.latitude}\nlongitude: ${_currentPosition.longitude}');
              Get.dialog(
                AlertDialog(
                  title: Text('Your address:'),
                  content: Text(
                      'Coordinate: \nlat: ${_currentPosition.latitude}, long: ${_currentPosition.longitude}\nAddress: \n$_currentAddressName'),
                  actions: [
                    FlatButton(
                      onPressed: () => Get.back(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition.latitude, _currentPosition.longitude),
                zoom: 18.0,
              ),
            ),
    );
  }
}
