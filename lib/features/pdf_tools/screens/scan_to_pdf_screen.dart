import 'dart:io';

import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScanToPdfScreen extends StatefulWidget {
  const ScanToPdfScreen({super.key});

  @override
  State<ScanToPdfScreen> createState() => _ScanToPdfScreenState();
}

class _ScanToPdfScreenState extends State<ScanToPdfScreen> {
  bool _isScanning = false;
  String? _pdfPath;
  String? _errorMessage;

  // ================================================================
  // SCAN DOCUMENT
  // ================================================================

  Future<void> _scanDocument() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      final result = await DocumentScanner.scan(format: DocScanFormat.pdf);

      if (!mounted) return;

      if (result == null || result.isEmpty) {
        setState(() {
          _isScanning = false;
        });
        return;
      }

      // The scanner may return one or more generated files.
      final sourcePath = result.first;

      final savedPath = await _savePdf(sourcePath);

      if (!mounted) return;

      setState(() {
        _pdfPath = savedPath;
        _isScanning = false;
      });

      _showSuccessMessage('PDF created successfully.');
    } on DocumentScannerException catch (e) {
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _errorMessage = e.message;
      });

      _showErrorMessage(e.message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _errorMessage = e.toString();
      });

      _showErrorMessage('Unable to scan the document. Please try again.');
    }
  }

  // ================================================================
  // SAVE PDF
  // ================================================================

  Future<String> _savePdf(String sourcePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final pdfDirectory = Directory('${documentsDirectory.path}/Finora/PDF');

    if (!await pdfDirectory.exists()) {
      await pdfDirectory.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final destinationPath = '${pdfDirectory.path}/Finora_Scan_$timestamp.pdf';

    final sourceFile = File(sourcePath);

    final destinationFile = await sourceFile.copy(destinationPath);

    return destinationFile.path;
  }

  // ================================================================
  // OPEN PDF
  // ================================================================

  Future<void> _openPdf() async {
    final path = _pdfPath;

    if (path == null) return;

    final result = await OpenFile.open(path, type: 'application/pdf');

    if (!mounted) return;

    if (result.type != ResultType.done) {
      _showErrorMessage(
        result.message.isNotEmpty ? result.message : 'Unable to open PDF.',
      );
    }
  }

  // ================================================================
  // SHARE PDF
  // ================================================================

  Future<void> _sharePdf() async {
    final path = _pdfPath;

    if (path == null) return;

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path, mimeType: 'application/pdf')],
        subject: 'Finora Scanned PDF',
        text: 'Scanned using Finora Financial Calculator Hub.',
      ),
    );
  }

  // ================================================================
  // DELETE CURRENT PDF
  // ================================================================

  Future<void> _deletePdf() async {
    final path = _pdfPath;

    if (path == null) return;

    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }

      if (!mounted) return;

      setState(() {
        _pdfPath = null;
      });

      _showSuccessMessage('PDF deleted.');
    } catch (_) {
      if (!mounted) return;

      _showErrorMessage('Unable to delete PDF.');
    }
  }

  // ================================================================
  // MESSAGES
  // ================================================================

  void _showSuccessMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan to PDF')),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ========================================================
            // HERO
            // ========================================================
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.document_scanner_rounded,
                      size: 44,
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Scan documents to PDF',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Capture documents with your camera. '
                    'Finora automatically detects edges, '
                    'crops the page and creates a clean PDF.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========================================================
            // FEATURES
            // ========================================================
            _FeatureRow(
              icon: Icons.crop_free_rounded,
              title: 'Automatic edge detection',
              subtitle: 'Detect and crop document edges.',
            ),

            _FeatureRow(
              icon: Icons.auto_fix_high_rounded,
              title: 'Automatic enhancement',
              subtitle: 'Make scanned documents cleaner and easier to read.',
            ),

            _FeatureRow(
              icon: Icons.library_add_rounded,
              title: 'Multiple pages',
              subtitle: 'Scan multiple pages into one PDF.',
            ),

            _FeatureRow(
              icon: Icons.lock_outline_rounded,
              title: 'Private processing',
              subtitle: 'Document scanning is processed on your device.',
            ),

            const SizedBox(height: 24),

            // ========================================================
            // SCAN BUTTON
            // ========================================================
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _isScanning ? null : _scanDocument,
                icon: _isScanning
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.camera_alt_rounded),
                label: Text(
                  _isScanning ? 'Scanning...' : 'Scan Document',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),

              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.error, fontSize: 13),
              ),
            ],

            // ========================================================
            // GENERATED PDF
            // ========================================================
            if (_pdfPath != null) ...[
              const SizedBox(height: 28),

              Text(
                'Your PDF',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 10),

              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: const Text(
                        'Finora Scan PDF',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: const Text('PDF saved successfully'),
                    ),

                    const Divider(height: 1),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _openPdf,
                              icon: const Icon(Icons.open_in_new_rounded),
                              label: const Text('Open'),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _sharePdf,
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: TextButton.icon(
                        onPressed: _deletePdf,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// FEATURE ROW
// ==================================================================

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
