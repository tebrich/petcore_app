import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds a widget that displays a summary of the pet's blood pressure. 🩸
///
/// This widget is a component of the "Health" tab in the `PetDetailsPage`.
/// It presents a visual trend of the pet's blood pressure over a period
/// using a `LineChart` from the `fl_chart` package.
///
/// Key features include:
/// - A clear "Blood Pressure" title with a corresponding icon.
/// - A minimalist line chart showing the data trend.
/// - A display of the minimum and maximum recorded values (e.g., "125/140 mmHg").
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
Widget petBloodPressure(BuildContext context, Size screenSize) {
  /// A hardcoded list of blood pressure readings for demonstration purposes.
  /// In a real app, this data would be fetched from a database or health service.
  List<int> bloodPressure = [132, 128, 135, 140, 125, 138, 130];
  final int maxValue = bloodPressure.reduce(max);
  final int minValue = bloodPressure.reduce(min);
  return Container(
    // Outer container for shadow and border radius.
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: AppPalette.background(context),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Container(
      // Inner container for the colored background and content.
      width: screenSize.width * 0.425,
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppPalette.danger(context).withValues(alpha: .25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            /// The header row containing the title and icon.
            children: [
              Expanded(
                child: Text(
                  'Presion Arterial',
                  style: AppTextStyles.bodyRegular.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FaIcon(
                  FontAwesomeIcons.heartPulse,
                  color: AppPalette.danger(context),
                  size: 35,
                ),
              ),
            ],
          ),

          /// Vertical spacing for visual separation.
          VerticalSpacing.sm(context),

          /// The line chart widget for visualizing blood pressure data.
          SizedBox(
            height: 75,
            child: LineChart(
              duration: const Duration(milliseconds: 300),
              LineChartData(
                /// Sets the vertical range of the chart, with a 10-point buffer
                /// above and below the min/max values for better visual spacing.
                minY: minValue - 10,
                maxY: maxValue + 10,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),

                lineBarsData: [
                  /// Defines the properties of the line itself.
                  LineChartBarData(
                    isCurved: true,
                    dotData: FlDotData(show: false),

                    color: AppPalette.danger(context),
                    barWidth: 3.0,

                    /// Generates the data points (spots) for the chart from the `bloodPressure` list.
                    spots: List.generate(
                      bloodPressure.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        bloodPressure[index].toDouble(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          VerticalSpacing.sm(context),

          Text.rich(
            /// Displays the minimum and maximum blood pressure values in a "min/max mmHg" format.
            TextSpan(
              children: [
                TextSpan(
                  text: "$minValue/$maxValue",
                  style: AppTextStyles.bodyRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                  text: " mmHg",
                  style: AppTextStyles.bodyRegular.copyWith(
                    fontSize: 11,
                    color: AppPalette.secondaryText(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
