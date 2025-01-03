import 'package:flutter/material.dart';
import 'info_row.dart';

class DetailsCard extends StatelessWidget {
  final String bookingId;
  final String customer;
  final String nopol;
  final String dateSewa;
  final String dateKembali;
  final String jamSewa;
  final String jamKembali;
  final String total;

  const DetailsCard({
    Key? key,
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
  Widget build(BuildContext context) {
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
              InfoRow(icon: Icons.person, label: 'Customer', value: customer),
              InfoRow(icon: Icons.directions_car, label: 'Nopol', value: nopol),
              InfoRow(
                  icon: Icons.calendar_today, label: 'Sewa Date', value: dateSewa),
              InfoRow(icon: Icons.watch_later, label: 'Jam Sewa', value: jamSewa),
              InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Kembali Date',
                  value: dateKembali),
              InfoRow(
                  icon: Icons.watch_later,
                  label: 'Jam Kembali',
                  value: jamKembali),
              InfoRow(icon: Icons.attach_money, label: 'Total', value: total),
            ],
          ),
        ),
      ),
    );
  }
}
