import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage(
    pw.Document document, {
    super.key,
  }) : _document = document;

  final pw.Document _document;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<pw.Document>('document', _document),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (format) => _document.save(),
      ),
    );
  }
}
