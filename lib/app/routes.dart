import 'package:flutter/material.dart';

import 'app_shell.dart';

import '../features/home/screens/splash_screen.dart';
import '../features/financial_products/screens/financial_products_screen.dart';
import '../features/settings/screens/settings_screen.dart';

import '../features/pdf_tools/screens/images_to_pdf_screen.dart';
import '../features/pdf_tools/screens/pdf_tools_screen.dart';
import '../features/pdf_tools/screens/scan_to_pdf_screen.dart';
import '../features/pdf_tools/screens/pdf_advanced_tool_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  static const String home = '/home';

  static const String calculators = '/calculators';

  static const String financialProducts = '/financial-products';

  static const String profile = '/profile';

  static const String settings = '/settings';

  static const String pdfTools = '/pdf-tools';

  static const String imagesToPdf = '/pdf-tools/images-to-pdf';

  static const String scanToPdf = '/pdf-tools/scan-to-pdf';

  static const String mergePdf = '/pdf-tools/merge';

  static const String splitPdf = '/pdf-tools/split';

  static const String compressPdf = '/pdf-tools/compress';

  static const String signPdf = '/pdf-tools/sign';

  static const String unlockPdf = '/pdf-tools/unlock';

  static const String pdfToJpg = '/pdf-tools/to-jpg';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),

    home: (_) => const AppShell(initialIndex: 0),

    calculators: (_) => const AppShell(initialIndex: 1),

    financialProducts: (_) => const FinancialProductsScreen(),

    profile: (_) => const AppShell(initialIndex: 3),

    settings: (_) => const SettingsScreen(),

    pdfTools: (_) => const PdfToolsScreen(),

    imagesToPdf: (_) => const ImagesToPdfScreen(),

    scanToPdf: (_) => const ScanToPdfScreen(),

    mergePdf: (_) => const PdfAdvancedToolScreen(tool: PdfAdvancedTool.merge),

    splitPdf: (_) => const PdfAdvancedToolScreen(tool: PdfAdvancedTool.split),

    compressPdf: (_) =>
        const PdfAdvancedToolScreen(tool: PdfAdvancedTool.compress),

    signPdf: (_) => const PdfAdvancedToolScreen(tool: PdfAdvancedTool.sign),

    unlockPdf: (_) => const PdfAdvancedToolScreen(tool: PdfAdvancedTool.unlock),

    pdfToJpg: (_) => const PdfAdvancedToolScreen(tool: PdfAdvancedTool.toJpg),
  };
}
