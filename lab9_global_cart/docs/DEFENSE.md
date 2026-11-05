# LAB 9 - подготовка к защите

## Live Demo (1-2 минуты)

1. На Catalog нажми **Add** у 3 кроссовок: бейдж в AppBar 1 → 2 → 3, кнопки стали **In Cart**.
2. Нажми **In Cart** у одной: кроссовка убралась из корзины, бейдж уменьшился.
3. Нажми на иконку корзины: открылся экран My Cart, внизу сумма.
4. Удали кроссовку красной кнопкой: сумма и бейдж сразу обновились. Нажми **UNDO**: вернулась.
5. Удали еще одну и вернись назад: на Catalog у нее снова **Add**, бейдж совпадает с корзиной.
6. Снова в корзину, **Clear All** → Clear: "Cart is Empty", 0 ₸. Назад: у всех 6 кнопка **Add**, бейджа нет.

## Где что лежит в коде

- `lib/providers/cart_provider.dart` - `CartProvider extends ChangeNotifier`: `add`, `remove`, `toggle`, `clear`, `totalPrice`.
- `lib/main.dart` - `ChangeNotifierProvider` над `MaterialApp`.
- `lib/widgets/cart_badge_button.dart` - бейдж через `context.select`.
- `lib/widgets/catalog_product_card.dart` - карточка с переключателем Add / In Cart.
- `lib/screens/cart_screen.dart` - список, удаление + UNDO, сумма, Clear All.
- Покажи результат `flutter analyze` и `flutter test`.

## Возможные вопросы преподавателя

**Зачем Provider, если есть setState?**

`setState` меняет состояние только одного виджета. Корзина нужна на двух экранах. Без Provider пришлось бы передавать список и колбэки через конструкторы (prop drilling) и вручную обновлять первый экран после возврата. Provider хранит состояние выше всех экранов, и любой виджет может его прочитать.

**Что делает ChangeNotifier и notifyListeners()?**

`ChangeNotifier` хранит список слушателей. `notifyListeners()` сообщает им всем: данные изменились. `ChangeNotifierProvider` подписывается на него и перестраивает виджеты, которые используют `watch` или `select`.

**Почему ChangeNotifierProvider именно над MaterialApp?**

`Navigator.push` добавляет новый экран внутрь `MaterialApp`/`Navigator`, а не внутрь первого экрана. Если положить провайдер в Catalog, на экране Cart будет ошибка `ProviderNotFoundException`. Над `MaterialApp` провайдер виден на всех маршрутах, и оба экрана работают с одним объектом корзины.

**Чем отличаются watch, read и select?**

- `context.watch<CartProvider>()` - подписка на все изменения, виджет перестраивается при любом `notifyListeners`. Используется на экране Cart, там нужны и список, и сумма.
- `context.read<CartProvider>()` - взять объект без подписки. Используется в `onPressed` (нажатие кнопки не должно перестраивать виджет).
- `context.select((cart) => cart.count)` - подписка только на одно значение. Бейдж перестраивается, только когда меняется количество, а карточка - только когда меняется ее собственный статус.

**Как экран 2 синхронизируется с экраном 1?**

Экраны не общаются напрямую. Экран Cart вызывает `remove` / `add` / `clear` у общего `CartProvider`, тот вызывает `notifyListeners()`, и карточки + бейдж на Catalog перестраиваются, даже пока Catalog закрыт экраном Cart. Когда пользователь нажимает назад, все уже обновлено.

**Почему Map, а не List?**

`Map<int, Product>` по `id`: нельзя добавить одну кроссовку дважды, проверка `contains` быстрая. Литерал `{}` в Dart - это `LinkedHashMap`, он сохраняет порядок добавления.

**Почему items возвращает List.unmodifiable?**

Чтобы никто не мог изменить корзину в обход провайдера (например `cart.items.add(...)`), иначе `notifyListeners` не вызовется и экраны не обновятся.

**Как работает UNDO?**

Перед удалением сохраняем ссылку на `cart` и `product`. Кнопка UNDO в SnackBar вызывает `cart.add(product)` - это добавление прямо с экрана 2, и Catalog тоже синхронизируется.

**Зачем context.mounted после showDialog?**

`showDialog` асинхронный. Пока открыт диалог, экран могли закрыть. Проверка `context.mounted` не дает использовать уже удаленный context.

**Что проверяют тесты?**

`test/cart_test.dart`: логика провайдера (toggle, сумма, без дублей, clear), живой бейдж на Catalog и полный сценарий синхронизации: удаление, UNDO и Clear All на экране 2 → изменения на экране 1.
