// ---------------------------------------------------------------------------
// File: notification_icons_getter.dart
// Description:
// Provides helper functions that return the appropriate SVG icon widget
// based on a given notification or appointment type.
//
// These utilities are used to dynamically display icons in alert lists,
// notification centers, or appointment-related UIs, ensuring that each
// alert type has a consistent and meaningful visual representation.
//
// The logic uses a simple `switch` statement to map predefined alert or
// appointment types to SVG assets located in the `assets/illustrations`
// directory.
//
// Example usage:
// ```dart
// // Inside a notification card
// Widget icon = alertsIconGetter('warning');
//
// // Inside an appointment list
// Widget icon = appointmentsIconGetter('vet_appointment');
// ```
//
// ⚠️ Note:
// - This file is part of the **UI kit**, so icons are statically mapped.
// - In a production app, you could replace this with a more flexible
//   configuration (e.g., a backend-driven icon registry or metadata system).
// - If you add new notification types or appointment categories, make sure
//   to update these functions accordingly.
//
// Dependencies:
// - [flutter_svg] → For rendering SVG illustrations.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Returns the appropriate SVG icon for a given **alert** type.
///
/// Supported alert types include:
/// - `'hydratation'`, `'profile_pic'`, `'vet_availability'`, `'event'`, `'summary'`,
///   `'out_of_food'`, `'tip'`, `'weight_check'`, `'groom_tip'`, `'update'`,
///   `'pet_of_month'`, `'warning'`, `'photos_event'`, `'food_reminder'`,
///   `'announcement'`, `'test results'`.
///
/// If an unrecognized type is provided, a default notification bell icon is used.
Widget alertsIconGetter(String alertType) {
  switch (alertType) {
    case 'hydratation':
      return SvgPicture.asset(
        "assets/illustrations/hydration.svg",
        height: 30,
        width: 30,
      );

    case 'profile_pic':
      return SvgPicture.asset(
        "assets/illustrations/pet_profile_pic.svg",
        height: 45,
        width: 45,
      );

    case 'vet_availability':
      return SvgPicture.asset(
        "assets/illustrations/phone.svg",
        height: 30,
        width: 30,
      );

    case 'event':
      return SvgPicture.asset(
        "assets/illustrations/star_calendar.svg",
        height: 37.5,
        width: 37.5,
      );

    case 'summary':
      return SvgPicture.asset(
        "assets/illustrations/stats.svg",
        height: 35,
        width: 35,
      );

    case 'out_of_food':
      return SvgPicture.asset(
        "assets/illustrations/food_bag.svg",
        height: 37.5,
        width: 37.5,
      );
    case 'tip':
      return SvgPicture.asset(
        "assets/illustrations/tips.svg",
        height: 37.5,
        width: 37.5,
      );
    case 'weight_check':
      return SvgPicture.asset(
        "assets/illustrations/pet_scale.svg",
        height: 35,
        width: 35,
      );
    case 'groom_tip':
      return SvgPicture.asset(
        "assets/illustrations/grooming_tools.svg",
        height: 35,
        width: 35,
      );

    case 'update':
      return SvgPicture.asset(
        "assets/illustrations/new_offer_megaphone.svg",
        height: 37.5,
        width: 37.5,
      );
    case 'pet_of_month':
      return SvgPicture.asset(
        "assets/illustrations/badge.svg",
        height: 37.5,
        width: 37.5,
      );

    case 'warning':
      return SvgPicture.asset(
        "assets/illustrations/warning.svg",
        height: 37.5,
        width: 37.5,
      );
    case 'photos_event':
      return SvgPicture.asset(
        "assets/illustrations/camera_hourglass.svg",
        height: 37.5,
        width: 37.5,
      );

    case 'food_reminder':
      return SvgPicture.asset(
        "assets/illustrations/empty_bawl.svg",
        height: 37.5,
        width: 37.5,
      );
    case 'announcement':
      return SvgPicture.asset(
        "assets/illustrations/megaphone.svg",
        height: 37.5,
        width: 37.5,
      );

    case 'test results':
      return SvgPicture.asset(
        "assets/illustrations/blood_tests_results.svg",
        height: 35,
        width: 35,
      );
    default:
      return SvgPicture.asset(
        "assets/illustrations/notification_bell.svg",
        height: 30,
        width: 30,
      );
  }
}

/// Returns the appropriate SVG icon for a given **appointment** type.
///
/// Supported appointment types include:
/// - `'vet_appointment'`, `'dent_appointment'`, `'vet_surgery'`, `'spa_appointment'`,
///   `'vaccination'`, `'skin_vet'`, `'ortho_vet'`, `'orl_vet'`.
///
/// If an unrecognized type is provided, a default notification bell icon is used.
Widget appointmentsIconGetter(String alertType) {
  switch (alertType) {
    case 'vet_appointment':
      return SvgPicture.asset(
        "assets/illustrations/vet_appointment.svg",
        height: 35,
        width: 35,
      );

    case 'dent_appointment':
      return SvgPicture.asset(
        "assets/illustrations/dental_appointment.svg",
        height: 35,
        width: 35,
      );

    case 'vet_surgery':
      return SvgPicture.asset(
        "assets/illustrations/surgery_appointment.svg",
        height: 35,
        width: 35,
      );

    case 'spa_appointment':
      return SvgPicture.asset(
        "assets/illustrations/spa_appointment.svg",
        height: 35,
        width: 35,
      );

    case 'vaccination':
      return SvgPicture.asset(
        "assets/illustrations/vaccine_appointment.svg",
        height: 35,
        width: 35,
      );

    case 'skin_vet':
      return SvgPicture.asset(
        "assets/illustrations/skin_vet_appointment.svg",
        height: 35,
        width: 35,
      );
    case 'ortho_vet':
      return SvgPicture.asset(
        "assets/illustrations/ortho_vet_eppointment.svg",
        height: 35,
        width: 35,
      );
    case 'orl_vet':
      return SvgPicture.asset(
        "assets/illustrations/orl_vet_appointment.svg",
        height: 35,
        width: 35,
      );
    default:
      return SvgPicture.asset(
        "assets/illustrations/notification_bell.svg",
        height: 30,
        width: 30,
      );
  }
}
