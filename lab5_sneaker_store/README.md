# Sneaker Store - LAB 5

A responsive Flutter product preview, built as the starting point for an e-commerce capstone project.

## Run

```bash
flutter pub get
flutter run -d chrome
```

For a phone or simulator, select a device in VS Code and press F5.

## LAB 5 requirements

- `Stack`: local cover photo with an overlaid bookmark button.
- `Row` and `Expanded`: wrapping product title and full-width action button.
- `Wrap`: price/rating, category badges and size options adapt to available width.
- `bottomNavigationBar` and `SafeArea`: sticky Add to Cart bar.
- `SingleChildScrollView`: content remains accessible on short screens.
- `ConstrainedBox`: readable content width on larger screens.
- `StatefulWidget` and `setState`: bookmark, size selection and cart counter.

## Folder structure

```text
lib/
  main.dart                   App entry point and theme
  models/product.dart         Product model and sample data
  screens/product_screen.dart Product screen and local state
  widgets/product_cover.dart  Reusable cover and bookmark overlay
assets/images/sneaker.jpg      Bundled photo, works offline
```

## Demo

1. Tap the bookmark twice to toggle it.
2. Select an EU size.
3. Tap Add to Cart and check the counter and confirmation.
4. Resize the window and scroll: the action button remains at the bottom.

## Validation

```bash
flutter analyze
flutter test
```

Widget tests cover 280, 320, 390, 844 and 1440 px widths, landscape layout, 1x/2x text scaling, the sticky bar and interactions.

## Next milestones

This submission covers LAB 5: one product detail screen. For the capstone, add a discovery screen, a shared cart and navigation, then REST data, persistence and BLoC. The product model is separate from the UI to make this easier.

Current state is kept in memory and resets on restart. The cart is a demonstration counter, not a checkout. Product name, price and rating are sample data, not a verified retail listing.

Photo: [Unsplash source image](https://images.unsplash.com/photo-1542291026-7eec264c27ff). Bundled locally for the classroom demo.
