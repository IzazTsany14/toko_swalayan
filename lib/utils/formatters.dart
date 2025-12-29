import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  static String formatNumber(int value) {
    return NumberFormat('#,##0', 'id_ID').format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm', 'id_ID').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy - HH:mm', 'id_ID').format(dateTime);
  }

  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
}
