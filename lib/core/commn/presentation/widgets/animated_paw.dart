import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// A decorative widget that displays a paw icon with a subtle, randomized pulse animation.
///
/// This widget is perfect for adding a playful and lively touch to backgrounds,
/// headers, or loading screens. The animation can be set to play automatically
/// or be controlled manually.
class AnimatedPaw extends StatefulWidget {
  /// The rotation angle of the paw icon in radians.
  final double? rotationAngle;

  /// The color of the paw icon.
  final Color? pawColor;

  /// The size of the paw icon.
  final double? pawSize;

  /// If `true`, the paw will start its randomized pulse animation automatically.
  /// Defaults to `true`.
  final bool autoAnimate;

  /// The duration of a single pulse (scale down and back up).
  final Duration? animationDuration;

  /// A list of millisecond intervals to randomize the time between pulses.
  final List<int>? pulseIntervals; // Customizable pulse timing

  const AnimatedPaw({
    this.pawSize,
    this.pawColor,
    this.rotationAngle,
    this.autoAnimate = true,
    this.animationDuration,
    this.pulseIntervals,
    super.key,
  });

  @override
  State<AnimatedPaw> createState() => _AnimatedPawState();
}

/// Manages the state and animation logic for the [AnimatedPaw] widget.
class _AnimatedPawState extends State<AnimatedPaw>
    with SingleTickerProviderStateMixin {
  late AnimationController _sizeAnimationController;
  late Animation<double> _sizeAnimation;
  Timer? _pulseTimer;

  /// A static [Random] instance to ensure different `AnimatedPaw` widgets
  /// have varied animation timings.
  static final Random _random = Random();

  /// A cached list of pulse intervals to avoid creating a new list on every pulse.
  late final List<int> _intervals;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    if (widget.autoAnimate) {
      _startPulseAnimation();
    }
  }

  /// Initializes the animation controller and tween.
  void _initializeAnimation() {
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
    );

    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _sizeAnimationController,
        curve: Curves.easeInOut, // Smoother animation curve
      ),
    );

    // Cache intervals to avoid creating new list each time
    _intervals = widget.pulseIntervals ?? [1500, 1200, 1000];
  }

  /// Starts the periodic timer that triggers the pulse animation at random intervals.
  void _startPulseAnimation() {
    _pulseTimer = Timer.periodic(
      Duration(milliseconds: _intervals[_random.nextInt(_intervals.length)]),
      _handlePulse,
    );
  }

  /// The callback for the pulse timer. It triggers the animation and schedules the next pulse.
  void _handlePulse(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    if (_sizeAnimationController.isCompleted) {
      _sizeAnimationController.reverse();
    } else {
      _sizeAnimationController.forward();
    }

    // Randomize next interval
    timer.cancel();
    if (mounted && widget.autoAnimate) {
      _pulseTimer = Timer(
        Duration(milliseconds: _intervals[_random.nextInt(_intervals.length)]),
        () => _startPulseAnimation(),
      );
    }
  }

  /// Manually starts the pulse animation if [autoAnimate] is `false`.
  void startAnimation() {
    if (!widget.autoAnimate) {
      _startPulseAnimation();
    }
  }

  /// Stops the pulse animation and resets the paw to its original size.
  void stopAnimation() {
    _pulseTimer?.cancel();
    _sizeAnimationController.reset();
  }

  /// Triggers a single pulse animation manually.
  /// This is useful for creating interactive feedback.
  void pulse() {
    if (_sizeAnimationController.isCompleted) {
      _sizeAnimationController.reverse();
    } else {
      _sizeAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _sizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _sizeAnimation.value, child: child);
      },
      child: Transform.rotate(
        angle: widget.rotationAngle ?? 0,
        child: FaIcon(
          FontAwesomeIcons.paw,
          size: widget.pawSize ?? 35,
          color:
              widget.pawColor ??
              AppPalette.secondary(
                context,
              ).withValues(alpha: 0.4), // Fallback color
        ),
      ),
    );
  }
}
