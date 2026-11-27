import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum PhotoFailure { denied, permanentlyDenied, unavailable }

class PhotoException implements Exception {
  const PhotoException(this.reason);
  final PhotoFailure reason;

  @override
  String toString() => 'PhotoException($reason)';
}

class PhotoService {
  PhotoService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Opens the camera or the gallery. Returns the temp file path of the
  /// compressed photo, or null when the user cancelled.
  Future<String?> pick(ImageSource source) async {
    if (source == ImageSource.camera && Platform.isAndroid) {
      await _ensureCameraPermission();
    }
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 80, // JPEG quality 0..100
        maxWidth: 1080, // downscale big camera photos
      );
      return file?.path;
    } on PlatformException catch (e) {
      // iOS: camera_access_denied / photo_access_denied
      if (e.code.contains('access_denied')) {
        throw const PhotoException(PhotoFailure.permanentlyDenied);
      }
      throw const PhotoException(PhotoFailure.unavailable);
    } catch (_) {
      // e.g. no camera on the simulator / desktop.
      throw const PhotoException(PhotoFailure.unavailable);
    }
  }

  Future<void> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      throw const PhotoException(PhotoFailure.permanentlyDenied);
    }
    if (!status.isGranted) status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      throw const PhotoException(PhotoFailure.permanentlyDenied);
    }
    if (!status.isGranted) throw const PhotoException(PhotoFailure.denied);
  }

  /// image_picker returns a file in a temp/cache folder that the OS may
  /// clean. Copy it into the app documents folder so the diary survives.
  Future<String> persist(String tempPath, String id) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/diary_photos');
    await dir.create(recursive: true);
    final saved = await File(tempPath).copy('${dir.path}/$id.jpg');
    return saved.path;
  }

  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  Future<bool> openSettings() => openAppSettings();
}
