import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AffiliateUrlService {
  AffiliateUrlService._();

  static Future<void> open({
    required BuildContext context,
    required String url,
  }) async {
    final cleanUrl = url.trim();

    // URL has not been configured yet.
    if (cleanUrl.isEmpty) {
      _showMessage(
        context,
        'Application link is currently being updated. Please try again later.',
      );
      return;
    }

    final uri = Uri.tryParse(cleanUrl);

    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showMessage(context, 'Application link is unavailable.');
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        _showMessage(context, 'Unable to open application link.');
      }
    } catch (_) {
      _showMessage(context, 'Unable to open application link.');
    }
  }

  static void _showMessage(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
