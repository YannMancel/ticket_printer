import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage(
    pdf.Document document, {
    super.key,
  }) : _document = document;

  final pdf.Document _document;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<pdf.Document>('document', _document),
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
        build: (_) => _document.save(),
      ),
    );
  }
}
