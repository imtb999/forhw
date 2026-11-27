import 'package:flutter/material.dart';

import 'data/diary_storage.dart';
import 'screens/diary_screen.dart';
import 'services/location_service.dart';
import 'services/photo_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await DiaryStorage.open();
  runApp(PhotoDiaryApp(storage: storage));
}

class PhotoDiaryApp extends StatelessWidget {
  const PhotoDiaryApp({
    super.key,
    required this.storage,
    this.photoService,
    this.locationService,
  });

  final DiaryStorage storage;
  final PhotoService? photoService;
  final LocationService? locationService;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE53935);
    return MaterialApp(
      title: 'Narxoz Photo Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: DiaryScreen(
        storage: storage,
        photoService: photoService ?? PhotoService(),
        locationService: locationService ?? LocationService(),
      ),
    );
  }
}
