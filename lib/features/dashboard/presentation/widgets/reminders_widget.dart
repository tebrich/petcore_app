import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';

/// A widget function that builds the "Upcoming Events" section for the dashboard.
///
/// This function constructs a decorated `Container` that houses a `ListView`
/// of upcoming reminders or events. It is designed to provide a quick overview
/// of future tasks.
///
/// [context] The build context.
/// [listOfReminders] A list of maps, where each map contains the data for a single reminder.
///
/// > **Note:** This widget currently uses `DummyData` for demonstration. In a
/// production app, the list of reminders should be fetched from a data source.
///
/// > **Refactoring Note:** The `listOfReminders` parameter should be updated to
/// accept a `List` of a strongly-typed `Reminder` model object instead of `Map`
/// for better type safety and maintainability.
Widget remindersWidget(
  BuildContext context,
  List<Map<String, dynamic>> listOfReminders,
) {
  Size screenSize = MediaQuery.of(context).size;
  return Container(
    width: screenSize.width * 0.9,
    margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: AppPalette.background(context),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listOfReminders.length,
      itemBuilder: (context, index) =>
          activityTile(context, listOfReminders[index], index),
    ),
  );
}

/// Builds a single `ListTile` for an upcoming event or reminder.
///
/// This private helper widget constructs the UI for one reminder, including its
/// icon, title, time, and date. The background color of the icon is selected
/// randomly for visual variety.
///
/// [context] The build context.
/// [reminderDetails] A map containing the data for the reminder item.
/// [index] The index of the item in the list.
Widget activityTile(
  BuildContext context,
  Map<String, dynamic> reminderDetails,
  int index,
) {
  // The icon background color is randomized for UI variety.
  return ListTile(
    contentPadding: EdgeInsets.zero,
    minTileHeight: 45,
    dense: true,
    leading: Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: [
          AppPalette.primary,
          AppPalette.secondary(context),
          AppPalette.danger(context),
          AppPalette.success(context),
          AppPalette.warning(context),
        ].elementAt(Random().nextInt(5)).withValues(alpha: 0.4),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: EdgeInsets.only(bottom: 5),
      child: SvgPicture.asset(reminderDetails['icon'], height: 30),
    ),
    title: Text(
      reminderDetails['title'],
      style: AppTextStyles.bodyRegular.copyWith(
        fontSize: 14,
        color: AppPalette.primaryText(context),
      ),
    ),
    subtitle: Text(
      reminderDetails['time'] ?? '(-)',
      style: AppTextStyles.bodyRegular.copyWith(
        color: AppPalette.disabled(context),
        fontSize: 11,
      ),
    ),
    trailing: Text(
      reminderDetails['date'],
      style: AppTextStyles.bodyRegular.copyWith(
        color: AppPalette.secondaryText(context),
        fontSize: 12.5,
      ),
    ),
  );
}
