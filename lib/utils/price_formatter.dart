import 'package:intl/intl.dart';

class PriceFormatter {

  static String formatGs(
    double amount,
  ) {

    final formatter = NumberFormat(
      '#,###',
      'es_PY',
    );

    return 'Gs ${formatter.format(amount)}'
        .replaceAll(',', '.');
  }
}
