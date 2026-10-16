import 'package:flutter/material.dart';

import '../state/favorites.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.themeMode});

  final ValueNotifier<ThemeMode> themeMode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  String _size = 'EU 42';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final savedCount = FavoritesScope.of(context).items.length;
    final isDark = widget.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                'TB',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Temirlan Baidash',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          Text(
            'Student · $savedCount saved items',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  subtitle: const Text('New drops and price changes'),
                  value: _notifications,
                  onChanged: (value) => setState(() => _notifications = value),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: isDark,
                  onChanged: (value) => setState(() {
                    widget.themeMode.value = value
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  }),
                ),
                ListTile(
                  leading: const Icon(Icons.straighten),
                  title: const Text('Preferred size'),
                  trailing: DropdownButton<String>(
                    value: _size,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final size in ['EU 40', 'EU 41', 'EU 42', 'EU 43'])
                        DropdownMenuItem(value: size, child: Text(size)),
                    ],
                    onChanged: (value) => setState(() => _size = value!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
