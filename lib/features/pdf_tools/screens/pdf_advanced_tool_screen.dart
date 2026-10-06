import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';

enum PdfAdvancedTool { merge, split, compress, sign, unlock, toJpg }

class PdfAdvancedToolScreen extends StatefulWidget {
  final PdfAdvancedTool tool;

  const PdfAdvancedToolScreen({super.key, required this.tool});

  @override
  State<PdfAdvancedToolScreen> createState() => _PdfAdvancedToolScreenState();
}

class _PdfAdvancedToolScreenState extends State<PdfAdvancedToolScreen> {
  final List<String> _files = [];

  final TextEditingController _startController = TextEditingController(
    text: '1',
  );

  final TextEditingController _endController = TextEditingController(text: '1');

  final TextEditingController _passwordController = TextEditingController();

  late final SignatureController _signatureController;

  bool _working = false;
  String? _outputPath;
  int? _pageCount;

  @override
  void initState() {
    super.initState();

    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _passwordController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.tool) {
      case PdfAdvancedTool.merge:
        return 'Merge PDF';
      case PdfAdvancedTool.split:
        return 'Split PDF';
      case PdfAdvancedTool.compress:
        return 'Compress PDF';
      case PdfAdvancedTool.sign:
        return 'PDF Sign';
      case PdfAdvancedTool.unlock:
        return 'Unlock PDF';
      case PdfAdvancedTool.toJpg:
        return 'PDF to JPG';
    }
  }

  String get _description {
    switch (widget.tool) {
      case PdfAdvancedTool.merge:
        return 'Combine multiple PDF files into one document.';
      case PdfAdvancedTool.split:
        return 'Extract selected pages into a new PDF.';
      case PdfAdvancedTool.compress:
        return 'Reduce PDF file size while keeping good quality.';
      case PdfAdvancedTool.sign:
        return 'Draw your signature and place it on the PDF.';
      case PdfAdvancedTool.unlock:
        return 'Remove a password from a protected PDF.';
      case PdfAdvancedTool.toJpg:
        return 'Convert PDF pages into JPG images.';
    }
  }

  IconData get _icon {
    switch (widget.tool) {
      case PdfAdvancedTool.merge:
        return Icons.merge_type_rounded;
      case PdfAdvancedTool.split:
        return Icons.call_split_rounded;
      case PdfAdvancedTool.compress:
        return Icons.compress_rounded;
      case PdfAdvancedTool.sign:
        return Icons.draw_rounded;
      case PdfAdvancedTool.unlock:
        return Icons.lock_open_rounded;
      case PdfAdvancedTool.toJpg:
        return Icons.image_rounded;
    }
  }

  Future<Directory> _pdfDirectory() async {
    final root = await getApplicationDocumentsDirectory();

    final directory = Directory('${root.path}/Finora/PDF');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<List<String>> _pickPdfs({bool allowMultiple = true}) async {
    if (allowMultiple) {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      return files
          .where((file) => file.path != null)
          .map((file) => file.path!)
          .toList();
    }

    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (file?.path == null) {
      return [];
    }

    return [file!.path!];
  }

  Future<void> _pickFiles() async {
    try {
      final multiple = widget.tool == PdfAdvancedTool.merge;

      final paths = await _pickPdfs(allowMultiple: multiple);

      if (paths.isEmpty) return;

      setState(() {
        _files
          ..clear()
          ..addAll(paths);
        _outputPath = null;
        _pageCount = null;
      });

      if (!multiple) {
        await _loadPageCount(paths.first);
      }
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _loadPageCount(String path) async {
    try {
      final bytes = await File(path).readAsBytes();

      final pdf = Pdf();

      final doc = await pdf.open(MemorySource(bytes));

      if (!mounted) {
        await doc.dispose();
        await pdf.dispose();
        return;
      }

      setState(() {
        _pageCount = doc.pageCount;

        if (_pageCount != null && _pageCount! > 0) {
          _endController.text = _pageCount.toString();
        }
      });

      await doc.dispose();
      await pdf.dispose();
    } catch (e) {
      _showError('Unable to read PDF: $e');
    }
  }

  Future<void> _run() async {
    if (_files.isEmpty) {
      _showMessage('Please select a PDF first.');
      return;
    }

    switch (widget.tool) {
      case PdfAdvancedTool.merge:
        await _merge();
        break;

      case PdfAdvancedTool.split:
        await _split();
        break;

      case PdfAdvancedTool.compress:
        await _compress();
        break;

      case PdfAdvancedTool.sign:
        await _sign();
        break;

      case PdfAdvancedTool.unlock:
        await _unlock();
        break;

      case PdfAdvancedTool.toJpg:
        await _convertToJpg();
        break;
    }
  }

  Future<String> _newOutputPath(String name) async {
    final directory = await _pdfDirectory();

    return '${directory.path}/'
        '${name}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _merge() async {
    if (_files.length < 2) {
      _showMessage('Select at least 2 PDF files.');
      return;
    }

    await _runBusy(() async {
      final pdf = Pdf();

      try {
        final sources = <DataSource>[];

        for (final path in _files) {
          sources.add(MemorySource(await File(path).readAsBytes()));
        }

        final sink = MemorySink();

        await pdf.merge(sources, sink);

        final output = await _newOutputPath('Finora_Merged');

        final outputFile = File('$output.pdf');

        await outputFile.writeAsBytes(sink.takeBytes(), flush: true);

        _outputPath = outputFile.path;
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('PDFs merged successfully.');
  }

  Future<void> _split() async {
    final start = int.tryParse(_startController.text.trim());

    final end = int.tryParse(_endController.text.trim());

    if (start == null || end == null) {
      _showMessage('Enter valid page numbers.');
      return;
    }

    if (_pageCount == null) {
      _showMessage('Unable to determine PDF pages.');
      return;
    }

    if (start < 1 || end < start || end > _pageCount!) {
      _showMessage('Pages must be between 1 and $_pageCount.');
      return;
    }

    await _runBusy(() async {
      final bytes = await File(_files.first).readAsBytes();

      final pdf = Pdf();

      try {
        final sink = MemorySink();

        final pages = List<int>.generate(
          end - start + 1,
          (index) => (start - 1) + index,
        );

        await pdf.extractPages(MemorySource(bytes), sink, pages: pages);

        final directory = await _pdfDirectory();

        final outputFile = File(
          '${directory.path}/'
          'Finora_Split_'
          '${DateTime.now().millisecondsSinceEpoch}.pdf',
        );

        await outputFile.writeAsBytes(sink.takeBytes(), flush: true);

        _outputPath = outputFile.path;
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('Pages extracted successfully.');
  }

  Future<void> _compress() async {
    await _runBusy(() async {
      final bytes = await File(_files.first).readAsBytes();

      final pdf = Pdf();

      try {
        final sink = MemorySink();

        await pdf.compress(
          MemorySource(bytes),
          sink,
          images: PdfImagePolicy.ebook,
        );

        final directory = await _pdfDirectory();

        final outputFile = File(
          '${directory.path}/'
          'Finora_Compressed_'
          '${DateTime.now().millisecondsSinceEpoch}.pdf',
        );

        await outputFile.writeAsBytes(sink.takeBytes(), flush: true);

        _outputPath = outputFile.path;
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('PDF compressed successfully.');
  }

  Future<void> _unlock() async {
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      _showMessage('Enter the current PDF password.');
      return;
    }

    await _runBusy(() async {
      final bytes = await File(_files.first).readAsBytes();

      final pdf = Pdf();

      try {
        final sink = MemorySink();

        await pdf.decrypt(MemorySource(bytes), sink, password: password);

        final directory = await _pdfDirectory();

        final outputFile = File(
          '${directory.path}/'
          'Finora_Unlocked_'
          '${DateTime.now().millisecondsSinceEpoch}.pdf',
        );

        await outputFile.writeAsBytes(sink.takeBytes(), flush: true);

        _outputPath = outputFile.path;
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('PDF unlocked successfully.');
  }

  Future<void> _sign() async {
    if (_signatureController.isEmpty) {
      _showMessage('Please draw your signature first.');
      return;
    }

    await _runBusy(() async {
      final signatureBytes = await _signatureController.toPngBytes();

      if (signatureBytes == null || signatureBytes.isEmpty) {
        throw Exception('Could not create signature image.');
      }

      final pdfBytes = await File(_files.first).readAsBytes();

      final pdf = Pdf();

      try {
        final source = MemorySource(pdfBytes);

        final signature = MemorySource(signatureBytes);

        final sink = MemorySink();

        final doc = await pdf.open(source);

        try {
          if (doc.pageCount < 1) {
            throw Exception('PDF has no pages.');
          }

          final page = doc.pages.first;

          final pageWidth = page.mediaBox.width;

          final pageHeight = page.mediaBox.height;

          final signatureWidth = pageWidth * 0.30;

          final signatureHeight = signatureWidth * 0.40;

          await pdf.addImageStamp(
            source,
            sink,
            page: 0,
            imageData: signature,
            rect: PdfRect(
              x: pageWidth - signatureWidth - 40,
              y: 40,
              width: signatureWidth,
              height: signatureHeight,
            ),
          );
        } finally {
          await doc.dispose();
        }

        final directory = await _pdfDirectory();

        final outputFile = File(
          '${directory.path}/'
          'Finora_Signed_'
          '${DateTime.now().millisecondsSinceEpoch}.pdf',
        );

        await outputFile.writeAsBytes(sink.takeBytes(), flush: true);

        _outputPath = outputFile.path;
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('Signature added successfully.');
  }

  Future<void> _convertToJpg() async {
    await _runBusy(() async {
      final bytes = await File(_files.first).readAsBytes();

      final pdf = Pdf();

      try {
        final doc = await pdf.open(MemorySource(bytes));

        try {
          final directory = await _pdfDirectory();

          String? firstOutput;

          var pageNumber = 0;

          await for (final page in doc.render(
            pages: PdfPages.all(),
            size: PdfRenderSize(width: 1600),
          )) {
            pageNumber++;

            final decoded = img.decodePng(page.data);

            if (decoded == null) {
              continue;
            }

            final jpgBytes = img.encodeJpg(decoded, quality: 90);

            final outputFile = File(
              '${directory.path}/'
              'Finora_Page_$pageNumber'
              '_${DateTime.now().millisecondsSinceEpoch}'
              '.jpg',
            );

            await outputFile.writeAsBytes(jpgBytes, flush: true);

            firstOutput ??= outputFile.path;
          }

          _outputPath = firstOutput;
        } finally {
          await doc.dispose();
        }
      } finally {
        await pdf.dispose();
      }
    });

    _showSuccess('PDF converted to JPG images.');
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    if (_working) return;

    setState(() {
      _working = true;
      _outputPath = null;
    });

    try {
      await action();
    } catch (e) {
      if (mounted) {
        _showError(e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
        });
      }
    }
  }

  Future<void> _openOutput() async {
    final path = _outputPath;

    if (path == null) return;

    await OpenFile.open(path);
  }

  Future<void> _shareOutput() async {
    final path = _outputPath;

    if (path == null) return;

    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  Future<void> _deleteOutput() async {
    final path = _outputPath;

    if (path == null) return;

    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }

      if (mounted) {
        setState(() {
          _outputPath = null;
        });
      }

      _showMessage('Output deleted.');
    } catch (e) {
      _showError(e);
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _headerCard(colorScheme),

            const SizedBox(height: 16),

            _selectCard(),

            const SizedBox(height: 16),

            if (_files.isNotEmpty) _filesCard(),

            if (widget.tool == PdfAdvancedTool.split && _files.isNotEmpty)
              _splitControls(),

            if (widget.tool == PdfAdvancedTool.unlock && _files.isNotEmpty)
              _passwordField(),

            if (widget.tool == PdfAdvancedTool.sign && _files.isNotEmpty)
              _signatureCard(),

            const SizedBox(height: 20),

            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _working ? null : _run,
                icon: _working
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_icon),
                label: Text(_working ? 'Processing...' : _buttonText()),
              ),
            ),

            if (_outputPath != null) ...[
              const SizedBox(height: 20),
              _resultCard(),
            ],
          ],
        ),
      ),
    );
  }

  String _buttonText() {
    switch (widget.tool) {
      case PdfAdvancedTool.merge:
        return 'Merge PDFs';
      case PdfAdvancedTool.split:
        return 'Split PDF';
      case PdfAdvancedTool.compress:
        return 'Compress PDF';
      case PdfAdvancedTool.sign:
        return 'Apply Signature';
      case PdfAdvancedTool.unlock:
        return 'Unlock PDF';
      case PdfAdvancedTool.toJpg:
        return 'Convert to JPG';
    }
  }

  Widget _headerCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(_icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              widget.tool == PdfAdvancedTool.merge
                  ? 'Select PDF files'
                  : 'Select a PDF file',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              widget.tool == PdfAdvancedTool.merge
                  ? 'Choose 2 or more PDFs in the order you want.'
                  : 'Choose a PDF from your device.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _working ? null : _pickFiles,
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('Choose PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected files (${_files.length})',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(_files.length, (index) {
              final name = _files[index].split(Platform.pathSeparator).last;

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  onPressed: _working ? null : () => _removeFile(index),
                  icon: const Icon(Icons.close_rounded),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _splitControls() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Page range',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 6),
            if (_pageCount != null)
              Text(
                'PDF contains $_pageCount pages',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Start page'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _endController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'End page'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Current PDF password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
      ),
    );
  }

  Widget _signatureCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Draw your signature',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _working ? null : _signatureController.clear,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard() {
    final fileName = _outputPath!.split(Platform.pathSeparator).last;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 8),
            const Text(
              'Completed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              fileName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openOutput,
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareOutput,
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _deleteOutput,
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete output'),
            ),
          ],
        ),
      ),
    );
  }
}
