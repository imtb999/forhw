# LAB 13 - Narxoz Geotagged Photo Diary

Camera / gallery photos with GPS coordinates, saved into an offline diary. Same red Material 3 theme as the previous labs; diary metadata is stored as JSON in SharedPreferences (the LAB 11 approach).

## Run

```sh
flutter pub get
flutter run
```

Camera needs a real phone (the iOS Simulator has no camera). Gallery and GPS work on the simulator/emulator: iOS Simulator - Features > Location > Custom Location (43.238949, 76.889709); Android Emulator - Extended controls > Location. The macOS build supports Pick Gallery and GPS for a desktop demo.

## Packages

`image_picker`, `geolocator`, `permission_handler`, `path_provider`, `shared_preferences`.

## Task 1 - Permissions

- `android/app/src/main/AndroidManifest.xml`: `CAMERA`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `READ_MEDIA_IMAGES` (+ `READ_EXTERNAL_STORAGE` up to API 32 for older phones).
- `ios/Runner/Info.plist`: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSLocationWhenInUseUsageDescription`.
- `macos/Runner/*.entitlements`: location and user-selected files for the desktop build.
- Runtime guard (`lib/services/location_service.dart`): if `Geolocator.isLocationServiceEnabled()` is false, a dialog offers **Open Settings** -> `Geolocator.openLocationSettings()`.
- Camera on Android is checked with `permission_handler` (`Permission.camera.status / request()`); `isPermanentlyDenied` opens a dialog with `openAppSettings()`.

## Task 2 - Camera & Gallery

- Two buttons: **Take Photo** (`ImageSource.camera`) and **Pick Gallery** (`ImageSource.gallery`).
- `pickImage(imageQuality: 80, maxWidth: 1080)` - compressed JPEG, max 1080 px wide.
- Preview: 4:3 box with `ClipRRect` + `BorderRadius.circular(20)` and `Image.file(File(path))`; a camera icon placeholder when there is no photo (`lib/widgets/photo_preview.dart`).
- Cancel returns `null` and changes nothing; "no camera" and "access denied" show a message instead of crashing.

## Task 3 - GPS

- `Geolocator.checkPermission()` -> `requestPermission()` if denied; `deniedForever` -> dialog with `openAppSettings()`; `denied` -> SnackBar, the app keeps working.
- `Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high, timeLimit: 20 s))`. This is the geolocator 14 form of `desiredAccuracy: LocationAccuracy.high` (that parameter is deprecated).
- Runs on **Fetch Current GPS Location** and automatically after a photo is taken. While waiting, the button and the info card show a `CircularProgressIndicator`.
- Shows Latitude, Longitude (6 decimals), Altitude, Accuracy `± 12.4 m` and the fix timestamp `2026-11-24 14:30:15`.

## Task 4 - Diary feed

- Caption field + **SAVE ENTRY TO DIARY**. The photo is copied from the picker's temp folder into `Documents/diary_photos/` (`path_provider`), so it survives cache cleaning and app restarts.
- Entry = photo path, caption, timestamp, latitude, longitude, altitude, accuracy, saved with `toJson()` / `jsonEncode`.
- Scrollable feed: thumbnail (`Image.file`), caption, `43.2389° N, 76.8897° E ± 12 m`, date. Swipe left to delete (also deletes the file).

## Defense

**Why is `NSCameraUsageDescription` mandatory on iOS?** iOS protects the camera, photos and location with privacy permissions. Before showing the system "Allow access?" alert, iOS reads the usage description string from Info.plist and shows it to the user. If the key is missing, iOS immediately terminates the app the first time it touches the camera (privacy-sensitive data crash), and App Store review rejects such apps. The same applies to `NSPhotoLibraryUsageDescription` and `NSLocationWhenInUseUsageDescription`.

**What happens when a user selects "Don't ask again" on Android?** Since Android 11, denying twice has the same effect. The permission becomes permanently denied: `requestPermission()` returns immediately without showing any dialog (`LocationPermission.deniedForever` / `PermissionStatus.permanentlyDenied`). The app cannot ask again; it can only explain why it needs the permission and send the user to the app settings (`openAppSettings()`), where they enable it manually. The app must keep working without the feature instead of crashing.

**Other points:** a manifest permission is only a declaration; dangerous permissions (camera, location) must also be requested at runtime. `imageQuality`/`maxWidth` cut a 4-12 MB camera photo down to a few hundred KB. `accuracy` is the radius in meters within which the real position lies with ~68% probability.

## Verification

```sh
flutter analyze
flutter test
```

Tests use fake photo/location services: gallery pick -> automatic GPS with spinner -> coordinates -> save -> feed and storage; disabled GPS dialog; "Don't ask again" dialog; no camera; save without a photo.
