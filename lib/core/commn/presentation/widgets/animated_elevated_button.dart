import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';

/// A custom `ElevatedButton` that includes a subtle "press down" animation.
///
/// This widget enhances the user experience by providing visual feedback when
/// the button is tapped. It scales down slightly on press and executes the
/// `onClick` callback upon animation completion, creating a satisfying interaction.
///
/// It is highly customizable, allowing changes to text, colors, size, and shape,
/// making it a versatile component for the Peticare UI kit.
class AnimatedElevatedButton extends StatefulWidget {
  /// The text to be displayed on the button.
  /// This is ignored if a `child` widget is provided.
  final String text;

  /// The fixed size of the button. If null, the button sizes itself to its content.
  final Size? size;

  /// The background color of the button.
  /// Defaults to the primary theme color with some transparency.
  final Color? backgroundcolor;

  /// The color for the text and icons on the button.
  /// Defaults to the theme's background color.
  final Color? foregroundColor;

  /// The text style for the button's label.
  /// Defaults to `AppTextStyles.ctaBold`.
  final TextStyle? textStyle;

  /// An optional child widget to display instead of the `text`.
  /// If provided, the `text` property is ignored.
  final Widget? child;

  /// The border radius of the button.
  final BorderRadius? radius;

  /// The callback function that is triggered after the press animation completes.
  final Function()? onClick;

  const AnimatedElevatedButton({
    required this.text,
    required this.onClick,
    this.size,
    this.backgroundcolor,
    this.foregroundColor,
    this.textStyle,
    this.child,
    this.radius,
    super.key,
  });

  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

/// Manages the state and animation for the [AnimatedElevatedButton].
class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
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
      builder: (context, child) => Transform.scale(
        scale: sizeAnimation.value,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.backgroundcolor ??
                AppPalette.primary.withValues(alpha: 0.9),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            shape: widget.radius == null
                ? null
                : RoundedRectangleBorder(borderRadius: widget.radius!),
            foregroundColor:
                widget.foregroundColor ?? AppPalette.background(context),
            textStyle: widget.textStyle ?? AppTextStyles.ctaBold,
            fixedSize: widget.size,
            minimumSize: Size(25, 25),
          ),
          onPressed: widget.onClick == null
              ? null
              : () {
                  // Starts the "press down" animation when the button is tapped.
                  sizeAnimationController.forward();
                },
          child: widget.child ?? Text(widget.text),
        ),
      ),
    );
  }
}
