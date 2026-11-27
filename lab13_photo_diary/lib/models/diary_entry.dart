import 'geo_fix.dart';

/// One saved diary record: photo file + caption + where and when.
class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.imagePath,
    required this.caption,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
  });

  final String id;
  final String imagePath;
  final String caption;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? accuracy;

  bool get hasLocation => latitude != null && longitude != null;

  String get coordinatesLabel => hasLocation
      ? GeoFix.formatCoordinates(latitude!, longitude!)
      : 'No location';

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'caption': caption,
    'createdAt': createdAt.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'altitude': altitude,
    'accuracy': accuracy,
  };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    double? toDouble(Object? v) => v is num ? v.toDouble() : null;
    return DiaryEntry(
      id: json['id']?.toString() ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      altitude: toDouble(json['altitude']),
      accuracy: toDouble(json['accuracy']),
    );
  }
}
