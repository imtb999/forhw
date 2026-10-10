# Sneaker Store - LAB 5 and Capstone Milestone 1

A Flutter sneaker browsing app for students and young shoppers who want to compare styles, inspect a product and choose a size in a simple mobile interface.

## MVP

- Discovery screen with five product cards and working All / Lifestyle / Running filters.
- Tap a card to open its detail screen. Use the back arrow to return to the catalog.
- Detail screen with a photo, bookmark, rating, price, tags and selectable EU sizes.
- Add to Cart is enabled after selecting a size and updates a demo counter.
- Bundled images work offline; no API key or account is required.

## Run in VS Code

Open this folder, then run:

```bash
flutter pub get
flutter devices
```

Select a running iOS Simulator or connected Android/iOS phone in VS Code, open `lib/main.dart` and press F5. An iOS simulator requires macOS and Xcode. A physical iPhone also requires signing setup. Android requires the Android SDK and an emulator or device with USB debugging enabled.

For a browser preview:

```bash
flutter run -d chrome
```

## Requirements mapped to the code

| Requirement | Implementation |
| --- | --- |
| Discovery screen: Column, Row, Card | `catalog_screen.dart` and `product_card.dart` |
| Detail screen: Stack cover and bookmark | `product_cover.dart` |
| Title, rating, price, category badges | Row, Expanded and Wrap in `product_screen.dart` |
| Sticky full-width Add to Cart | bottomNavigationBar, SafeArea, Row and Expanded |
| StatefulWidget and setState | Catalog filter; detail bookmark, size and counter |
| Responsive layout | Scrollable content, Wrap, constrained width and natural card height |
| Two-screen navigation | Navigator.push and MaterialPageRoute |

## Structure

```text
lib/
  main.dart
  models/product.dart
  screens/catalog_screen.dart
  screens/product_screen.dart
  widgets/product_card.dart
  widgets/product_cover.dart
assets/images/
test/widget_test.dart
docs/DEFENSE.md
```

## Validation

```bash
flutter analyze
flutter test
flutter build ios --simulator --debug
```

The analyzer passes and all 17 tests pass. They cover catalog filters, navigation to both products and back, bookmark toggling, size selection, cart updates, and a sticky action bar. Layout tests cover widths of 280, 320, 390, 844 and 1440 pixels, portrait/landscape and 1x/2x text scaling.

The iOS debug build also succeeds. The app was installed and launched on the iPhone 17 Pro simulator (iOS 26.5). Manual checks confirmed category filtering, product navigation, bookmark toggling, size selection and a cart increment.

## Live defense

See [the 4-minute presentation and Q&A notes](docs/DEFENSE.md). Show the running app on a simulator or phone, then show the relevant source files in VS Code.

## Current boundaries and next milestones

This is an initial UI MVP. Product names, prices and reviews are sample data. A bookmark, size and counter belong to the currently opened detail screen and reset when that route is closed. There is no checkout or payment. Catalog filtering stays selected when returning from a product.

Next: introduce stable product IDs and a shared cart/favorites model, load products from a REST API, persist data in a database, then move state handling into BLoC. The model, screens and reusable widgets are already separated to support those steps.

## Photos

Photos are bundled locally from Unsplash:

- [Red sneaker](https://images.unsplash.com/photo-1542291026-7eec264c27ff)
- [Light sneaker](https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb)


## Feature: Your day. Your pair.

Tap **Find my pair for today** in the catalog. Choose Campus, Walk or Workout and move the budget slider. The recommendation updates immediately, explains the activity match and shows how much budget remains. Tap the suggested card to open its details.

Matching uses explicit demo activity tags, only considers affordable products, and ranks by rating (lower price breaks ties). If nothing fits, it shows an honest no-match message. No API, AI model or internet is required. The five demo products reuse illustrative photos; their tags, prices and ratings are sample data, not verified product performance claims.

Defense example: choose Workout at 60000 tenge to get Training Start, increase to 65000 to get Cloud Runner, then reduce to 20000 to demonstrate the no-match state.

Implementation: `lib/screens/day_match_screen.dart` uses StatefulWidget/setState; `lib/services/day_match.dart` contains the matching rules. LAB 6 remains a separate unchanged project.
