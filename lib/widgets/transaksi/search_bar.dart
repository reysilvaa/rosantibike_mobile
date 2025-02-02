import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_event.dart';

class TransaksiSearchBar extends StatelessWidget {
  const TransaksiSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Transaksi...',
          hintStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.iconTheme.color),
        ),
        style: theme.textTheme.bodyLarge,
        onChanged: (value) {
          context.read<TransaksiBloc>().add(SearchTransaksi(value));
        },
      ),
    );
  }
}
