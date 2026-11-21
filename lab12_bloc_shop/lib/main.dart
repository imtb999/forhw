import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_cubit.dart';
import 'cart/cart_bloc.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(const BlocShopApp());

class BlocShopApp extends StatelessWidget {
  const BlocShopApp({super.key, this.authDelay = const Duration(seconds: 2)});

  final Duration authDelay;

  @override
  Widget build(BuildContext context) {
    // Provided above MaterialApp, so every route sees the same instances.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(delay: authDelay)),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'BLoC Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFE53935),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.route,
        routes: {
          LoginScreen.route: (_) => const LoginScreen(),
          CatalogScreen.route: (_) => const CatalogScreen(),
          CartScreen.route: (_) => const CartScreen(),
        },
      ),
    );
  }
}
