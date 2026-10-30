# LAB 8 - Dynamic Lists, Grids & Touch Gestures

Sneaker Store continued: one catalog shown as a lazy list feed or a 2-column grid, with Pull-to-Refresh, Swipe-to-Delete, UNDO and an empty state.

## What is implemented

**List Feed** (`ListView.separated`)
- Each row has an avatar photo, title, category chip, star rating and price in ₸.
- `separatorBuilder` draws a thin `Divider` between rows.
- Lazy rendering: only the rows on screen are built, so a long catalog does not use extra memory like a `Column` would.

**Grid Catalog** (`GridView.builder`)
- 2 columns, `childAspectRatio: 0.72`.
- The photo inside the card is `Expanded` and the texts use `maxLines` + ellipsis, so there is no RenderFlex overflow.

**Toggle** - the AppBar icon and the bottom `NavigationBar` both switch between List Feed and Grid Catalog.

**Pull-to-Refresh** (`RefreshIndicator`)
- `onRefresh` waits `Future.delayed(const Duration(milliseconds: 1500))`, then inserts a new "New Drop" sneaker at index 0 with `setState`.
- `AlwaysScrollableScrollPhysics` keeps the pull working even when only a few items are left.

**Swipe-to-Delete** (`Dismissible`)
- `key: ValueKey(product.id)`, `direction: DismissDirection.endToStart`.
- Red background with `Icons.delete` while swiping right-to-left.
- `onDismissed` removes the item and shows a floating `SnackBar` with **UNDO**, which inserts the item back at its original index.

**Empty state** - when the catalog reaches 0 items: icon, "Catalog is Empty" and a **Reset Catalog** button that restores the 24 seed sneakers.

## Project structure

```
lib/
  main.dart                       MaterialApp and theme
  models/product.dart             Product model + price formatting
  data/catalog_repository.dart    Seed data and fake 1.5 s "network" request
  screens/catalog_screen.dart     State: list, view mode, refresh, delete, undo
  widgets/product_list_tile.dart  Row of the List Feed
  widgets/product_grid_card.dart  Card of the Grid Catalog
  widgets/delete_background.dart  Red swipe background
  widgets/empty_catalog.dart      Empty state with Reset Catalog
  widgets/category_chip.dart      Category label
  widgets/rating_badge.dart       Star rating
test/catalog_test.dart            lazy list, grid, refresh, delete + undo, empty state
```

## Run in VS Code

1. Open the `lab8_catalog_feed` folder.
2. `flutter pub get`
3. Choose a device in the bottom-right corner (iOS Simulator, Android emulator or Chrome) and press **F5**.

Tests: `flutter test`

## Demo for the defense

1. List Feed: scroll the 24 sneakers.
2. Pull down: spinner for 1.5 s, a "New Drop" sneaker appears at the top, the counter in the AppBar grows.
3. Swipe a row to the left: red background with the trash icon, row removed, SnackBar appears.
4. Tap **UNDO**: the row returns to the same place.
5. Switch to **Grid Catalog**: 2 columns, no overflow. Swipe and pull work here too.
6. Delete everything to show **Catalog is Empty**, then tap **Reset Catalog**.
