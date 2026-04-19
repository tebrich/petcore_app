import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds a widget that displays a summary of the pet's sleep record. 😴
///
/// This widget is a component of the "Health" tab in the `PetDetailsPage`.
/// It presents a visual trend of the pet's sleep hours over the last week
/// using a `BarChart` from the `fl_chart` package.
///
/// Key features include:
/// - A clear "Sleep Record" title with a corresponding icon.
/// - A display of the average daily sleep time calculated from the data.
/// - A minimalist bar chart showing the sleep hours for each day of the week.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
Widget petSleepRecordWidget(BuildContext context, Size screenSize) {
  /// A hardcoded map of sleep hours for the last 7 days.
  /// In a real app, this data would be fetched from a database or health service.
  Map<String, int> sleepRecordLastWeek = {
    "Dom": 5,
    "Lun": 7,
    "Mar": 6,
    "Mié": 7,
    "Jue": 5,
    "Vie": 7,
    "Sáb": 4,
  };

  /// Calculates the average sleep time in minutes over the week.
  final double averageTimeInMins =
      sleepRecordLastWeek.values.reduce((a, b) => a + b) * 60 / 7;
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
        color: AppPalette.secondary(context).withValues(alpha: .25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            /// The header row containing the title and icon.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Registro de Sueño',
                  style: AppTextStyles.bodyRegular.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  "assets/illustrations/sleep.svg",
                  height: 40,
                  colorFilter: ColorFilter.mode(
                    AppPalette.secondary(context),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ],
          ),

          /// Displays the calculated average sleep time, formatted into hours and minutes.
          Text(
            "Promedio: ${(averageTimeInMins / 60).toInt()}h ${(averageTimeInMins - (60 * (averageTimeInMins / 60).toInt())).toInt()}mins ",
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 12,
            ),
          ),

          /// Vertical spacing for visual separation.
          VerticalSpacing.md(context),

          /// The bar chart widget for visualizing sleep data.
          SizedBox(
            height: 75,
            child: BarChart(
              duration: const Duration(milliseconds: 300),
              BarChartData(
                /// Sets the vertical range of the chart, with a buffer of 1 hour
                /// above the max value for better visual spacing.
                maxY: sleepRecordLastWeek.values.reduce(max) + 1,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 2.0,

                  /// Styles the horizontal grid lines.
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    /// Configures the titles on the left (Y-axis).
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10,
                      interval: 2.0,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    /// Configures the titles on the bottom (X-axis), showing the first letter of each day.
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        sleepRecordLastWeek.keys.elementAt(value.toInt())[0],
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),

                /// Generates the bar groups (the actual bars) from the `sleepRecordLastWeek` map.
                barGroups: List.generate(
                  sleepRecordLastWeek.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: sleepRecordLastWeek.values
                            .elementAt(index)
                            .toDouble(),
                        color: AppPalette.secondary(context),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
