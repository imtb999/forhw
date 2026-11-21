# LAB 10 - Cloud Product Explorer & Detail Carousel

Continuation of LAB 9: the red Material 3 theme, shared Provider cart, badge, remove/UNDO and total are kept. The local sneaker catalog is moved to the network: the same sneakers are served as JSON from this repository (`api/products.json` + `api/images/`) and loaded over HTTP from https://raw.githubusercontent.com/imtb999/forhw/main/lab10_cloud_product_explorer/api/products.json.

## Run

```sh
flutter pub get
flutter run
```

## Features

- Null-safe Product.fromJson with numeric conversion through num.toDouble(). Prices are displayed in tenge (54 990 ₸).
- HTTP GET with a 10-second timeout, distinct 404/server/connection/invalid JSON errors.
- Loading, success and error states, Retry Connection, pull-to-refresh and refreshable empty state.
- ListView.separated with thumbnails, ratings and review counts.
- ProductDetailScreen with matching Hero tags, PageView.builder, animated dots and page counter.
- Category badge, full description and sticky Add to Cart connected to the shared cart.
- Share bottom sheet with selectable narxoz://store/product/{id} and Copy Link.

## API limitation

The JSON supplies one image per product (`image`). The three carousel pages show the original, a close-up and a detail crop of that same image. They are not three different product photographs. The share sheet generates and copies the requested URI; registering the URI with the OS and receiving external links is outside this assignment's share-sheet requirement.

## Verification

```sh
flutter analyze
flutter test
```

On a physical phone, load the feed, turn on Airplane mode and pull to refresh. Wait up to 10 seconds for the error state. Restore connectivity and press Retry Connection without restarting the app. On the iOS simulator, disable the Mac's network connection for this check. Open a product, swipe all views, tap a dot, add it to the cart, then copy its share link and paste it into a text field.

The live classroom defense and physical-device offline check must be performed in class.
