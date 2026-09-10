import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle price = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle positive = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.positive,
  );

  static const TextStyle negative = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.negative,
  );
}
