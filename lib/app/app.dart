import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/theme/app_theme.dart';

class FinancialCalculatorHubApp extends StatelessWidget {
  const FinancialCalculatorHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Calculator Hub',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
