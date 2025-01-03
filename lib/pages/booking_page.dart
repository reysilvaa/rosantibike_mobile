import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/pages/in_app_web_view.dart';
import 'package:rosantibike_mobile/widgets/booking/booking_card.dart';
import 'package:rosantibike_mobile/widgets/booking/search_bar.dart';
import 'package:rosantibike_mobile/widgets/loading/shimmer_loading.dart';
import '../theme/theme_provider.dart';
import '../blocs/booking/booking_bloc.dart';
import '../blocs/booking/booking_event.dart';
import '../blocs/booking/booking_state.dart';
import '../constants/currency_format.dart';
import '../constants/date_format.dart';
import '../widgets/header_widget.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late BookingBloc _bookingBloc;

  @override
  void initState() {
    super.initState();
    _bookingBloc = BlocProvider.of<BookingBloc>(context);
    _bookingBloc.add(FetchBookings());
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
              HeaderWidget(title: 'Booking'),
              const SizedBox(height: 20),
              const BookingSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _bookingBloc.add(FetchBookings());
                  },
                  child: BlocConsumer<BookingBloc, BookingState>(
                    listener: (context, state) {
                      if (state is BookingError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is BookingLoading) {
                        return const ShimmerLoading();
                      }

                      if (state is BookingError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }

                      if (state is BookingLoaded) {
                        if (state.bookings.isEmpty) {
                          return const Center(
                              child: Text('Booking tidak ditemukan.'));
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.bookings.length,
                          itemBuilder: (context, index) {
                            final booking = state.bookings[index];

                            return BookingCard(
                              bookingId: booking.id.toString(),
                              customer: booking.namaPenyewa,
                              nopol: booking.nopol,
                              dateSewa: DateFormatUtils.formatTanggalPendek(
                                DateTime.parse(booking.tglSewa),
                              ),
                              dateKembali: DateFormatUtils.formatTanggalPendek(
                                DateTime.parse(booking.tglKembali),
                              ),
                              jamSewa: DateFormatUtils.formatJam(
                                DateTime.parse(booking.tglSewa),
                              ),
                              jamKembali: DateFormatUtils.formatJam(
                                DateTime.parse(booking.tglKembali),
                              ),
                              total: formatCurrency(booking.total),
                              motorType: booking.jenisMotor.stok.merk,
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
