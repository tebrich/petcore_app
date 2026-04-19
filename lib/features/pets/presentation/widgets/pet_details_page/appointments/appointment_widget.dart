import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds a widget that displays a summary card for a single appointment. 🗓️
///
/// This widget is designed to be used in lists, such as on the "Appointments"
/// tab of the `PetDetailsPage`. It presents key information about an appointment
/// in a visually appealing and compact format.
///
/// The card includes a colored icon representing the appointment type, the title,
/// the formatted date and time, and the location.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
///   - `appointmentDetails`: A map containing all the necessary details for the appointment.
Widget appointmentwidget(
  BuildContext context,
  Size screenSize,
  Map<String, dynamic> appointmentDetails,
) {
  return Material(
    elevation: 2,
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    child: ListTile(
      /// The background color of the tile.
      tileColor: AppPalette.surfaces(context).withValues(alpha: .25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),

      /// The leading widget, which displays a colored circle with an icon.
      /// The icon can be either an `IconData` or an SVG asset.
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appointmentDetails['color'].withValues(alpha: 0.25),
        ),
        padding: EdgeInsets.all(8),
        child: appointmentDetails['icon'] is IconData
            ? Icon(
                appointmentDetails['icon'],
                size: 25,
                color: appointmentDetails['color'](alpha: .75),
              )
            : SvgPicture.asset(appointmentDetails['icon'], height: 35),
      ),

      /// The title of the appointment.
      title: Text(
        appointmentDetails['title'],
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 16,
          color: AppPalette.textOnSecondaryBg(context),
          fontWeight: FontWeight.w600, // Medium
        ),
        textAlign: TextAlign.start,
      ),

      /// The subtitle, which uses a `Text.rich` widget to display the
      /// date, time, and location with corresponding icons.
      subtitle: Padding(
        padding: EdgeInsets.only(top: VerticalSpacing.sm(context).spacing),
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    FontAwesomeIcons.clock,
                    size: 13,
                    color: AppPalette.secondaryText(context),
                  ),
                ),
              ),
              TextSpan(
                /// Dynamically formats the date and time from the appointment details.
                text:
                    "${DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(appointmentDetails['date'])}\n",
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppPalette.secondaryText(context),
                  fontSize: 14,
                ),
              ),

              WidgetSpan(
                alignment: ui.PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    FontAwesomeIcons.mapLocationDot,
                    size: 13,
                    color: AppPalette.secondaryText(context),
                  ),
                ),
              ),
              TextSpan(
                text: appointmentDetails['location'],
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppPalette.secondaryText(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
