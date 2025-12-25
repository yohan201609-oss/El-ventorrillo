import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _pesosFormat = NumberFormat.currency(
    symbol: 'RD\$',
    decimalDigits: 0,
    locale: 'es_DO',
    customPattern: 'RD\$ #,##0',
  );

  static String format(int amount) {
    return _pesosFormat.format(amount);
  }

  static String formatWithDecimals(double amount) {
    return NumberFormat.currency(
      symbol: 'RD\$',
      decimalDigits: 2,
      locale: 'es_DO',
      customPattern: 'RD\$ #,##0.00',
    ).format(amount);
  }
}

