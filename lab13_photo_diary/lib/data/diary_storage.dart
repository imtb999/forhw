import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/diary_entry.dart';

/// Offline metadata store (same JSON approach as LAB 11).
/// Photos are files on disk, only their paths are stored here.
class DiaryStorage {
  DiaryStorage(this._prefs);

  static const entriesKey = 'photo_diary_entries';

  final SharedPreferences _prefs;

  static Future<DiaryStorage> open() async =>
      DiaryStorage(await SharedPreferences.getInstance());

  List<DiaryEntry> load() {
    final raw = _prefs.getString(entriesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<DiaryEntry> entries) => _prefs.setString(
    entriesKey,
    jsonEncode(entries.map((e) => e.toJson()).toList()),
  );
}
