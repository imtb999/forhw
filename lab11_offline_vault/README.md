# LAB 11 - Offline-First Notes & Settings Vault

Continuation of the previous labs (same red Material 3 seed). The whole user state is stored locally with `shared_preferences: ^2.2.2`.

## Run

```sh
flutter pub get
flutter run
```

## Features

- **Theme pre-load:** `main()` calls `WidgetsFlutterBinding.ensureInitialized()`, opens `SharedPreferences` and reads `app_theme_dark_mode` (`?? false`) before `runApp()`. The first frame is already in the correct theme, so there is no white flash. The Switch in the AppBar saves the value with `setBool`.
- **Username:** TextField + Save button write `user_display_name` with `setString`. On launch `getString(...) ?? 'Guest User'` fills the header and the field.
- **Notes:** `NoteItem` (`id`, `title`, `dateText`, `isCompleted`) with `toJson()` and `factory NoteItem.fromJson`. Add (prepended), toggle (checkbox) and delete all rewrite the list as one JSON string (`jsonEncode`) under `notes_vault_items`. On launch it is restored with `jsonDecode` + `fromJson`; corrupted data falls back to an empty list.

Code: `lib/main.dart`, `lib/data/vault_storage.dart`, `lib/models/note_item.dart`, `lib/screens/vault_screen.dart`.

## Cold Restart Test

1. Enter a name and press Save, add 2 notes, tick one, turn on dark mode.
2. Force-kill the app: iOS Simulator - swipe it away in the app switcher (Cmd+Shift+H twice); Android - Recents and swipe away; macOS - Cmd+Q.
3. Open the app again from the home screen (not hot restart). Dark theme, name and notes with their checkbox state are restored immediately.

## Defense: SharedPreferences vs Keychain/KeyStore

SharedPreferences stores plain unencrypted data (iOS `NSUserDefaults` plist, Android XML file in the app sandbox). It is fine for settings, flags and small cached data, but not for secrets: on a rooted/jailbroken device or from a backup the file can be read. Passwords, tokens and keys belong in the iOS Keychain / Android KeyStore (for example through `flutter_secure_storage`), which encrypt data with hardware-backed keys. SharedPreferences is also not a database: the whole value is rewritten on every change, so large or relational data should go to SQLite/Hive/Isar.

## Verification

```sh
flutter analyze
flutter test
```

`test/cold_restart_test.dart` simulates the restart: it fills the app, throws the widget tree away, creates a new app from the same storage and checks theme, name, note order and completion state.
