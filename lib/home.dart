import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:locer/show_maps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Geolocator position = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddressName;

  _getCurrentLocation() {
    position
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get location'),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: FlatButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Get.to(ShowMap());
          },
          child: Text('Show on map'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                _getCurrentLocation();
              },
              child: Text('Get location'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('Current loc: '),
            _currentPosition != null? Column(
              children: [
                Text(
                        "LAT: ${_currentPosition.latitude}, LONG: ${_currentPosition.longitude}"),
                SizedBox(height: 5.0),
                Text(_currentAddressName ?? ''),
              ],
            ) : Container(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
