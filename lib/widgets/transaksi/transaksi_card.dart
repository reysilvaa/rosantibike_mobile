import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_event.dart';
import 'package:rosantibike_mobile/constants/page_transition.dart';
import 'package:rosantibike_mobile/constants/snackbar_utils.dart';

import 'package:rosantibike_mobile/pages/transaksi_booking_detail/details_page.dart';

class TransaksiCard extends StatelessWidget {
  final String transaksiId;
  final String customer;
  final String nopol;
  final String dateSewa;
  final String dateKembali;
  final String jamSewa;
  final String jamKembali;
  final String total;
  final String motorType;

  const TransaksiCard({
    Key? key,
    required this.transaksiId,
    required this.customer,
    required this.nopol,
    required this.dateSewa,
    required this.jamSewa,
    required this.jamKembali,
    required this.total,
    required this.motorType,
    required this.dateKembali,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(transaksiId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Gunakan Bloc untuk memanggil event hapus transaksi
        context
            .read<TransaksiBloc>()
            .add(DeleteTransaksi(int.parse(transaksiId)));
        SnackBarHelper.showSuccessSnackBar(
          context,
          'Berhasil menghapus Transaksi',
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Motor sudah kembali',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        color: theme.cardColor,
        shadowColor: theme.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              RightToLeftTransition(
                page: DetailsPage(
                  id: transaksiId,
                  type: 'transaksi',
                  bookingId: transaksiId,
                  customer: customer,
                  nopol: nopol,
                  dateSewa: dateSewa,
                  dateKembali: dateKembali,
                  jamKembali: jamKembali,
                  jamSewa: jamSewa,
                  total: total,
                ), // Navigasi dengan transisi geser dan data yang diteruskan
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            motorType,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        total,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: theme.dividerColor.withOpacity(0.2)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined,
                        size: 16,
                        color: theme.iconTheme.color?.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Text(
                      'ID: $transaksiId',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined,
                        size: 16,
                        color: theme.iconTheme.color?.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Text(
                      'Nopol: $nopol',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16,
                        color: theme.iconTheme.color?.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sewa: $dateSewa',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          'Jam: $jamSewa',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16,
                        color: theme.iconTheme.color?.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kembali: $dateKembali',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          'Jam: $jamKembali',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
