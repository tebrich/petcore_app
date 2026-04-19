import 'package:flutter/material.dart';

/// A widget that draws a horizontal line of dashes or dots.
///
/// This widget is a customizable divider used to create visual separation in a
/// layout. It automatically calculates the number of dashes that can fit
/// within the available width and distributes them evenly.
class DottedLineDivider extends StatelessWidget {
  /// Creates a dotted line divider.
  const DottedLineDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 10.0,
    this.color = Colors.grey,
    this.spaceWidth,
    this.indent, // Note: Not currently implemented in this layout.
    this.endIndent, // Note: Not currently implemented in this layout.
  });

  /// The thickness (height) of the divider line.
  final double height;

  /// The width of each individual dash.
  final double dashWidth;

  /// The width of the space between each dash.
  ///
  /// If this is null, the space will be equal to [dashWidth].
  final double? spaceWidth;

  /// The amount of empty space to the left of the divider.
  /// > ⚠️ **Note:** This property is declared but not currently used by the widget's layout logic.
  final double? indent;

  /// The amount of empty space to the right of the divider.
  /// > ⚠️ **Note:** This property is declared but not currently used by the widget's layout logic.
  final double? endIndent;

  /// The color of the dashes.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount =
            (boxWidth /
                    (spaceWidth == null
                        ? (2 * dashWidth)
                        : (spaceWidth! + dashWidth)))
                .floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
