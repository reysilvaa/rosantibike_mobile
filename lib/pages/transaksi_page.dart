import 'package:flutter/material.dart';
import './transaksi/details_page.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, themeProvider),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: _buildBookingList(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new booking logic
        },
        child: const Icon(Icons.add),
        backgroundColor: theme.primaryColor,
        elevation: 4,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);

    return AppBar(
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
          onPressed: () {},
        ),
      ],
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
          hintText: 'Search bookings...',
          hintStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.iconTheme.color),
        ),
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildBookingList(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildBookingCard('12345', 'John Doe', '2024-12-30', '\$150.00',
            'Yamaha NMAX', context),
        _buildBookingCard('12346', 'Jane Smith', '2024-12-29', '\$120.00',
            'Honda PCX', context),
        _buildBookingCard('12347', 'Alice Brown', '2024-12-28', '\$180.00',
            'Vespa Sprint', context),
        _buildBookingCard('12348', 'Bob White', '2024-12-27', '\$200.00',
            'Honda ADV', context),
      ],
    );
  }

  Widget _buildBookingCard(String bookingId, String customer, String date,
      String total, String motorType, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                bookingId: bookingId,
                customer: customer,
                date: date,
                total: total,
              ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.confirmation_number_outlined,
                          size: 16,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      const SizedBox(width: 8),
                      Text(
                        'ID: $bookingId',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
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
    );
  }
}
