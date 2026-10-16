# LAB 7 - Multi-Screen App with Navigation & Tabs

Sneaker Store continued: a root screen with a `BottomNavigationBar`, three tabs and a parameterized detail screen.

## What is implemented

**Root screen with BottomNavigationBar** (`lib/screens/root_screen.dart`)
- **Feed** - 4 sneakers with image, title, category, date and price.
- **Favorites** - items saved with the heart button. The tab icon shows a badge with the count.
- **Profile** - avatar, notifications switch, working dark mode switch and preferred size.
- Tabs live in an `IndexedStack`, so switching tabs does not reset their state.

**Detail screen with arguments** (`lib/screens/detail_screen.dart`)
- Tapping a Feed item calls `Navigator.pushNamed(context, '/detail', arguments: product)`.
- The complete `Product` object (title, description, image, price, category, date) is passed; `onGenerateRoute` in `main.dart` reads `settings.arguments` and builds `DetailScreen(product: product)`.
- Hero animation for the picture between the list and the detail screen.

**Back navigation**
- AppBar back icon and the in-body **Back to list** button both call `Navigator.pop(context)`.
- Favorites are stored in `FavoritesController` above the `Navigator`, so after going back the Feed, Favorites and Profile keep their state (no restart).

## Project structure

```
lib/
  main.dart                  MaterialApp, theme, onGenerateRoute for /detail
  models/product.dart        Product model + demo data
  state/favorites.dart       FavoritesController (ChangeNotifier) + InheritedNotifier
  screens/root_screen.dart   BottomNavigationBar + IndexedStack
  screens/feed_screen.dart   Tab 1
  screens/favorites_screen.dart  Tab 2
  screens/profile_screen.dart    Tab 3
  screens/detail_screen.dart     Detail screen
  widgets/product_tile.dart  List item that pushes the detail screen
test/navigation_test.dart    push / pop / favorites widget tests
```

## Run in VS Code

1. Open the `lab7_navigation` folder.
2. `flutter pub get`
3. Choose a device in the bottom-right corner (iOS Simulator, Android emulator or Chrome) and press **F5**.

Tests: `flutter test`

## Demo for the screen recording

1. Feed: scroll the list, tap **Ocean Flyknit** - detail opens with all the data.
2. Tap **Add to favorites**, then **Back to list** (in-body button).
3. Open **Cloud Runner**, save it with the heart in the AppBar, go back with the AppBar arrow.
4. Open the **Favorites** tab - both items are there, the badge shows 2.
5. Open **Profile**, turn on dark mode, return to Feed - everything is still saved.

## Screen recording

[docs/lab7_demo.mp4](docs/lab7_demo.mp4) - iPhone 17 Pro simulator, 35 s: Feed -> detail -> Add to favorites -> Back to list, Cloud Runner saved via AppBar heart -> AppBar back, Favorites tab (badge 2), Profile dark mode, Feed -> detail -> back.
