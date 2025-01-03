import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/theme/app_theme.dart';
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section with gradient background
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Details',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ID: $bookingId',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    'Informasi Penyewa',
                    [
                      InfoRow(
                        icon: Icons.person,
                        label: 'Nama Penyewa',
                        value: customer,
                      ),
                      InfoRow(
                        icon: Icons.directions_car,
                        label: 'No Plat',
                        value: nopol,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Rental Period',
                    [
                      InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Tgl. Sewa',
                        value: dateSewa,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                      InfoRow(
                        icon: Icons.watch_later,
                        label: 'Jam Sewa',
                        value: jamSewa,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                      InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Tgl. Kembali',
                        value: dateKembali,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                      InfoRow(
                        icon: Icons.watch_later,
                        label: 'Jam Kembali',
                        value: jamKembali,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InfoRow(
                      icon: Icons.attach_money,
                      label: 'Total',
                      value: total,
                      iconColor: Theme.of(context).primaryColor,
                      valueStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 12),
        ...children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: child,
            )),
      ],
    );
  }
}
