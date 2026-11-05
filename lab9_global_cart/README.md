# LAB 9 - Global State with Provider: Multi-Screen Cart

Sneaker Store continued: a global cart built with `provider`. The Catalog and the Cart screen share one `CartProvider`, so a change on either screen shows up on the other right away.

## What is implemented

**CartProvider** (`ChangeNotifier`)
- Keeps the selected sneakers in a `Map<int, Product>`: insertion order is kept and the same sneaker cannot be added twice.
- `add`, `remove`, `toggle`, `clear` - each one calls `notifyListeners()`.
- Getters: `items`, `count`, `isEmpty`, `totalPrice`, `contains(product)`.

**Global provider** - `ChangeNotifierProvider` wraps `MaterialApp` in `main.dart`. Because it is above the `Navigator`, every pushed route gets the same cart instance.

**Screen 1 - Catalog**
- 6 sneakers (photo, title, category chip, rating, price in ₸).
- **Add** / **In Cart** toggle on every card.
- Live AppBar badge (`Badge.count`) with the number of items; hidden when the cart is empty. Tap it to open the cart.
- `context.select` - the badge rebuilds only when the count changes, a card only when its own in-cart state changes.

**Screen 2 - Cart View**
- List of selected sneakers, each with a red remove button.
- Removing shows a `SnackBar` with **UNDO**, which adds the sneaker back from this screen.
- Bottom bar: number of items and total price.
- **Clear All** in the AppBar with a confirmation dialog; disabled when the cart is empty.
- Empty state "Cart is Empty".
- The same live badge is in this AppBar, so the count changes in front of you.

**Sync** - every action on Screen 2 (remove, UNDO, Clear All) goes through `CartProvider`. When you go back, the Catalog toggles and the badge already match the cart.

## Project structure

```
lib/
  main.dart                         ChangeNotifierProvider above MaterialApp
  models/product.dart               Product model + ₸ formatting
  data/catalog.dart                 The 6 sneakers
  providers/cart_provider.dart      CartProvider (ChangeNotifier)
  screens/catalog_screen.dart       Screen 1
  screens/cart_screen.dart          Screen 2: list, remove + UNDO, total, Clear All
  widgets/cart_badge_button.dart    AppBar cart icon with live badge
  widgets/catalog_product_card.dart Catalog card with Add / In Cart toggle
  widgets/category_chip.dart        Category label (from LAB 8)
  widgets/rating_badge.dart         Star rating (from LAB 8)
test/cart_test.dart                 provider logic, live badge, Screen 2 -> Screen 1 sync
```

## Run in VS Code

1. Open the `lab9_global_cart` folder.
2. `flutter pub get`
3. Choose a device in the bottom-right corner (iOS Simulator, Android emulator or Chrome) and press **F5**.

Tests: `flutter test`

## Demo for the defense

1. Catalog: tap **Add** on 3 sneakers - the badge goes 1, 2, 3 and the buttons turn into **In Cart**.
2. Tap **In Cart** on one of them - the badge goes down.
3. Open the cart with the badge: list of sneakers and the total.
4. Remove a sneaker - the total and the badge update at once. Tap **UNDO** - it is back.
5. Remove one more and go back: its card on the Catalog shows **Add** again, the badge matches.
6. Open the cart, **Clear All** -> confirm -> "Cart is Empty", total 0 ₸. Go back: all 6 cards show **Add**, the badge is hidden.
