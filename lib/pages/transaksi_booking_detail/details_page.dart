import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert'; // Untuk decoding Base64
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rosantibike_mobile/widgets/transaksi_booking_detail/details_card.dart';
import 'package:rosantibike_mobile/widgets/transaksi_booking_detail/pdf_preview_widget.dart';
import 'dart:io';

class DetailsPage extends StatefulWidget {
  final String type;
  final String id;
  final String bookingId;
  final String customer;
  final String nopol;
  final String dateSewa;
  final String dateKembali;
  final String jamSewa;
  final String jamKembali;
  final String total;

  const DetailsPage({
    Key? key,
    required this.type,
    required this.id,
    required this.bookingId,
    required this.customer,
    required this.nopol,
    required this.dateSewa,
    required this.dateKembali,
    required this.jamSewa,
    required this.jamKembali,
    required this.total,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Uint8List> invoicePdf;

  @override
  void initState() {
    super.initState();
    invoicePdf = fetchInvoicePdf();
  }

  Future<Uint8List> fetchInvoicePdf() async {
    final response = await http.get(
      Uri.parse(
          'https://rosantibikemotorent.com/api/invoice/preview/${widget.type}/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('pdf_base64')) {
        return base64Decode(responseBody['pdf_base64']);
      } else {
        throw Exception('PDF data not found in response');
      }
    } else {
      throw Exception('Failed to load invoice PDF');
    }
  }

  Future<void> _downloadInvoice() async {
    final response = await http.get(
      Uri.parse(
          'https://rosantibikemotorent.com/api/invoice/download/${widget.type}/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/Invoice-${widget.bookingId}.pdf');
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice downloaded to ${file.path}')),
      );
    } else {
      throw Exception('Failed to download invoice');
    }
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
            DetailsCard(
              bookingId: widget.bookingId,
              customer: widget.customer,
              nopol: widget.nopol,
              dateSewa: widget.dateSewa,
              dateKembali: widget.dateKembali,
              jamSewa: widget.jamSewa,
              jamKembali: widget.jamKembali,
              total: widget.total,
            ),
            const SizedBox(height: 16),
            PdfPreviewWidget(invoicePdf: invoicePdf),
          ],
        ),
      ),
    );
  }
}
