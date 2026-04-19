import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// A custom `IconButton` that provides a subtle "press down" scale animation on tap.
///
/// This widget enhances user interaction by giving immediate visual feedback.
/// It's highly customizable, allowing for changes to the icon, colors, size,
/// and shape. It can display either a standard `IconData` or a custom `child` widget.
class AnimatedIconButton extends StatefulWidget {
  /// The size of the icon to be displayed.
  final double? iconSize;

  /// The fixed size of the button's tappable area.
  final Size? size;

  /// The icon to display. This is ignored if a `child` widget is provided.
  final IconData iconData;

  /// The color of the icon or the `child` widget.
  /// Defaults to the primary theme color.
  final Color? foregroundColor;

  /// The background color of the button.
  final Color? backgroundColor;

  /// An optional widget to display inside the button instead of the `iconData`.
  /// If provided, `iconData` and `iconSize` are ignored.
  final Widget? child;

  /// The border radius of the button.
  final BorderRadius? radius;

  /// The padding around the icon or `child` widget.
  final EdgeInsets? paddings;

  /// The callback function that is triggered after the press animation completes.
  final Function()? onClick;

  const AnimatedIconButton({
    required this.iconData,
    required this.onClick,
    this.iconSize,
    this.size,
    this.foregroundColor,
    this.backgroundColor,
    this.paddings,
    this.child,
    this.radius,
    super.key,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

/// Manages the state and animation for the [AnimatedIconButton].
class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  /// The controller that manages the button's scale animation.
  late AnimationController sizeAnimationController;

  /// The animation that drives the scaling effect.
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();
    sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    // Defines the animation sequence: scale down, then reverse to scale back up.
    sizeAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(sizeAnimationController)
          ..addListener(() {
            if (sizeAnimation.isCompleted && mounted) {
              sizeAnimationController.reverse();
            }
            if (sizeAnimationController.isDismissed && mounted) {
              // The onClick callback is fired after the animation completes.
              widget.onClick!();
            }
          });
  }

  @override
  void dispose() {
    sizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // Listens to the controller to rebuild the widget on animation ticks.
      animation: sizeAnimationController,
      builder: (context, child) => ScaleTransition(
        scale: sizeAnimation,
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            padding: widget.paddings,
            shape: widget.radius == null
                ? null
                : RoundedRectangleBorder(borderRadius: widget.radius!),
            foregroundColor: widget.foregroundColor ?? AppPalette.primary,
            iconSize: widget.iconSize,
            fixedSize: widget.size,
          ),
          onPressed: widget.onClick == null
              ? null
              : () {
                  // Starts the "press down" animation when the button is tapped.
                  sizeAnimationController.forward();
                },
          icon: widget.child ?? FaIcon(widget.iconData),
        ),
      ),
    );
  }
}
