# Milestone 1 - план защиты на 4 минуты

## 0:00-1:00 - Pitch

Можно рассказать на английском:

“My project is Sneaker Store, a mobile app for students and young shoppers who want to find an everyday pair of sneakers. The app brings product browsing, basic information and size selection into one simple flow. The current MVP has a discovery screen and a product detail screen. Users can filter the collection, open a product, save a bookmark, select a size and add the product to a demo cart. In the next milestones, I plan to connect a REST API, store data in a database and organize application state using BLoC.”

Не обещай настоящий заказ: сейчас корзина представлена демонстрационным счетчиком.

## 1:00-3:00 - Live Demo на телефоне или симуляторе

1. Покажи главный экран и две карточки.
2. Нажми Running: остается Cloud Runner. Нажми All: снова две карточки.
3. Открой Nike Air Everyday. Покажи фотографию и закладку поверх нее.
4. Нажми закладку два раза: иконка меняется туда и обратно.
5. Пролистай вниз: кнопка Add to Cart остается на месте.
6. Выбери размер 42. Кнопка становится доступной.
7. Нажми Add to Cart: счетчик увеличивается, появляется сообщение.
8. Вернись назад и открой Cloud Runner: цена и фото отличаются.
9. Если остается время, поверни симулятор или покажи узкое окно браузера.

## 3:00-4:00 - Code Review

- `lib/main.dart`: точка входа, MaterialApp, тема, начальный экран.
- `lib/models/product.dart`: модель Product и демонстрационные данные.
- `lib/screens/catalog_screen.dart`: StatefulWidget, фильтрация через setState и переход Navigator.push.
- `lib/widgets/product_card.dart`: Card, Column, Row и Expanded.
- `lib/widgets/product_cover.dart`: Stack с фотографией и Positioned для закладки.
- `lib/screens/product_screen.dart`: состояние, Wrap, прокрутка и нижняя панель.
- Покажи результат `flutter analyze` и `flutter test`.

## Что понимать перед защитой

**Зачем Stack?**

Он располагает элементы слоями. Фотография находится снизу, закладка и бейдж сверху. Positioned задает их положение относительно Stack.

**Чем Row отличается от Wrap?**

Row размещает элементы в одной горизонтальной строке. Wrap переносит их на следующую строку, если ширины не хватает. Поэтому теги и размеры размещены в Wrap.

**Зачем Expanded?**

Он занимает оставшееся пространство внутри Row или Column. В заголовке ограничивает доступную ширину текста, а в нижней панели растягивает кнопку по ширине строки.

**Как работает setState?**

Мы меняем поле состояния внутри setState. Flutter планирует повторный вызов build для этого State, и интерфейс отображает новое значение. Например, isFavorite меняет иконку закладки.

**Почему кнопка не уезжает при прокрутке?**

Она находится в Scaffold.bottomNavigationBar, отдельно от прокручиваемого body. SafeArea защищает ее от системных областей экрана.

**Как предотвращаются переполнения?**

Текст может переноситься, Row использует Expanded/Flexible, группы используют Wrap. Карточки имеют естественную высоту. Длинная страница прокручивается, а на больших экранах ширина контента ограничивается. Тесты проверяют конкретный набор размеров и масштабы текста, но не являются доказательством для абсолютно любых размеров окна.

**Почему пока нет BLoC и API?**

Milestone 1 требует UI и setState. API, база и BLoC относятся к следующим этапам. Product уже отделен от UI, поэтому источник данных можно будет заменить.

**Сохраняются ли избранное и корзина?**

Пока нет. Они локальны для открытого экрана товара. После выхода из него состояние сбрасывается. Следующий шаг - общее состояние приложения и постоянное хранение.

## Перед занятием

- Запусти симулятор или подключи телефон заранее.
- Открой папку lab5_sneaker_store в VS Code и запусти приложение.
- Проверь переходы, закладку и добавление размера.
- Держи файлы catalog_screen.dart и product_screen.dart под рукой.
- Отрепетируй выступление с таймером: цель 3-5 минут.
