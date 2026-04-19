import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A customizable and animated container that functions as a selectable card.
///
/// This widget is designed for selection scenarios, such as choosing a pet type,
/// a category, or any option that benefits from a visual feedback. It features
/// smooth animations for color, text color, scale, and a ripple effect on tap.
///
/// It can be configured to show an image and text, only an image, or only text,
/// making it a versatile component for the Peticare UI kit.
class AnimatedClickableContainer extends StatefulWidget {
  const AnimatedClickableContainer({
    super.key,
    required this.onSelectedColor,
    required this.containerSize,
    required this.childText,
    required this.image,
    required this.isSelected,
    required this.onTap,
    this.onlyImage = false,
    this.onlyText = false,
  });

  /// Determines if the container is currently in the "selected" state.
  /// This controls the direction of the animations (forward or reverse).
  final bool isSelected;

  /// The background color of the container when [isSelected] is true.
  final Color onSelectedColor;

  /// The height and width of the square container.
  final double containerSize;

  /// The text label to display inside the container.
  final String childText;

  /// The widget (typically an `Image` or `SvgPicture`) to display.
  final Widget image;

  /// The callback function that is triggered when the container is tapped.
  final VoidCallback onTap;

  /// If true, the container will only display the [image].
  final bool onlyImage;

  /// If true, the container will only display the [childText].
  final bool onlyText;
  @override
  State<AnimatedClickableContainer> createState() =>
      _AnimatedClickableContainerState();
}

/// The state for [AnimatedClickableContainer] that manages all animations.
class _AnimatedClickableContainerState extends State<AnimatedClickableContainer>
    with SingleTickerProviderStateMixin {
  /// Flag to ensure context-dependent animations are initialized only once.
  late bool _isInitialized;

  /// The single controller managing all animations for efficiency.
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  /// Controls the visibility of the tap ripple effect.
  bool _showRipple = false;

  // Cached values to avoid repeated calculations
  late double _borderRadius;
  late EdgeInsets _padding;

  @override
  void initState() {
    super.initState();
    // Defer context-dependent initializations to didChangeDependencies.
    _isInitialized = false;

    // Cache calculated values to avoid recalculating on every build.
    _borderRadius = widget.containerSize * 0.25;
    _padding = EdgeInsets.all(widget.containerSize * 0.1);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    // Define all animationsthat does not need context
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Set initial state based on external isSelected
    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize animations that depend on the BuildContext (e.g., for themes).
    if (!_isInitialized) {
      _isInitialized = true;
      _colorAnimation = ColorTween(
        // Fetches the initial color from the theme.
        begin: AppPalette.surfaces(context),
        end: widget.onSelectedColor,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _textColorAnimation = ColorTween(
        begin: AppPalette.textOnSecondaryBg(context),
        end: AppPalette.background(context),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  void didUpdateWidget(AnimatedClickableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate forwards or backwards if the parent widget updates the isSelected state.
    if (widget.isSelected != oldWidget.isSelected && mounted) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles the tap event, triggers the ripple animation, and calls the onTap callback.
  void _handleTap() {
    setState(() {
      _showRipple = true;
    });

    // Execute the callback provided by the parent widget.
    widget.onTap();

    // Hide the ripple effect after its animation completes.
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showRipple = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller, // Listens to the controller for rebuilds.
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main container
                Container(
                  height: widget.containerSize,
                  width: widget.containerSize,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  child: Padding(
                    padding: _padding,
                    // Conditionally render the content based on widget properties.
                    child: widget.onlyText
                        ? Text(
                            widget.childText,
                            style: AppTextStyles.playfulTag.copyWith(
                              color: _textColorAnimation.value,
                              fontSize: 16,
                            ),
                          )
                        : widget.onlyImage
                        ? widget.image
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.image,

                              VerticalSpacing.md(context),

                              Text(
                                widget.childText,
                                style: AppTextStyles.playfulTag.copyWith(
                                  color: _textColorAnimation.value,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                // The ripple effect is a temporary, animated border.
                if (_showRipple)
                  Container(
                    height: widget.containerSize * 0.8,
                    width: widget.containerSize * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppPalette.textOnSecondaryBg(
                          context,
                        ).withValues(alpha: (1 - _rippleAnimation.value) * 0.5),
                        width: 2.0 * (1 - _rippleAnimation.value),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
