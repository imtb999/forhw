import 'package:flutter/material.dart';

import 'data/vault_storage.dart';
import 'screens/vault_screen.dart';

Future<void> main() async {
  // Required before using plugins (SharedPreferences) ahead of runApp().
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await VaultStorage.open();
  // The theme is read before the first frame, so a dark-mode user
  // never sees a white flash on cold start.
  runApp(VaultApp(storage: storage, initialDarkMode: storage.loadDarkMode()));
}

class VaultApp extends StatefulWidget {
  const VaultApp({
    super.key,
    required this.storage,
    required this.initialDarkMode,
  });

  final VaultStorage storage;
  final bool initialDarkMode;

  @override
  State<VaultApp> createState() => _VaultAppState();
}

class _VaultAppState extends State<VaultApp> {
  late bool _isDark = widget.initialDarkMode;

  void _setDarkMode(bool value) {
    setState(() => _isDark = value);
    widget.storage.saveDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE53935);
    return MaterialApp(
      title: 'Offline Vault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: VaultScreen(
        storage: widget.storage,
        isDark: _isDark,
        onDarkModeChanged: _setDarkMode,
      ),
    );
  }
}
