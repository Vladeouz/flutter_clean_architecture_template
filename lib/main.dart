import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_template/injection_container.dart';
import 'package:flutter_clean_architecture_template/router.dart';

void main() {
  init(); // Inisialisasi dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Clean Architecture',
      routerConfig: AppRouter.router, // Gunakan router dari file router.dart
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
