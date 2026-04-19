import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that applies a continuous, looping floating animation to its child.
///
/// This widget can be used to create various dynamic effects like gentle floating,
/// bouncing, drifting, pulsing, or rotating. It's perfect for making UI elements
/// like illustrations, icons, or buttons more lively and engaging.
class FloatingAnimation extends StatefulWidget {
  /// The widget to which the floating animation will be applied.
  final Widget child;

  /// The duration of one full animation cycle.
  final Duration duration;

  /// The strength or amplitude of the floating effect. A higher value results
  /// in a more pronounced movement.
  final double floatStrength;

  /// The type of floating animation to apply. See [FloatingType] for options.
  final FloatingType type;

  /// The curve to use for the animation, controlling its rate of change.
  final Curve curve;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.floatStrength = 3.0,
    this.type = FloatingType.gentle,
    this.curve = Curves.easeInOut,
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

/// Defines the different styles of floating animations available.
enum FloatingType {
  /// A slow and smooth up-and-down movement.
  gentle,

  /// A bouncy up-and-down movement.
  bounce,

  /// A slow, diagonal drift combining horizontal and vertical movement.
  drift,

  /// A gentle scaling (pulsing) effect combined with vertical movement.
  pulse,

  /// A gentle rotation effect combined with vertical movement.
  rotate,

  /// A wave-like motion, creating a more complex path.
  wave,
}

/// Manages the state and controllers for the [FloatingAnimation].
class _FloatingAnimationState extends State<FloatingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _secondaryController;
  late Animation<double> _secondaryAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  /// Initializes the primary and secondary animation controllers.
  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _secondaryController = AnimationController(
      duration: Duration(
        milliseconds: (widget.duration.inMilliseconds * 1.3).round(),
      ),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    _secondaryAnimation = CurvedAnimation(
      parent: _secondaryController,
      curve: Curves.easeInOut,
    );
  }

  /// Starts the looping animations.
  void _startAnimation() {
    _controller.repeat(reverse: true);
    _secondaryController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  /// Builds the appropriate animation based on the selected [FloatingType].
  Widget _buildAnimatedChild() {
    switch (widget.type) {
      case FloatingType.gentle:
        return _buildGentleFloat();
      case FloatingType.bounce:
        return _buildBounceFloat();
      case FloatingType.drift:
        return _buildDriftFloat();
      case FloatingType.pulse:
        return _buildPulseFloat();
      case FloatingType.rotate:
        return _buildRotateFloat();
      case FloatingType.wave:
        return _buildWaveFloat();
    }
  }

  /// Builds a gentle up-and-down floating animation.
  Widget _buildGentleFloat() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            sin(_animation.value * 2 * pi) * widget.floatStrength,
          ),
          child: widget.child,
        );
      },
    );
  }

  /// Builds a bouncy floating animation.
  Widget _buildBounceFloat() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final bounceValue = sin(_animation.value * 2 * pi).abs();
        return Transform.translate(
          offset: Offset(0, -bounceValue * widget.floatStrength * 2),
          child: widget.child,
        );
      },
    );
  }

  /// Builds a drifting animation with both horizontal and vertical movement.
  Widget _buildDriftFloat() {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _secondaryAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            sin(_animation.value * 2 * pi) * widget.floatStrength,
            cos(_secondaryAnimation.value * 2 * pi) *
                widget.floatStrength *
                0.7,
          ),
          child: widget.child,
        );
      },
    );
  }

  /// Builds a pulsing (scaling) and floating animation.
  Widget _buildPulseFloat() {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _secondaryAnimation]),
      builder: (context, child) {
        final scale = 1.0 + sin(_secondaryAnimation.value * 2 * pi) * 0.05;
        return Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(
              0,
              sin(_animation.value * 2 * pi) * widget.floatStrength,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }

  /// Builds a rotating and floating animation.
  Widget _buildRotateFloat() {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _secondaryAnimation]),
      builder: (context, child) {
        return Transform.rotate(
          angle:
              sin(_secondaryAnimation.value * 2 * pi) * 0.1, // Gentle rotation
          child: Transform.translate(
            offset: Offset(
              0,
              sin(_animation.value * 2 * pi) * widget.floatStrength,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }

  /// Builds a wave-like floating animation.
  Widget _buildWaveFloat() {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _secondaryAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            sin(_animation.value * 2 * pi) * widget.floatStrength * 0.5,
            sin(_animation.value * 4 * pi) * widget.floatStrength,
          ),
          child: widget.child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedChild();
  }
}
