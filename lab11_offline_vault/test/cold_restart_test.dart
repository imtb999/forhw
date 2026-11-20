import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11_offline_vault/data/vault_storage.dart';
import 'package:lab11_offline_vault/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> launch(WidgetTester tester) async {
  final storage = await VaultStorage.open();
  await tester.pumpWidget(
    VaultApp(
      key: UniqueKey(),
      storage: storage,
      initialDarkMode: storage.loadDarkMode(),
    ),
  );
}

void main() {
  testWidgets('settings and notes survive a simulated cold restart', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await launch(tester);
    expect(find.text('Hello, Guest User'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('name_field')), 'Temirlan');
    await tester.tap(find.byKey(const Key('save_name_button')));
    await tester.pump();

    for (final t in ['First note', 'Second note']) {
      await tester.enterText(find.byKey(const Key('note_field')), t);
      await tester.tap(find.byKey(const Key('add_note_button')));
      await tester.pump();
    }
    await tester.tap(find.byType(Checkbox).last); // toggle "First note"
    await tester.tap(find.byKey(const Key('dark_mode_switch')));
    await tester.pumpAndSettle();

    // "Kill" the app and start it again from disk.
    await tester.pumpWidget(const SizedBox());
    await launch(tester);
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(find.text('Hello, Temirlan'), findsOneWidget);
    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title as Text).data)
        .toList();
    expect(titles, ['Second note', 'First note']); // prepend order kept
    final boxes = tester.widgetList<Checkbox>(find.byType(Checkbox)).toList();
    expect(boxes.map((b) => b.value), [false, true]);

    await tester.tap(find.byTooltip('Delete note').first);
    await tester.pump();
    final saved = (await VaultStorage.open()).loadNotes();
    expect(saved.map((n) => n.title), ['First note']);
  });
}
