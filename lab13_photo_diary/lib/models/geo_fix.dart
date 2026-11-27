/// One GPS reading taken from the device (a copy of the useful
/// fields of geolocator's Position).
class GeoFix {
  const GeoFix({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double altitude;

  /// Radius of uncertainty in meters.
  final double accuracy;
  final DateTime timestamp;

  /// "43.2389° N, 76.8897° E"
  String get shortLabel => formatCoordinates(latitude, longitude);

  static String formatCoordinates(double lat, double lng) {
    final ns = lat >= 0 ? 'N' : 'S';
    final ew = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(4)}° $ns, '
        '${lng.abs().toStringAsFixed(4)}° $ew';
  }
}

/// 2026-11-24 14:30:15
String formatDateTime(DateTime d) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)} '
      '${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
}
