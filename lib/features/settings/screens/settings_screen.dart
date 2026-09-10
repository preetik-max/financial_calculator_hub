import 'package:flutter/material.dart';

import '../widgets/about_us_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(context, 'About'),

          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.info_outline)),
              title: const Text(
                'About Us',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Financial Calculator Hub by Finora Labs'),
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
