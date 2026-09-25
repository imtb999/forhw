# Lab 4: Interactive Profile Card

A single-screen Flutter app with a local initials avatar and profile details.

- Follow / Following toggles membership and changes the follower count.
- Like / Liked adds or removes one like (128 -> 129 -> 128).
- Reset restores 2,400 followers, 128 likes, and both toggles to off.
- All interactive state is managed with setState() in lib/main.dart.
- No third-party packages or network images are needed.

## Run

```sh
flutter pub get
flutter run -d chrome
```

You can also run on an Android or iOS device with `flutter run`.

## Check

```sh
flutter analyze
flutter test
```

Edit the name, handle, bio and avatar initials in `lib/main.dart` to personalize the profile.
