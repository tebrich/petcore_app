import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A [CustomPainter] that draws the animated shopping cart. 🛒
///
/// This painter is responsible for all the drawing logic, including the cart's
/// silhouette, the wheels, and the road beneath it. It receives animation values
/// from its parent widget to create the illusion of movement.
class CartLoadingPainter extends CustomPainter {
  // ===========================================================================
  // 🚀 Animation Properties
  // ===========================================================================

  /// The current rotation value for the wheels, in degrees.
  final double wheelsRotationAnimationValue;

  /// The vertical offset for the first wheel's vibration animation.
  final double wheels1VibrationOffset;

  /// The vertical offset for the second wheel's vibration animation.
  final double wheels2VibrationOffset;

  /// The progress value (0.0 to 1.0) for the road line animation.
  final double roadAnimationValue;

  /// A flag to determine the direction of the road animation.
  final bool isRoadAnimationReversed;

  // ===========================================================================
  // 🎨 Customization Properties
  // ===========================================================================

  // --- Right Outside Line ---
  final Color rightOutsideLineColor;
  final double rightOutsideLineStrokeWidth;

  // --- Road ---
  final Color roadLineColor;
  final double roadStrokeWidth;

  // --- Cart Silhouette ---
  final double strokeWidth;
  final Color color;

  /// Creates an instance of [CartLoadingPainter].
  CartLoadingPainter({
    // Animation values
    required this.wheelsRotationAnimationValue,
    required this.wheels1VibrationOffset,
    required this.wheels2VibrationOffset,
    required this.roadAnimationValue,
    required this.isRoadAnimationReversed,

    // Customization values
    required this.rightOutsideLineColor,
    required this.rightOutsideLineStrokeWidth,
    required this.roadLineColor,
    required this.roadStrokeWidth,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint cartSilhouettePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint outsideLinePaint = Paint()
      ..color = rightOutsideLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = rightOutsideLineStrokeWidth;

    final Paint roadLinePaint = Paint()
      ..color = roadLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = roadStrokeWidth;

    /// Helper function to convert degrees to radians for arc drawing.
    double degToRad(double deg) => deg * (math.pi / 180.0);

    final Path path1 = Path()
      //outside left Line
      /*..addArc(
          Rect.fromLTWH(
              0, size.height * 0.075, size.width * 0.1, size.width * 0.05),
          degToRad(-90.0),
          degToRad(260.0))*/
      //..moveTo(size.width * 0.1, size.height * 0.1)
      // Cart Handle
      ..moveTo(size.width * 0.025, size.height * 0.1)
      ..quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.05,
        size.width * 0.1,
        size.height * 0.1,
      )
      //
      ..moveTo(size.width * 0.1, size.height * 0.15)
      ..lineTo(size.width * 0.025, size.height * 0.15)
      ..quadraticBezierTo(
        0,
        size.height * 0.15,
        size.width * 0.02,
        size.height * 0.11,
      )
      // Cart Body
      ..moveTo(size.width * 0.1, size.height * 0.1)
      ..lineTo(size.width * 0.15, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.7,
        size.width * 0.25,
        size.height * 0.7,
      )
      //Outside Right Line
      ..moveTo(size.width * 0.21, size.height * 0.075)
      ..lineTo(size.width * 0.2, size.height * 0.1)
      ..quadraticBezierTo(
        size.width * 0.175,
        size.height * 0.2,
        size.width * 0.3,
        size.height * 0.2,
      )
      ..lineTo(size.width * 0.75, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.875,
        size.height * 0.2,
        size.width * 0.85,
        size.height * 0.3,
      )
      ..lineTo(size.width * 0.8, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.775,
        size.height * 0.65,
        size.width * 0.7,
        size.height * 0.65,
      )
      ..lineTo(size.width * 0.3, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.65,
        size.width * 0.2,
        size.height * 0.55,
      )
      ..lineTo(size.width * 0.2, size.height * 0.5)
      // --- Lines inside the cart basket ---
      /// /// First Line (cutted)
      ..moveTo(size.width * 0.11, size.height * 0.25)
      ..lineTo(size.width * 0.5, size.height * 0.25)
      ..moveTo(size.width * 0.55, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.25)
      /// /// Second Line (ARC)
      ..addArc(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.25,
          size.width * 0.15,
          size.width * 0.15,
        ),
        degToRad(-90.0),
        degToRad(180.0),
      )
      /// /// Third Line
      ..moveTo(size.width * 0.125, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.3)
      /// /// Fourth Line
      ..moveTo(size.width * 0.13, size.height * 0.35)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      /// /// Fifth Line (To meet the arc)
      ..moveTo(size.width * 0.13, size.height * 0.4)
      ..lineTo(size.width * 0.325, size.height * 0.4)
      /// /// Added
      ..moveTo(size.width * 0.135, size.height * 0.45)
      ..lineTo(size.width * 0.75, size.height * 0.45)
      /// /// Sixth Line
      ..moveTo(size.width * 0.14, size.height * 0.5)
      ..lineTo(size.width * 0.81, size.height * 0.5)
      /// /// Seventh Line
      ..moveTo(size.width * 0.15, size.height * 0.6)
      ..lineTo(size.width * 0.775, size.height * 0.6)
      // --- Wheels ---
      /// 1 St wheel
      ..addArc(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.75 - wheels2VibrationOffset,
          size.width * 0.15,
          size.width * 0.15,
        ),
        degToRad(wheelsRotationAnimationValue),
        degToRad(340.0),
      )
      /// 2 nd wheel
      ..addArc(
        Rect.fromLTWH(
          size.width * 0.65,
          size.height * 0.75 - wheels1VibrationOffset,
          size.width * 0.15,
          size.width * 0.15,
        ),
        degToRad(wheelsRotationAnimationValue),
        degToRad(340.0),
      );

    // --- Road Line ---
    final Path roadPath = Path()
      ..moveTo(0, size.height * 0.92)
      ..lineTo(size.width, size.height * 0.92);

    // Other Color Lines
    final Path path2 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.875,
        size.height * 0.7,
        size.width * 0.9,
        size.height * 0.6,
      )
      ..lineTo(size.width * 0.95, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.975,
        size.height * 0.2,
        size.width * 0.85,
        size.height * 0.2,
      )
      ..lineTo(size.width * 0.8, size.height * 0.2);

    // --- Road Animation Logic ---
    final Path animatedRoadPath = Path();
    final roadPathFirstMetric = roadPath.computeMetrics().first;
    final currentLength = roadPathFirstMetric.length * roadAnimationValue;
    if (isRoadAnimationReversed) {
      animatedRoadPath.addPath(
        roadPathFirstMetric.extractPath(0, currentLength),
        Offset.zero,
      );
    } else {
      animatedRoadPath.addPath(
        roadPathFirstMetric.extractPath(
          roadPathFirstMetric.length - currentLength,
          roadPathFirstMetric.length,
        ),
        Offset.zero,
      );
    }

    canvas.drawPath(path2, outsideLinePaint);
    canvas.drawPath(path1, cartSilhouettePaint);
    canvas.drawPath(animatedRoadPath, roadLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// A stateful widget that displays an animated shopping cart loading indicator.
///
/// This widget orchestrates multiple animations (wheel rotation, vibration, road
/// movement) and uses the [CartLoadingPainter] to render the final visual.
/// It is highly customizable, allowing control over colors and stroke widths.
class AnimatedCartLoading extends StatefulWidget {
  /// The size of the painter canvas.
  final Size logoSize;

  // --- Customization Properties ---
  // Right Outside Line
  final Color rightOutsideLineColor;
  final double rightOutsideLineStrokeWidth;

  // Road
  final Color roadLineColor;
  final double roadStrokeWidth;

  // Cart Silhouette
  final double strokeWidth;
  final Color color;

  /// Creates an instance of [AnimatedCartLoading].
  const AnimatedCartLoading({
    required this.logoSize,
    this.rightOutsideLineColor = Colors.grey,
    this.rightOutsideLineStrokeWidth = 4,

    this.roadLineColor = Colors.black,
    this.roadStrokeWidth = 2,

    this.color = Colors.grey,
    this.strokeWidth = 3,
    super.key,
  });

  ///

  @override
  State<AnimatedCartLoading> createState() => _AnimatedCartLoadingState();
}

class _AnimatedCartLoadingState extends State<AnimatedCartLoading>
    with TickerProviderStateMixin {
  // ===========================================================================
  // 🚀 State & Animation Variables
  // ===========================================================================

  /// A flag to control the direction of the road animation.
  late bool isRoadAnimationReversed;

  // --- Animation Controllers ---
  late AnimationController roadAnimationController;
  late AnimationController wheelsAnimationController;
  late AnimationController wheel1VibrationAnimationController;
  late AnimationController wheel2VibrationAnimationController;

  // --- Animations ---
  late Animation<double> readAnimation;
  late Animation<double> wheelsAnimation;
  late Animation<double> wheel1VibrationAnimation;
  late Animation<double> wheel2VibrationAnimation;

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================
  @override
  void initState() {
    super.initState();
    isRoadAnimationReversed = false;

    /// Road Animations
    roadAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          if (roadAnimationController.isCompleted) {
            setState(() {
              isRoadAnimationReversed = true;
            });
            roadAnimationController.reverse();
          }
          if (roadAnimationController.isDismissed) {
            setState(() {
              isRoadAnimationReversed = false;
            });
            roadAnimationController.forward();
          }
        });
    readAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(roadAnimationController);

    /// Wheels Rotation Animation
    wheelsAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          if (wheelsAnimationController.isCompleted) {
            wheelsAnimationController.repeat();
          }
        });

    wheelsAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(wheelsAnimationController);

    /// Wheels Vibration Animation
    wheel1VibrationAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 50),
        )..addListener(() async {
          if (wheel1VibrationAnimationController.isCompleted) {
            wheel1VibrationAnimationController.reverse();
          }
          if (wheel1VibrationAnimationController.isDismissed && mounted) {
            await Future.delayed(const Duration(milliseconds: 50));
            if (mounted) {
              wheel2VibrationAnimationController.forward();
            }
          }
        });
    wheel1VibrationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.logoSize.height * 0.015,
    ).animate(wheel1VibrationAnimationController);

    /// ///
    wheel2VibrationAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 50),
        )..addListener(() async {
          if (wheel2VibrationAnimationController.isCompleted) {
            wheel2VibrationAnimationController.reverse();
          }
          if (wheel2VibrationAnimationController.isDismissed && mounted) {
            await Future.delayed(const Duration(milliseconds: 750));
            if (mounted) {
              wheel1VibrationAnimationController.forward();
            }
          }
        });
    wheel2VibrationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.logoSize.height * 0.015,
    ).animate(wheel2VibrationAnimationController);
  }

  @override
  void dispose() {
    roadAnimationController.dispose();
    wheelsAnimationController.dispose();
    wheel1VibrationAnimationController.dispose();
    wheel2VibrationAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    roadAnimationController.forward();
    wheelsAnimationController.forward();
    wheel1VibrationAnimationController.forward();
    super.didChangeDependencies();
  }

  // ===========================================================================
  // 🎨 Build Method
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        roadAnimationController,
        wheelsAnimationController,
        wheel1VibrationAnimationController,
        wheel2VibrationAnimationController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          painter: CartLoadingPainter(
            wheelsRotationAnimationValue: wheelsAnimation.value,
            wheels1VibrationOffset: wheel1VibrationAnimation.value,
            wheels2VibrationOffset: wheel2VibrationAnimation.value,
            roadAnimationValue: readAnimation.value,
            isRoadAnimationReversed: isRoadAnimationReversed,

            // Pass customization properties to the painter
            rightOutsideLineColor: widget.rightOutsideLineColor,
            rightOutsideLineStrokeWidth: widget.rightOutsideLineStrokeWidth,
            roadLineColor: widget.roadLineColor,
            roadStrokeWidth: widget.roadStrokeWidth,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
          size: widget.logoSize,
        );
      },
    );
  }
}

/// A stateless widget that displays a static, non-animated version of the
/// shopping cart.
///
/// This is useful for contexts where an animation is not needed, providing a
/// lightweight alternative while reusing the same drawing logic from
/// [CartLoadingPainter].
class StaticCartLoading extends StatelessWidget {
  /// The size of the painter canvas.
  final Size logoSize;

  // --- Customization Properties ---
  final Color rightOutsideLineColor;
  final double rightOutsideLineStrokeWidth;
  final Color roadLineColor;
  final double roadStrokeWidth;
  final double strokeWidth;
  final Color color;

  /// Creates an instance of [StaticCartLoading].
  const StaticCartLoading({
    required this.logoSize,
    this.rightOutsideLineColor = Colors.black26,
    this.rightOutsideLineStrokeWidth = 4,

    /// /// Road
    this.roadLineColor = Colors.black,
    this.roadStrokeWidth = 2,

    this.color = Colors.grey,
    this.strokeWidth = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CartLoadingPainter(
        wheelsRotationAnimationValue: 240.0,
        wheels1VibrationOffset: 0,
        wheels2VibrationOffset: 0,
        roadAnimationValue: roadStrokeWidth,
        isRoadAnimationReversed: false,

        // Pass customization properties to the painter
        rightOutsideLineColor: rightOutsideLineColor,
        rightOutsideLineStrokeWidth: rightOutsideLineStrokeWidth,
        roadLineColor: roadLineColor,
        roadStrokeWidth: roadStrokeWidth,
        color: color,
        strokeWidth: strokeWidth,
      ),
      size: logoSize,
    );
  }
}
