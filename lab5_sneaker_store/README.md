# Sneaker Store - LAB 5, LAB 6 and Capstone Milestone 1

A Flutter sneaker browsing app for students and young shoppers who want to compare styles, inspect a product and choose a size in a simple mobile interface.

## LAB 6 - Registration and Profile Setup

The app starts with registration, then opens the LAB 5 catalog after successful validation.

- `Form` and `GlobalKey<FormState>` validate every field on Create Account.
- Four `TextEditingController`s read name, email, password and confirmation; all are disposed.
- Full name must contain non-whitespace text. Email must have a local part, @, domain and dot, with no internal whitespace.
- Password requires at least 6 characters. Both password fields use `obscureText: true`; confirmation matches exactly, without trimming.
- `AutovalidateMode.onUserInteraction` supplies live errors; after a submit attempt validation stays active. Editing the original password rechecks confirmation.
- The Terms and Conditions checkbox is a `FormField<bool>` and blocks submission until selected.
- Role dropdown offers Student, Teacher and Developer.
- Success logs name, email, role and terms acceptance to the debug console, with the password replaced by `[hidden]`. A success SnackBar appears and the catalog greets the user.
- This is an in-memory classroom demo, not server authentication. Restarting the app returns to registration. Passwords are not stored in the profile model.

### LAB 6 demo

1. Press Create Account on the empty form to see errors under the fields.
2. Enter a name, an invalid email and a short password; correct them and watch errors clear.
3. Enter a different confirmation, then match it. Edit the first password again to show cross-field validation.
4. Select a role. Submit without accepting terms: registration stays blocked.
5. Accept terms and submit valid data. Show the success message, name and role in the catalog, and masked form data in the VS Code debug console.

## MVP

- Discovery screen with two product cards and working All / Lifestyle / Running filters.
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
  models/user_profile.dart
  models/product.dart
  screens/registration_screen.dart
  screens/catalog_screen.dart
  screens/product_screen.dart
  widgets/product_card.dart
  widgets/product_cover.dart
assets/images/
test/widget_test.dart
test/registration_test.dart
docs/DEFENSE.md
```

## Validation

All 23 widget tests pass (12 for LAB 5 and 11 for LAB 6). `flutter analyze` reports no issues.

```bash
flutter analyze
flutter test
flutter build ios --simulator --debug
```

The LAB 5 tests cover the original catalog and detail screens; LAB 6 tests additionally cover empty submission, live field errors, password dependencies, role selection, terms gating, masked logging and registration-to-catalog navigation. Layout checks include the registration form with validation errors, 1x/2x text and simulated keyboard insets.

The original 12 widget tests cover LAB 5 behavior. They cover catalog filters, navigation to both products and back, bookmark toggling, size selection, cart updates, and a sticky action bar. Layout tests cover widths of 280, 320, 390, 844 and 1440 pixels, portrait/landscape and 1x/2x text scaling.

The iOS debug build also succeeds. The app was installed and launched on the iPhone 17 Pro simulator (iOS 26.5). Manual checks confirmed category filtering, product navigation, bookmark toggling, size selection and a cart increment.

## Live defense

See [the 4-minute presentation and Q&A notes](docs/DEFENSE.md). Show the running app on a simulator or phone, then show the relevant source files in VS Code.

## Current boundaries and next milestones

This is an initial UI MVP. Product names, prices and reviews are sample data. The profile exists in memory only. A bookmark, size and counter belong to the currently opened detail screen and reset when that route is closed. There is no checkout or payment. Catalog filtering stays selected when returning from a product.

Next: introduce stable product IDs and a shared cart/favorites model, load products from a REST API, persist data in a database, then move state handling into BLoC. The model, screens and reusable widgets are already separated to support those steps.

## Photos

Photos are bundled locally from Unsplash:

- [Red sneaker](https://images.unsplash.com/photo-1542291026-7eec264c27ff)
- [Light sneaker](https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb)
