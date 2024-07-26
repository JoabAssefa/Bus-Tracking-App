import 'package:geolocator/geolocator.dart';

class UserLocation {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    print('Checking location services...');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    print('Checking location permissions...');

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print('Getting current position...');
    return await Geolocator.getCurrentPosition();
  }
}
