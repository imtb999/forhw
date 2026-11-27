import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/geo_fix.dart';

enum LocationFailure {
  serviceDisabled,
  denied,
  deniedForever,
  timeout,
  unknown,
}

class LocationException implements Exception {
  const LocationException(this.reason);
  final LocationFailure reason;

  @override
  String toString() => 'LocationException($reason)';
}

/// Wraps geolocator: service check -> permission check/request -> GPS fix.
class LocationService {
  Future<GeoFix> getCurrentLocation() async {
    // 1. Is GPS / Location Services switched on at all?
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceDisabled);
    }

    // 2. Runtime permission.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(LocationFailure.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      // Android "Don't ask again" / iOS "Don't Allow": the system will not
      // show the dialog again, only the Settings app can change it.
      throw const LocationException(LocationFailure.deniedForever);
    }

    // 3. Ask the hardware for a fresh high-accuracy fix.
    try {
      final p = await Geolocator.getCurrentPosition(
        // Same as the old `desiredAccuracy: LocationAccuracy.high`
        // (that parameter is deprecated in geolocator 14).
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return GeoFix(
        latitude: p.latitude,
        longitude: p.longitude,
        altitude: p.altitude,
        accuracy: p.accuracy,
        timestamp: p.timestamp.toLocal(),
      );
    } on TimeoutException {
      throw const LocationException(LocationFailure.timeout);
    } on LocationServiceDisabledException {
      throw const LocationException(LocationFailure.serviceDisabled);
    } on PermissionDeniedException {
      throw const LocationException(LocationFailure.denied);
    } catch (_) {
      throw const LocationException(LocationFailure.unknown);
    }
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
