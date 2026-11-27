import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab13_photo_diary/models/diary_entry.dart';
import 'package:lab13_photo_diary/models/geo_fix.dart';

void main() {
  test('coordinates and timestamp formatting', () {
    expect(
      GeoFix.formatCoordinates(43.238949, 76.889709),
      '43.2389° N, 76.8897° E',
    );
    expect(GeoFix.formatCoordinates(-33.5, -70.25), '33.5000° S, 70.2500° W');
    expect(
      formatDateTime(DateTime(2026, 11, 24, 14, 30, 5)),
      '2026-11-24 14:30:05',
    );
  });

  test('DiaryEntry JSON round trip keeps metadata', () {
    final entry = DiaryEntry(
      id: '1',
      imagePath: '/docs/diary_photos/1.jpg',
      caption: 'Campus Quad',
      createdAt: DateTime(2026, 11, 24, 14, 30, 15),
      latitude: 43.238949,
      longitude: 76.889709,
      altitude: 820.5,
      accuracy: 12.4,
    );
    final back = DiaryEntry.fromJson(
      jsonDecode(jsonEncode(entry.toJson())) as Map<String, dynamic>,
    );
    expect(back.caption, 'Campus Quad');
    expect(back.imagePath, entry.imagePath);
    expect(back.createdAt, entry.createdAt);
    expect(back.accuracy, 12.4);
    expect(back.coordinatesLabel, '43.2389° N, 76.8897° E');
  });

  test('entry without GPS is valid', () {
    final back = DiaryEntry.fromJson({'id': 2, 'caption': 'x', 'latitude': 1});
    expect(back.hasLocation, isFalse);
    expect(back.coordinatesLabel, 'No location');
  });
}
