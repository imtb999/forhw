import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab13_photo_diary/data/diary_storage.dart';
import 'package:lab13_photo_diary/main.dart';
import 'package:lab13_photo_diary/models/geo_fix.dart';
import 'package:lab13_photo_diary/services/location_service.dart';
import 'package:lab13_photo_diary/services/photo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakePhotoService implements PhotoService {
  ImageSource? lastSource;
  PhotoException? error;

  @override
  Future<String?> pick(ImageSource source) async {
    lastSource = source;
    if (error != null) throw error!;
    return '/tmp/picked.jpg';
  }

  @override
  Future<String> persist(String tempPath, String id) async =>
      '/docs/diary_photos/$id.jpg';

  @override
  Future<void> delete(String path) async {}

  @override
  Future<bool> openSettings() async => true;
}

class FakeLocationService implements LocationService {
  Completer<GeoFix>? pending;
  LocationException? error;
  int settingsOpened = 0;

  @override
  Future<GeoFix> getCurrentLocation() {
    if (error != null) return Future.error(error!);
    pending = Completer<GeoFix>();
    return pending!.future;
  }

  void complete() => pending!.complete(
    GeoFix(
      latitude: 43.238949,
      longitude: 76.889709,
      altitude: 820,
      accuracy: 12.4,
      timestamp: DateTime(2026, 11, 24, 14, 30, 15),
    ),
  );

  @override
  Future<bool> openLocationSettings() async {
    settingsOpened++;
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened++;
    return true;
  }
}

void main() {
  late FakePhotoService photos;
  late FakeLocationService location;

  Future<void> launch(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      PhotoDiaryApp(
        storage: await DiaryStorage.open(),
        photoService: photos,
        locationService: location,
      ),
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    photos = FakePhotoService();
    location = FakeLocationService();
  });

  testWidgets('gallery photo -> auto GPS with spinner -> save to feed', (
    tester,
  ) async {
    await launch(tester);
    expect(find.byKey(const Key('photo_placeholder')), findsOneWidget);

    await tester.tap(find.byKey(const Key('pick_gallery')));
    await tester.pump();
    expect(photos.lastSource, ImageSource.gallery);
    // GPS is requested automatically and a spinner is shown.
    expect(find.text('Acquiring GPS lock...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    location.complete();
    await tester.pumpAndSettle();
    expect(find.text('43.238949'), findsOneWidget);
    expect(find.text('76.889709'), findsOneWidget);
    expect(find.text('± 12.4 m'), findsOneWidget);
    expect(find.text('2026-11-24 14:30:15'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('caption_field')),
      'Campus Quad',
    );
    await tester.ensureVisible(find.byKey(const Key('save_entry')));
    await tester.tap(find.byKey(const Key('save_entry')));
    await tester.pumpAndSettle();

    expect(find.text('Diary Entries (1)'), findsOneWidget);
    expect(find.text('Campus Quad'), findsOneWidget);
    expect(find.textContaining('43.2389° N, 76.8897° E'), findsOneWidget);

    // Persisted for the next launch.
    final saved = (await DiaryStorage.open()).load();
    expect(saved.single.caption, 'Campus Quad');
    expect(saved.single.latitude, 43.238949);
  });

  testWidgets('disabled GPS asks to open location settings', (tester) async {
    location.error = const LocationException(LocationFailure.serviceDisabled);
    await launch(tester);
    await tester.tap(find.byKey(const Key('fetch_gps')));
    await tester.pumpAndSettle();
    expect(find.text('Location is off'), findsOneWidget);
    await tester.tap(find.byKey(const Key('open_settings')));
    await tester.pumpAndSettle();
    expect(location.settingsOpened, 1);
  });

  testWidgets('"Don\'t ask again" shows the app settings dialog', (
    tester,
  ) async {
    location.error = const LocationException(LocationFailure.deniedForever);
    await launch(tester);
    await tester.tap(find.byKey(const Key('fetch_gps')));
    await tester.pumpAndSettle();
    expect(find.text('Location permission blocked'), findsOneWidget);
  });

  testWidgets('no camera and missing photo are handled', (tester) async {
    photos.error = const PhotoException(PhotoFailure.unavailable);
    await launch(tester);
    await tester.tap(find.byKey(const Key('take_photo')));
    await tester.pump();
    expect(
      find.text('Camera is not available on this device.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('save_entry')));
    await tester.tap(find.byKey(const Key('save_entry')));
    await tester.pump();
    expect(find.text('Take or pick a photo first.'), findsOneWidget);
  });
}
