import 'package:intl/intl.dart';

/// Utility class for date formatting
class DateFormatUtils {
  /// Format a [DateTime] object to Indonesian date format with time: "dd MMMM yyyy HH:mm".
  static String formatTanggalIndonesiaWithTime(DateTime date) {
    return DateFormat("dd MMMM yyyy HH:mm", "id_ID").format(date);
  }

  /// Format a [DateTime] object to a shorter Indonesian date format: "dd/MM/yyyy".
  static String formatTanggalPendek(DateTime date) {
    return DateFormat("dd MMMM yyyy", "id_ID").format(date);
  }

  static String formatJam(DateTime date) {
    try {
      print(date); // Menampilkan nilai DateTime untuk pengecekan
      return DateFormat("HH:mm", "id_ID").format(date);
    } catch (e) {
      return "Invalid time format";
    }
  }

  /// Parse a date string and return it in Indonesian format (for ISO strings) with time.
  static String parseAndFormatTanggalWithTime(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return formatTanggalIndonesiaWithTime(date);
    } catch (e) {
      return "Invalid date"; // Fallback for parsing errors
    }
  }
}
