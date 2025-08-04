import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_template/injection_container.dart';
import 'package:flutter_clean_architecture_template/router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

void main() {
  init(); // Inisialisasi dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          title: 'nupay',
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              ThemeMode.system, // ganti ke light/dark/system sesuai kebutuhan
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
