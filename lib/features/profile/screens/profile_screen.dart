import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Profile', style: AppTextStyles.headline),
          const SizedBox(height: 6),
          const Text('Manage your app preferences', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xxl),

          // Profile header card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.person_outline, size: 30),
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Planner',
                      style: AppTextStyles.sectionTitle,
                    ),
                    SizedBox(height: 4),
                    Text('Your finance companion', style: AppTextStyles.body),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Settings
          _menu(
            context,
            Icons.settings_outlined,
            'Settings',
            'App preferences',
            () => Navigator.pushNamed(context, AppRoutes.settings),
          ),

          // About Us
          _menu(
            context,
            Icons.info_outline,
            'About Us',
            'About Financial Calculator Hub',
            () {},
          ),

          // Rate App
          _menu(
            context,
            Icons.star_outline_rounded,
            'Rate App',
            'Share your feedback',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: AppTextStyles.sectionTitle),
          subtitle: Text(subtitle, style: AppTextStyles.caption),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }
}
