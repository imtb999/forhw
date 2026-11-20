import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

/// Thin wrapper around SharedPreferences. All keys live in one place.
class VaultStorage {
  VaultStorage(this._prefs);

  static const themeKey = 'app_theme_dark_mode';
  static const nameKey = 'user_display_name';
  static const notesKey = 'notes_vault_items';
  static const defaultName = 'Guest User';

  final SharedPreferences _prefs;

  static Future<VaultStorage> open() async =>
      VaultStorage(await SharedPreferences.getInstance());

  bool loadDarkMode() => _prefs.getBool(themeKey) ?? false;

  Future<void> saveDarkMode(bool value) => _prefs.setBool(themeKey, value);

  String loadDisplayName() => _prefs.getString(nameKey) ?? defaultName;

  Future<void> saveDisplayName(String value) =>
      _prefs.setString(nameKey, value);

  List<NoteItem> loadNotes() {
    final raw = _prefs.getString(notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => NoteItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data must not crash the app on launch.
      return [];
    }
  }

  Future<void> saveNotes(List<NoteItem> notes) {
    final json = jsonEncode(notes.map((n) => n.toJson()).toList());
    return _prefs.setString(notesKey, json);
  }
}
