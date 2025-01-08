import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_event.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_state.dart';
import 'package:rosantibike_mobile/constants/snackbar_utils.dart';
import 'package:rosantibike_mobile/pages/in_app_web_view.dart';
import 'package:rosantibike_mobile/widgets/transaksi/search_bar.dart';
import 'package:rosantibike_mobile/widgets/loading/shimmer_loading.dart';
import 'package:rosantibike_mobile/widgets/transaksi/transaksi_card.dart';
import '../theme/theme_provider.dart';
import '../constants/currency_format.dart';
import '../constants/date_format.dart';
import '../widgets/header_widget.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(title: 'Transaksi'),
              const SizedBox(height: 20),
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
                        SnackBarHelper.showErrorSnackBar(
                            context, 'Mencoba memuat data...');
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InAppBrowserWidget(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
