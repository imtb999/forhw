# LAB 12 - Enterprise Auth & Shopping Cart with BLoC

Continuation of LAB 9: the same red Material 3 theme and sneaker catalog, but the Provider cart is replaced with `flutter_bloc: ^8.1.3` + `equatable: ^2.0.5`, and a login screen with an auth Cubit is added.

## Run

```sh
flutter pub get
flutter run
```

Demo account: **student@narxoz.kz / 123456**

## Structure

| File | Purpose |
| --- | --- |
| `lib/auth/auth_state.dart` | Immutable `AuthInitial`, `AuthLoading`, `AuthSuccess(username, email)`, `AuthError(message)` with Equatable `props` |
| `lib/auth/auth_cubit.dart` | `login(email, password)`: emits `AuthLoading`, waits 2 s, validates, emits `AuthSuccess` or `AuthError`; `logout()` |
| `lib/cart/cart_event.dart` | `AddProductEvent(Product)`, `RemoveProductEvent(productId)`, `ClearCartEvent()` |
| `lib/cart/cart_state.dart` | `CartState(items, totalPrice, count)` and `CartItem(product, quantity)` |
| `lib/cart/cart_bloc.dart` | `on<AddProductEvent>`, `on<RemoveProductEvent>`, `on<ClearCartEvent>` handlers |
| `lib/screens/login_screen.dart` | Screen 1: form + `BlocConsumer<AuthCubit, AuthState>` |
| `lib/screens/catalog_screen.dart` | Screen 2: products with Add buttons dispatching `AddProductEvent` |
| `lib/screens/cart_screen.dart` | Screen 3: items, remove, total, Clear All |
| `lib/widgets/cart_badge_button.dart` | AppBar cart icon with live `Badge` via `BlocBuilder<CartBloc, CartState>` |

`AuthCubit` and `CartBloc` are created by `MultiBlocProvider` above `MaterialApp`, so all three routes share the same instances and the badge stays in sync on Catalog and Cart.

## Login flow

- **listener** (side effects only): `AuthError` shows a red floating SnackBar; `AuthSuccess` calls `pushReplacementNamed('/catalog')`.
- **builder** (UI only): while `AuthLoading` the Log In button is replaced by `CircularProgressIndicator`.
- Errors: empty fields, email without `@`, wrong email/password. Repeated taps during loading are ignored.
- Log out (Catalog AppBar) resets the Cubit to `AuthInitial`, clears the cart and returns to Login.

## Defense notes

- **BlocListener vs BlocBuilder.** `BlocBuilder` rebuilds widgets for every new state and must be a pure function of state. `BlocListener` runs a callback exactly once per state change and builds nothing, so it is used for navigation, SnackBars and dialogs. If navigation were inside a builder, it would fire again on every rebuild. `BlocConsumer` = both in one widget.
- **Equatable.** Dart compares objects by reference by default. Equatable overrides `==`/`hashCode` using `props`, so two `AuthError('x')` are equal. Bloc skips emitting a state equal to the current one, which avoids useless rebuilds, and tests can write `expect(state, AuthSuccess(...))`.
- **Cubit vs Bloc.** Cubit exposes methods that call `emit()` directly (simple flows like login). Bloc receives event objects and maps them to states in `on<Event>` handlers, which gives a traceable event log and suits more complex logic like the cart.

## Verification

```sh
flutter analyze
flutter test
```

Tests cover the Cubit state sequence, the Bloc handlers and the full UI flow (error SnackBar, spinner, navigation, badge, removal, total, Clear All).
