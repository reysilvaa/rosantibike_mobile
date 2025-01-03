// booking_page.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_event.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_state.dart';
import 'package:rosantibike_mobile/widgets/transaksi/search_bar.dart';
import 'package:rosantibike_mobile/widgets/loading/shimmer_loading.dart';
import 'package:rosantibike_mobile/widgets/transaksi/transaksi_card.dart';
import '../theme/theme_provider.dart';
import '../constants/currency_format.dart';
import '../constants/date_format.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<TransaksiPage> {
  late TransaksiBloc _transaksiBloc;

  @override
  void initState() {
    super.initState();
    _transaksiBloc = context.read<TransaksiBloc>();
    _transaksiBloc.add(FetchTransaksi());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Transaksi Analytics',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              // Add filter logic
            },
          ),
        ],
        elevation: theme.appBarTheme.elevation,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const TransaksiSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _transaksiBloc.add(FetchTransaksi());
                  },
                  child: BlocConsumer<TransaksiBloc, TransaksiState>(
                    listener: (context, state) {
                      if (state is TransaksiError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is TransaksiLoading) {
                        return const ShimmerLoading();
                      }

                      if (state is TransaksiError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }

                      if (state is TransaksiLoaded) {
                        if (state.transaksis.isEmpty) {
                          return const Center(
                              child: Text('Transaksi tidak ditemukan.'));
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.transaksis.length,
                          itemBuilder: (context, index) {
                            final transaksi = state.transaksis[index];
                            print(
                                'Transaksi ${transaksi.id} - Nopol: ${transaksi.nopol}');

                            return TransaksiCard(
                              transaksiId: transaksi.id.toString(),
                              customer: transaksi.namaPenyewa,
                              nopol: transaksi.nopol,
                              dateSewa: DateFormatUtils.formatTanggalPendek(
                                DateTime.parse(transaksi.tglSewa),
                              ),
                              dateKembali: DateFormatUtils.formatTanggalPendek(
                                DateTime.parse(transaksi.tglKembali),
                              ),
                              jamSewa: DateFormatUtils.formatJam(
                                DateTime.parse(transaksi.tglSewa),
                              ),
                              jamKembali: DateFormatUtils.formatJam(
                                DateTime.parse(transaksi.tglKembali),
                              ),
                              total: formatCurrency(transaksi.total),
                              motorType: transaksi.jenisMotor.stok.merk,
                            );
                          },
                        );
                      }

                      return const ShimmerLoading();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new transaksi logic
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
