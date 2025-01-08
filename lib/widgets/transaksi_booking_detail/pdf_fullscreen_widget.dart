import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:photo_view/photo_view.dart';

class PdfFullscreenViewer extends StatelessWidget {
  final Uint8List pdfData;

  const PdfFullscreenViewer({
    Key? key,
    required this.pdfData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pratinjau',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Stack(
        children: [
          PhotoView.customChild(
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            child: PdfPreview(
              build: (_) async => pdfData,
              initialPageFormat: PdfPageFormat.a4,
              canChangePageFormat: false,
              canChangeOrientation: false,
              allowPrinting: false,
              allowSharing: false,
              maxPageWidth: MediaQuery.of(context).size.width,
              pdfPreviewPageDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
