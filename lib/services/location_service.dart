import 'dart:async';

import 'package:location/location.dart';
import 'package:shareloc/models/user_location.dart';

class LocationService {
  UserLocation _currentLocation;
  Location location = Location();

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
                latitude: locationData.latitude,
                longitude: locationData.longitude));
          }
        });
      }
    });
  }
  Future<UserLocation> getLocation() async {
    try {
      var currentLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);
    } catch (e) {
      print('gagal mendapatkan lokasi: $e');
    }
    return _currentLocation;
  }
}
