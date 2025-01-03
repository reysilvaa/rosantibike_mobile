// booking_page.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/widgets/booking/booking_card.dart';
import 'package:rosantibike_mobile/widgets/booking/search_bar.dart';
import 'package:rosantibike_mobile/widgets/loading/shimmer_loading.dart';
import '../theme/theme_provider.dart';
import '../blocs/booking/booking_bloc.dart';
import '../blocs/booking/booking_event.dart';
import '../blocs/booking/booking_state.dart';
import '../constants/currency_format.dart';
import '../constants/date_format.dart';

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
    _bookingBloc = context.read<BookingBloc>();
    _bookingBloc.add(FetchBookings());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Booking Analytics',
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
                              child: Text('No bookings found.'));
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.bookings.length,
                          itemBuilder: (context, index) {
                            final booking = state.bookings[index];
                            print(
                                'Booking ${booking.id} - Nopol: ${booking.nopol}');

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
          // Add new booking logic
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
