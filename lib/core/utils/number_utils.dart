import 'package:intl/intl.dart';

class NumberUtils {
  static String currencyFormatter(double value) {
    if (value % 1 == 0) {
      return NumberFormat("#,##0", "en_PH").format(value);
    } else {
      return NumberFormat("#,##0.00", "en_PH").format(value);
    }
  }

  static double parseAmount(String value) {
    final cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}