import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(
    dynamic number,
    int decimalDigit, {
    bool symbol = true,
  }) {
    num parsedNumber;

    if (number is num) {
      parsedNumber = number;
    } else if (number is String) {
      // Coba parse ke double
      parsedNumber = num.tryParse(number.replaceAll(',', '')) ?? 0;
    } else {
      parsedNumber = 0;
    }

    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: symbol ? 'Rp' : '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(parsedNumber);
  }
}
