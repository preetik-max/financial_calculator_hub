import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ImagesToPdfScreen extends StatefulWidget {
  const ImagesToPdfScreen({super.key});

  @override
  State<ImagesToPdfScreen> createState() => _ImagesToPdfScreenState();
}

class _ImagesToPdfScreenState extends State<ImagesToPdfScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _images = [];

  bool _isCreating = false;
  String? _pdfPath;

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage();

      if (images.isEmpty) return;

      setState(() {
        _images
          ..clear()
          ..addAll(images);
        _pdfPath = null;
      });
    } catch (e) {
      _showMessage('Unable to select images.');
    }
  }

  Future<void> _addMoreImages() async {
    try {
      final images = await _picker.pickMultiImage();

      if (images.isEmpty) return;

      setState(() {
        _images.addAll(images);
        _pdfPath = null;
      });
    } catch (e) {
      _showMessage('Unable to select images.');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _pdfPath = null;
    });
  }

  void _moveImage(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final image = _images.removeAt(oldIndex);
      _images.insert(newIndex, image);
      _pdfPath = null;
    });
  }

  Future<void> _createPdf() async {
    if (_images.isEmpty) {
      _showMessage('Please select at least one image.');
      return;
    }

    setState(() {
      _isCreating = true;
      _pdfPath = null;
    });

    try {
      final document = pw.Document();

      for (final image in _images) {
        final bytes = await image.readAsBytes();
        final imageProvider = pw.MemoryImage(bytes);

        document.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (context) {
              return pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      final documentsDirectory = await getApplicationDocumentsDirectory();

      final pdfDirectory = Directory('${documentsDirectory.path}/Finora/PDF');

      if (!await pdfDirectory.exists()) {
        await pdfDirectory.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final file = File('${pdfDirectory.path}/Finora_Images_$timestamp.pdf');

      await file.writeAsBytes(await document.save());

      if (!mounted) return;

      setState(() {
        _pdfPath = file.path;
      });

      _showMessage('PDF created successfully.');
    } catch (e) {
      if (!mounted) return;

      _showMessage('Failed to create PDF. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<void> _openPdf() async {
    final path = _pdfPath;

    if (path == null) return;

    final result = await OpenFile.open(path, type: 'application/pdf');

    if (!mounted) return;

    if (result.type != ResultType.done) {
      _showMessage('Unable to open PDF.');
    }
  }

  Future<void> _sharePdf() async {
    final path = _pdfPath;

    if (path == null) return;

    await SharePlus.instance.share(
      ShareParams(
        text: 'Created with Finora PDF Tools',
        files: [XFile(path, mimeType: 'application/pdf')],
      ),
    );
  }

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

      _showMessage('PDF deleted.');
    } catch (e) {
      _showMessage('Unable to delete PDF.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('JPG to PDF')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHero(theme),
            const SizedBox(height: 20),
            _buildSelectButton(),
            if (_images.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildImagesSection(theme),
              const SizedBox(height: 20),
              _buildCreateButton(),
            ],
            if (_pdfPath != null) ...[
              const SizedBox(height: 24),
              _buildPdfResult(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Images to PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Convert multiple photos into one PDF document.',
                  style: TextStyle(color: Colors.white, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: _isCreating ? null : _pickImages,
        icon: const Icon(Icons.photo_library_outlined),
        label: Text(_images.isEmpty ? 'Select Images' : 'Change Images'),
      ),
    );
  }

  Widget _buildImagesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pages',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_images.length}'),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _isCreating ? null : _addMoreImages,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Hold and drag pages to change their order.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _images.length,
          onReorder: _moveImage,
          buildDefaultDragHandles: false,
          itemBuilder: (context, index) {
            final image = _images[index];

            return Card(
              key: ValueKey('${image.path}_$index'),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(image.path),
                    width: 62,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  'Page ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Drag to reorder'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.drag_handle),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: _isCreating ? null : () => _removeImage(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: _isCreating ? null : _createPdf,
        icon: _isCreating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.picture_as_pdf_rounded),
        label: Text(_isCreating ? 'Creating PDF...' : 'Create PDF'),
      ),
    );
  }

  Widget _buildPdfResult(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'PDF Ready',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your PDF has been saved to Finora/PDF.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openPdf,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sharePdf,
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: _deletePdf,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
