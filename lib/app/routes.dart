import 'package:flutter/material.dart';

import 'app_shell.dart';

import '../features/home/screens/splash_screen.dart';

import '../features/metals/screens/gold_price_screen.dart';
import '../features/metals/screens/silver_price_screen.dart';

import '../features/financial_products/screens/financial_products_screen.dart';

import '../features/settings/screens/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  static const String home = '/home';

  static const String calculators = '/calculators';

  static const String financialProducts = '/financial-products';

  static const String gold = '/gold';

  static const String silver = '/silver';

  static const String profile = '/profile';

  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),

    home: (_) => const AppShell(initialIndex: 0),

    calculators: (_) => const AppShell(initialIndex: 1),

    financialProducts: (_) => const FinancialProductsScreen(),

    gold: (_) => const GoldPriceScreen(),

    silver: (_) => const SilverPriceScreen(),

    profile: (_) => const AppShell(initialIndex: 3),

    settings: (_) => const SettingsScreen(),
  };
}
