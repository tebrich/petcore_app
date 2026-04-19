// ---------------------------------------------------------------------------
// File: random_functions.dart
// Description:
// Contains utility functions for generating random values, such as dates,
// used primarily for mock data, testing, or demonstration purposes.
//
// ---------------------------------------------------------------------------

import 'dart:math';

// Generates a random [DateTime] within the last six months.
//
// This function is useful for creating mock or sample data — for example,
// when displaying randomized timestamps for activity feeds, reminders,
// or logs in demo environments.
//
// The generated date includes random days, hours, minutes, and seconds
// for added realism.
//
// Example usage:
// ```dart
// final randomDate = getRandomDateTimeLast6Months();
// print(randomDate); // e.g., 2025-06-23 14:37:12
// ```
DateTime getRandomDateTimeLast6Months() {
  final now = DateTime.now();
  final sixMonthsAgo = now.subtract(const Duration(days: 180)); // ~6 months

  final random = Random();
  final randomDays = random.nextInt(180); // Within 6 months
  final randomHours = random.nextInt(24);
  final randomMinutes = random.nextInt(60);
  final randomSeconds = random.nextInt(60);

  return sixMonthsAgo.add(
    Duration(
      days: randomDays,
      hours: randomHours,
      minutes: randomMinutes,
      seconds: randomSeconds,
    ),
  );
}
