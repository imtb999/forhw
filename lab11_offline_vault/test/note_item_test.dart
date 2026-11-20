import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab11_offline_vault/data/vault_storage.dart';
import 'package:lab11_offline_vault/models/note_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('NoteItem toJson / fromJson round trip', () {
    const note = NoteItem(
      id: '1',
      title: 'Buy milk',
      dateText: '20 Nov 2026, 10:00',
      isCompleted: true,
    );
    final restored = NoteItem.fromJson(
      jsonDecode(jsonEncode(note.toJson())) as Map<String, dynamic>,
    );
    expect(restored.id, '1');
    expect(restored.title, 'Buy milk');
    expect(restored.dateText, '20 Nov 2026, 10:00');
    expect(restored.isCompleted, isTrue);
  });

  test('defaults and corrupted JSON fallback', () async {
    SharedPreferences.setMockInitialValues({VaultStorage.notesKey: 'not json'});
    final storage = await VaultStorage.open();
    expect(storage.loadDarkMode(), isFalse);
    expect(storage.loadDisplayName(), 'Guest User');
    expect(storage.loadNotes(), isEmpty);
  });
}
