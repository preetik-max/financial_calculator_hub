import 'package:flutter/material.dart';

import '../../../app/routes.dart';

class PdfToolsScreen extends StatelessWidget {
  const PdfToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _Tool(
        title: 'JPG to PDF',
        description: 'Convert images into PDF',
        icon: Icons.image_outlined,
        route: AppRoutes.imagesToPdf,
        color: const Color(0xFF2563EB),
      ),
      _Tool(
        title: 'Merge PDF',
        description: 'Combine multiple PDFs',
        icon: Icons.merge_type_rounded,
        route: AppRoutes.mergePdf,
        color: const Color(0xFF7C3AED),
      ),
      _Tool(
        title: 'Split PDF',
        description: 'Extract selected pages',
        icon: Icons.call_split_rounded,
        route: AppRoutes.splitPdf,
        color: const Color(0xFF0891B2),
      ),
      _Tool(
        title: 'Compress PDF',
        description: 'Reduce PDF file size',
        icon: Icons.compress_rounded,
        route: AppRoutes.compressPdf,
        color: const Color(0xFF059669),
      ),
      _Tool(
        title: 'PDF Sign',
        description: 'Add your signature',
        icon: Icons.draw_rounded,
        route: AppRoutes.signPdf,
        color: const Color(0xFFEA580C),
      ),
      _Tool(
        title: 'Unlock PDF',
        description: 'Remove PDF password',
        icon: Icons.lock_open_rounded,
        route: AppRoutes.unlockPdf,
        color: const Color(0xFFDC2626),
      ),
      _Tool(
        title: 'PDF to JPG',
        description: 'Convert pages to images',
        icon: Icons.image_rounded,
        route: AppRoutes.pdfToJpg,
        color: const Color(0xFFDB2777),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Tools')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.scanToPdf);
              },
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.document_scanner_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scan to PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Scan documents with your camera and create a PDF instantly.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'PDF Tools',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tools.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final tool = tools[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, tool.route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: tool.color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(tool.icon, color: tool.color, size: 25),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tool.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            tool.description,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(height: 1.3),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Open',
                              style: TextStyle(
                                color: tool.color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: tool.color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Tool {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;

  const _Tool({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
  });
}
