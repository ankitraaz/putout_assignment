import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return _fetchAutomaticLocation();
  }

  Future<String> _fetchAutomaticLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'MUMBAI'; // Default to MUMBAI instead of error message for cleaner UI
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'MUMBAI';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'MUMBAI';
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subLocality ?? place.name ?? '';
        
        if (city.isNotEmpty) {
          return city.toUpperCase();
        }
      }
    } catch (e) {
      return 'MUMBAI';
    }

    return 'MUMBAI';
  }

  Future<void> updateLocation(String newLocation) async {
    state = AsyncValue.data(newLocation.toUpperCase());
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAutomaticLocation());
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, String>(LocationNotifier.new);
