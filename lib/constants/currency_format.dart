// lib/utils/currencyformat.dart

import 'package:intl/intl.dart';

// Helper function to format price in Indonesian currency format
String formatCurrency(String price) {
  final priceValue = double.tryParse(price) ?? 0.0; // Safely parse as double

  // Format the value as currency (without decimal places)
  final formattedPrice = NumberFormat.currency(
    locale: 'id_ID', // Indonesian locale
    symbol: 'Rp ',
    decimalDigits: 0, // No decimal part
  ).format(priceValue); // Use double for proper formatting

  return formattedPrice;
}
