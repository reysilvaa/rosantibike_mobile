import 'package:intl/intl.dart';

/// Utility class for date formatting
class DateFormatUtils {
  /// Format a [DateTime] object to Indonesian date format: "dd MMMM yyyy".
  static String formatTanggalIndonesia(DateTime date) {
    return DateFormat("dd MMMM yyyy", "id_ID").format(date);
  }

  /// Format a [DateTime] object to a shorter Indonesian date format: "dd/MM/yyyy".
  static String formatTanggalPendek(DateTime date) {
    return DateFormat("dd/MM/yyyy", "id_ID").format(date);
  }

  /// Parse a date string and return it in Indonesian format (for ISO strings).
  static String parseAndFormatTanggal(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return formatTanggalIndonesia(date);
    } catch (e) {
      return "Invalid date"; // Fallback for parsing errors
    }
  }
}
