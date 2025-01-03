import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';

class PdfPreviewWidget extends StatefulWidget {
  final Future<Uint8List> invoicePdf;

  const PdfPreviewWidget({
    Key? key,
    required this.invoicePdf,
  }) : super(key: key);

  @override
  State<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends State<PdfPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCustomToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildToolbarButton(
            context,
            icon: Icons.print_rounded,
            label: 'Print',
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (_) async => await widget.invoicePdf,
              );
            },
          ),
          const SizedBox(width: 12),
          _buildToolbarButton(
            context,
            icon: Icons.share_rounded,
            label: 'Bagikan',
            onPressed: () async {
              final data = await widget.invoicePdf;
              await Printing.sharePdf(bytes: data);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isError = false;
                _errorMessage = '';
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Proses Bos...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Pratinjau Bukti',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCustomToolbar(context),
          ),
          SizedBox(
            height: 500,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FutureBuilder<Uint8List>(
                  future: widget.invoicePdf,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingWidget();
                    } else if (snapshot.hasError || _isError) {
                      return _buildErrorWidget(
                        _errorMessage.isNotEmpty
                            ? _errorMessage
                            : 'Failed to load PDF. Please try again.',
                      );
                    } else {
                      return PdfPreview(
                        build: (_) async => snapshot.data!,
                        initialPageFormat: PdfPageFormat.a4,
                        canChangePageFormat: false,
                        canChangeOrientation: false,
                        allowPrinting: false,
                        allowSharing: false,
                        pdfPreviewPageDecoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        scrollViewDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
