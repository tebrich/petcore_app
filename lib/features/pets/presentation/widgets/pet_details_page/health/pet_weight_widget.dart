import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A widget that displays a pet's weight trend over a selectable period. ⚖️
///
/// This stateful widget is a key component of the "Health" tab in the
/// `PetDetailsPage`. It visualizes a pet's weight data using a `LineChart`
/// from the `fl_chart` package.
///
/// Users can switch between different time periods (e.g., "Week", "Month")
/// via a dropdown menu to see historical weight trends. The chart is interactive,
/// showing a tooltip with the exact weight when a data point is touched.
class PetWeightWidget extends StatefulWidget {
  const PetWeightWidget({super.key});

  @override
  State<PetWeightWidget> createState() => _PetWeightWidgetState();
}

/// The state for the [PetWeightWidget].
///
/// Manages the selected time period and builds the UI, including the
/// interactive line chart.
class _PetWeightWidgetState extends State<PetWeightWidget> {
  /// The currently selected time period for the weight report.
  /// Defaults to "Week".
  String selectedPeriod = "Week";
  @override
  /// Builds the main UI for the weight report widget.
  Widget build(BuildContext context) {
    /// A hardcoded map of weight data for the last 7 days.
    ///
    /// TODO: This data is static. In a real app, this should be replaced with a
    /// dynamic data source that fetches weight records based on the `selectedPeriod`.
    Map<String, double> weightList = {
      "Dom": 3.9,
      "Lun": 4.0,
      "Mar": 4.1,
      "Mié": 4.0,
      "Jue": 4.2,
      "Vie": 4.1,
      "Sáb": 4.0,
    };
    Size screenSize = MediaQuery.of(context).size;
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
        width: screenSize.width * 0.9,
        padding: EdgeInsetsGeometry.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppPalette.primary.withValues(alpha: .1),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              /// The header row containing the title and the period selection dropdown.
              children: [
                Expanded(
                  child: Text(
                    'Weight Report',
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                /// Minor Spacing
                const SizedBox(width: 10),
                Container(
                  /// A dropdown menu to allow the user to select the time period for the report.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppPalette.primary.withValues(alpha: .15),
                  ),
                  child: DropdownButton(
                    value: selectedPeriod,
                    underline: SizedBox(),
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    padding: EdgeInsets.only(left: 8),

                    selectedItemBuilder: (context) =>
                        ["Semana", "15 días", "Mes", "Año"]
                            .map(
                              (item) => Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarDays,
                                    size: 14,
                                    color: AppPalette.primary.withValues(
                                      alpha: .75,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item,
                                    style: AppTextStyles.bodyRegular.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                    items: ["Week", "15 Days", "Month", "Year"]
                        .map(
                          (item) => DropdownMenuItem(
                            onTap: () {
                              setState(() {
                                selectedPeriod = item;
                              });
                            },
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyles.bodyRegular.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),

            /// title Spacing
            VerticalSpacing.lg(context),

            /// The line chart widget for visualizing weight data.
            SizedBox(
              height: 100,
              child: LineChart(
                duration: const Duration(milliseconds: 300),
                LineChartData(
                  gridData: FlGridData(show: false),

                  /// Configures the titles (labels) for the chart axes.
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      /// Shows the day labels on the bottom (X-axis).
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          weightList.keys.elementAt(value.toInt()),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),

                  /// Configures the interactive tooltip that appears on touch.
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => AppPalette.primary,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.background(context),
                            fontWeight: FontWeight.w600,
                          );
                          return LineTooltipItem(
                            "${touchedSpot.y} Kg",
                            textStyle,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    /// Defines the properties of the line itself.
                    LineChartBarData(
                      isCurved: true,
                      dotData: FlDotData(
                        show: false,
                        checkToShowDot: (spot, barData) {
                          return true;
                        },
                      ),
                      color: AppPalette.primary,
                      barWidth: 3.0,

                      /// Generates the data points (spots) for the chart from the `weightList` map.
                      spots: List.generate(
                        weightList.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          weightList.values.elementAt(index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
