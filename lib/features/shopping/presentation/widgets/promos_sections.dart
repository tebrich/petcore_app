import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// A widget that displays a horizontally scrolling carousel of promotional banners. 📢
///
/// This `StatefulWidget` creates an auto-scrolling `PageView` to showcase a
/// list of promotional widgets. It includes a `SmoothPageIndicator` at the
/// bottom to show the user's current position in the carousel.
///
/// The auto-scroll functionality is managed by a `Timer`, which automatically
/// advances the pages. The scrolling pauses when the user manually interacts
/// with the carousel and resumes after a short delay.
class PromosSections extends StatefulWidget {
  /// The list of promotional banner widgets to display in the carousel.
  final List<Widget> listOfPromos;
  const PromosSections({required this.listOfPromos, super.key});

  @override
  State<PromosSections> createState() => _PromosSectionsState();
}

/// The state for the [PromosSections] widget.
///
/// Manages the `PageController`, the auto-scroll `Timer`, and the current page index.
class _PromosSectionsState extends State<PromosSections> {
  // ===========================================================================
  // 🚀 State Variables & Controllers
  // ===========================================================================

  /// The controller for the `PageView`.
  late PageController _pageController;

  /// The timer responsible for the auto-scroll functionality.
  Timer? _timer;

  /// The index of the currently displayed page in the `PageView`.
  int _currentPage = 0;

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  /// Starts the automatic scrolling of the `PageView`.
  ///
  /// A periodic `Timer` is created that advances to the next page every 5 seconds.
  /// When it reaches the end, it loops back to the beginning.
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && widget.listOfPromos.isNotEmpty) {
        if (_currentPage < widget.listOfPromos.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Stops the automatic scrolling timer.
  void _stopAutoScroll() {
    _timer?.cancel();
  }

  /// Restart automatic scrolling after user interaction
  void _restartAutoScroll() {
    _stopAutoScroll();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  /// Builds the UI for the promotional carousel.
  ///
  /// It consists of a `PageView` for the banners and a `SmoothPageIndicator` below it.
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxWidth <= 200 ? 160 : 125,

              /// The `PageView` is wrapped in a `GestureDetector` to pause and
              /// resume auto-scrolling when the user interacts with it.
              child: GestureDetector(
                onPanDown: (_) => _stopAutoScroll(),
                onPanEnd: (_) => _restartAutoScroll(),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  children: widget.listOfPromos,
                ),
              ),
            );
          },
        ),

        /// Vertical spacing between the carousel and the page indicator.
        VerticalSpacing.sm(context),

        /// A smooth, animated page indicator that shows the current banner.
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.listOfPromos.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppPalette.primary,
            dotColor: AppPalette.secondaryText(context).withValues(alpha: 0.3),
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }
}
