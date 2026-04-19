import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/constants/tips.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A widget that displays an animated, auto-scrolling carousel of helpful tips. 💡
///
/// This `StatefulWidget` cycles through a predefined list of tips from
/// `Constants.tipsList`. Every 20 seconds, it performs a scale-out and
/// scale-in animation to transition to the next tip, creating an engaging and
/// dynamic user experience.
class TipsWidget extends StatefulWidget {
  const TipsWidget({super.key});

  @override
  State<TipsWidget> createState() => _TipsWidgetState();
}

/// The state for the [TipsWidget].
///
/// Manages the animation controller and the index of the currently visible tip.
class _TipsWidgetState extends State<TipsWidget>
    with SingleTickerProviderStateMixin {
  // ===========================================================================
  // 🚀 State Variables & Controllers
  // ===========================================================================

  /// Notifies listeners when the index of the visible tip changes.
  final indexNotifier = ValueNotifier<int>(0);

  /// Drives the scale-in and scale-out animation.
  late AnimationController animationController;

  /// The animation object that provides the scale value (from 1.0 to 0.0 and back).
  late Animation<double> scalingAnimation;

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================
  @override
  /// Initializes the widget's state, including the animation controller and its logic.
  void initState() {
    indexNotifier.value = 0;
    animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..addListener(() async {
          /// This listener handles the automatic cycling of tips.
          /// When the scale-out animation completes, it updates the tip index
          /// and reverses the animation to scale back in with the new content.
          if (animationController.isCompleted) {
            if (indexNotifier.value < Constants.tipsList.length - 1) {
              indexNotifier.value++;
            } else {
              indexNotifier.value = 0;
            }
            if (mounted) {
              animationController.reverse();
            }
          } else if (animationController.isDismissed) {
            /// After scaling back in, it waits for 20 seconds before starting
            /// the next cycle.
            await Future.delayed(const Duration(seconds: 20));
            if (mounted) {
              animationController.forward();
            }
          }
        });
    scalingAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );

    /// Kicks off the animation loop after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 20));

      if (mounted) {
        animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    /// Disposes of the controllers to prevent memory leaks.
    animationController.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  /// Builds the animated tip widget.
  ///
  /// It uses a `ValueListenableBuilder` to listen for tip index changes and an
  /// `AnimatedBuilder` to apply the `Transform.scale` animation.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (context, index, _) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: scalingAnimation.value,
                child: _tipWidget(screenSize, Constants.tipsList[index]),
              );
            },
          );
        },
      ),
    );
  }

  /// Builds the visual representation of a single tip card.
  ///
  /// This private helper method constructs the styled `Container` with its
  /// decorative background elements and the tip's text content.
  Widget _tipWidget(Size screenSize, Map<String, dynamic> tipDetails) {
    return Container(
      width: screenSize.width * 0.8,
      //height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppPalette.primary,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .3),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Decorative background circle.
          Positioned(
            top: -30,
            left: -15,
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.background(context).withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.09
                      : 0.15,
                ),
              ),
            ),
          ),

          /// Decorative background paw grip illustration.
          Positioned(
            bottom: -30,
            right: -10,
            child: Container(
              height: 100,
              width: 100,
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.background(context).withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.09
                      : 0.19,
                ),
              ),
              child: Opacity(
                opacity: .75,
                child: SvgPicture.asset(
                  'assets/illustrations/paw_grip.svg',
                  height: 80,
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(
                      alpha: Theme.of(context).brightness == Brightness.dark
                          ? 0.8
                          : 0.7,
                    ),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),

          /// The main content of the tip card.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '(Consejos útiles)',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.secondary(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                /// Title Spacing
                VerticalSpacing.sm(context),
                Text(
                  tipDetails['tip'],
                  style: AppTextStyles.playfulTag.copyWith(
                    color: AppPalette.background(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
