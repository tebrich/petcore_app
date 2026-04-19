import 'package:intl/intl.dart';

/// Formats a [DateTime] into a short, user-friendly string.
///
/// - If the date is **within the last 24 hours**, it shows only the time (`HH:mm`)
/// - If the date is **within the last 7 days**, it shows the day abbreviation + time (`EEE\nHH:mm`)
/// - Otherwise, it shows the **month and day** (`MMM dd`)
///
/// This keeps displayed dates clean and context-aware for UI elements like
/// notifications, messages, or activity logs.
String dateFormatter(DateTime date) {
  final difference = DateTime.now().difference(date).inDays;

  if (difference <= 1) {
    return DateFormat('HH:mm').format(date);
  } else if (difference <= 7) {
    return DateFormat('EEE\nHH:mm').format(date);
  } else {
    return DateFormat('MMM dd').format(date);
  }
}
