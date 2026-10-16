import 'package:flutter/material.dart';

import '../state/favorites.dart';
import 'favorites_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.themeMode});

  final ValueNotifier<ThemeMode> themeMode;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final favoritesCount = FavoritesScope.of(context).items.length;

    return Scaffold(
      // IndexedStack keeps every tab alive, so scroll position and switches
      // are not lost when the user changes tabs.
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const FeedScreen(),
          FavoritesScreen(onBrowse: () => setState(() => _currentIndex = 0)),
          ProfileScreen(themeMode: widget.themeMode),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed_outlined),
            activeIcon: Icon(Icons.dynamic_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: favoritesCount > 0,
              label: Text('$favoritesCount'),
              child: const Icon(Icons.favorite_border),
            ),
            activeIcon: Badge(
              isLabelVisible: favoritesCount > 0,
              label: Text('$favoritesCount'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
