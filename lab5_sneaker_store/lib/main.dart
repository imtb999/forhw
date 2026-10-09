import 'package:flutter/material.dart';

import 'screens/registration_screen.dart';

void main() {
  runApp(const SneakerStoreApp());
}

class SneakerStoreApp extends StatelessWidget {
  const SneakerStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneaker Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC44329)),
        scaffoldBackgroundColor: const Color(0xFFFAF8F5),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}
