import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DetailsPage extends StatelessWidget {
  final String bookingId;
  final String customer;
  final String dateSewa;
  final String dateKembali;
  final String jamSewa;
  final String jamKembali;
  final String total;

  const DetailsPage({
    Key? key,
    required this.bookingId,
    required this.customer,
    required this.dateSewa,
    required this.dateKembali,
    required this.jamKembali,
    required this.jamSewa,
    required this.total,
  }) : super(key: key);

  Future<void> _downloadInvoice() async {
    final pdf = await _generateInvoicePdf();
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/Invoice-$bookingId.pdf');
    await file.writeAsBytes(await pdf.save());
    // You can implement your own download handling here
  }

  Future<pw.Document> _generateInvoicePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Booking ID: $bookingId'),
            pw.Text('Customer: $customer'),
            pw.Text('Sewa Date: $dateSewa'),
            pw.Text('Kembali Date: $dateKembali'),
            pw.Text('Total: $total'),
          ],
        ),
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadInvoice,
            tooltip: 'Download Invoice',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailsCard(context),
            const SizedBox(height: 16),
            _buildPdfPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Details',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: $bookingId',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.receipt_long,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildInfoRow(
                context,
                Icons.person,
                'Customer',
                customer,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Sewa Date',
                dateSewa,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Jam Sewa',
                jamSewa,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Kembali Date',
                dateKembali,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Jam Kembali',
                jamKembali,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.attach_money,
                'Total Amount',
                total,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPdfPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Invoice Preview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 500,
          child: PdfPreview(
            build: (format) => _generateInvoicePdf().then((pdf) => pdf.save()),
            initialPageFormat: PdfPageFormat.a4,
            canChangePageFormat: false,
            canChangeOrientation: false,
            allowPrinting: false,
            allowSharing: false,
          ),
        ),
      ],
    );
  }
}
