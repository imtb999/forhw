# LW4 - Interactive Profile Card

A single-screen Flutter app with a profile avatar, name and short bio.

- Follow switches to Following and back.
- Like adds 1; pressing it again removes 1.
- Reset clears the like and follow states.
- State updates use setState().

## Run

From the repository root:

```sh
cd lw4_profile_card
flutter pub get
flutter run -d chrome
```

For a connected phone or emulator, use `flutter run` and choose the device.

## Check

```sh
flutter analyze
flutter test
flutter build web
```

The app code is in `lib/main.dart`. The `test` folder checks the buttons and a narrow phone layout.
