import 'package:flutter/material.dart';

import 'whatsapp_lead_service.dart';

class LeadContactButton extends StatelessWidget {
  final String message;
  final String tooltip;
  final VoidCallback? onError;

  const LeadContactButton({
    super.key,
    required this.message,
    this.tooltip = 'Chat with Financial Advisor',
    this.onError,
  });

  Future<void> _openWhatsApp() async {
    final bool launched = await WhatsAppLeadService.openWhatsApp(
      message: message,
    );

    if (!launched) {
      onError?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _openWhatsApp,
        customBorder: const CircleBorder(),
        child: Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: Color(0xFF25D366),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.chat_rounded, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
