import 'package:url_launcher/url_launcher.dart';

class WhatsAppLeadService {
  WhatsAppLeadService._();

  // Finora WhatsApp business/contact number.
  static const String phoneNumber = '918318950758';

  static Future<bool> openWhatsApp({required String message}) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
      queryParameters: <String, String>{'text': message},
    );

    try {
      return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
