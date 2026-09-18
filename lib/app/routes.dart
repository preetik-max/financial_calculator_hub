import 'package:flutter/material.dart';

import 'app_shell.dart';

import '../features/home/screens/splash_screen.dart';

import '../features/financial_products/screens/financial_products_screen.dart';

import '../features/settings/screens/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  // ================================================================
  // ROUTES
  // ================================================================

  static const String splash = '/';

  static const String home = '/home';

  static const String calculators = '/calculators';

  static const String financialProducts = '/financial-products';

  static const String profile = '/profile';

  static const String settings = '/settings';

  // ================================================================
  // ROUTE MAP
  // ================================================================

  static Map<String, WidgetBuilder> get routes => {
    // Splash
    splash: (_) => const SplashScreen(),

    // Home tab
    home: (_) => const AppShell(initialIndex: 0),

    // Calculators tab
    calculators: (_) => const AppShell(initialIndex: 1),

    // Financial Products
    financialProducts: (_) => const FinancialProductsScreen(),

    // Gold

    // Profile tab
    profile: (_) => const AppShell(initialIndex: 3),

    // Settings
    settings: (_) => const SettingsScreen(),
  };
}
