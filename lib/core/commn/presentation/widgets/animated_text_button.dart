import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_textstyles.dart';

/// A custom `TextButton` that includes a subtle "press down" animation.
///
/// This widget provides visual feedback when tapped by scaling down slightly.
/// The `onClick` callback is triggered after the animation completes, creating a
/// satisfying and responsive user interaction. It's ideal for secondary actions
/// or links within the UI.
class AnimatedTextButton extends StatefulWidget {
  /// The text to be displayed on the button.
  final String text;

  /// The fixed size of the button. If null, it sizes itself to its content.
  final Size? size;

  /// The background color of the button.
  final Color? backgroundcolor;

  /// The color of the text on the button.
  final Color? foregroundColor;

  /// The text style for the button's label.
  final TextStyle? textStyle;

  /// The callback function that is triggered after the press animation completes.
  final Function()? onClick;
  const AnimatedTextButton({
    required this.text,
    required this.onClick,
    this.size,
    this.backgroundcolor,
    this.foregroundColor,
    this.textStyle,
    super.key,
  });

  @override
  State<AnimatedTextButton> createState() => _AnimatedTextButtonState();
}

/// Manages the state and animation for the [AnimatedTextButton].
class _AnimatedTextButtonState extends State<AnimatedTextButton>
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
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: widget.backgroundcolor,
            foregroundColor: widget.foregroundColor,
            padding: EdgeInsets.zero,
            minimumSize: Size(25, 25),
            overlayColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            textStyle:
                widget.textStyle ??
                AppTextStyles.buttonText.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
            fixedSize: widget.size,
          ),
          onPressed: widget.onClick == null
              ? null
              : () {
                  // Starts the "press down" animation when the button is tapped.
                  sizeAnimationController.forward();
                },
          child: Text(widget.text),
        ),
      ),
    );
  }
}
