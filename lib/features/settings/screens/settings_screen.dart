import 'package:flutter/material.dart';

import '../../../core/theme/theme_controller.dart';
import '../widgets/about_us_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings'), centerTitle: true),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle(context, 'Appearance'),

              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _ThemeOption(
                      icon: Icons.phone_android_outlined,
                      title: 'Automatic',
                      subtitle: 'Follow your phone system theme',
                      mode: ThemeMode.system,
                      selectedMode: themeController.themeMode,
                      onTap: () {
                        themeController.setThemeMode(ThemeMode.system);
                      },
                    ),

                    const Divider(height: 1),

                    _ThemeOption(
                      icon: Icons.light_mode_outlined,
                      title: 'Light',
                      subtitle: 'Always use light theme',
                      mode: ThemeMode.light,
                      selectedMode: themeController.themeMode,
                      onTap: () {
                        themeController.setThemeMode(ThemeMode.light);
                      },
                    ),

                    const Divider(height: 1),

                    _ThemeOption(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark',
                      subtitle: 'Always use dark theme',
                      mode: ThemeMode.dark,
                      selectedMode: themeController.themeMode,
                      onTap: () {
                        themeController.setThemeMode(ThemeMode.dark);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(context, 'About'),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.info_outline)),
                  title: const Text(
                    'About Us',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Financial Calculator Hub by Finora Labs',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AboutUsDialog();
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(context, 'Legal'),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showComingSoon(context, 'Privacy Policy');
                      },
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms & Conditions'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showComingSoon(context, 'Terms & Conditions');
                      },
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.warning_amber_outlined),
                      title: const Text('Financial Disclaimer'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showComingSoon(context, 'Financial Disclaimer');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle(context, 'App'),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone_android_outlined),
                  title: const Text('App Version'),
                  subtitle: const Text('Version 1.0.0'),
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Column(
                  children: [
                    Text(
                      'Finora Labs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Simple Tools. Smarter Financial Decisions.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title will be available soon.')));
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeMode mode;
  final ThemeMode selectedMode;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.selectedMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == selectedMode;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,

      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(subtitle),

      trailing: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
