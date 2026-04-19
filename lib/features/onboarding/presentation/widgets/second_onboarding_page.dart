import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// A widget function that builds the second onboarding screen.
///
/// This page highlights the expert grooming and hygiene services offered
/// by the application. It uses a stack of widgets to create a visually
/// engaging layout with animated elements.
///
/// Key UI elements include:
/// - A background shape (`background_shape.svg`) that provides a surface for the content.
/// - A central illustration (`bathing.svg`) that represents the grooming and hygiene services.
/// - Animated floating elements, including grooming tools, to add visual interest.
/// - Text elements that describe the grooming services, including a title and a subtitle.
///
/// The animated elements are implemented using the `FloatingAnimation` widget,
/// which provides a subtle motion effect. The layout adapts to different
/// screen heights.
///
/// The `screenSize` parameter is used to adjust the layout and font sizes
/// based on the device's screen dimensions. The function also uses
/// `AppPalette` and `AppTextStyles` for consistent styling.
///
/// The widget utilizes:
/// - [SvgPicture] for displaying SVG images.
/// - [FloatingAnimation] for creating floating animations.
/// - [Stack] for layering widgets.
/// - [Positioned] for absolute positioning of widgets within the stack.
/// - [Text.rich] for creating text with multiple styles.

Widget secondOnBoardingPage(BuildContext context, Size screenSize) {
  return Column(
    children: [
      screenSize.height < 675 ? SizedBox() : Spacer(flex: 1),
      Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/illustrations/background_shape.svg',
            height: screenSize.height < 675 ? 320 : 350,
            colorFilter: ColorFilter.mode(
              AppPalette.surfaces(context),
              BlendMode.srcATop,
            ),
          ),
          FloatingAnimation(
            type: FloatingType.pulse,
            duration: Duration(seconds: 13),
            floatStrength: 1.25,
            curve: Curves.linear,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/background_shape.svg',
                  height: screenSize.height < 675 ? 250 : 275,
                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(alpha: 0.5),
                    BlendMode.srcATop,
                  ),
                ),
                Positioned(
                  bottom: -7.5,
                  child: SvgPicture.asset(
                    'assets/illustrations/bathing.svg',
                    height: screenSize.height < 675 ? 200 : 225,
                  ),
                ),

                /* Positioned(
                  top: 90,
                  right: 90,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 15),
                    floatStrength: 2.0,
                    curve: Curves.easeInOut,
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: Opacity(
                        opacity: .5,
                        child: SvgPicture.asset(
                          'assets/illustrations/sampoo.svg',
                          height: 25,
                        ),
                      ),
                    ),
                  ),
                ),*/
                Positioned(
                  top: 25,
                  left: 40,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 7),
                    floatStrength: 4.0,
                    curve: Curves.linear,
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: Opacity(
                        opacity: .85,
                        child: SvgPicture.asset(
                          'assets/illustrations/grooming_tools.svg',
                          height: 45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //const Spacer(flex: 3),
      VerticalSpacing.xl(context),

      /// Texts
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'onboarding_2_title'.tr,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.primaryText(context),
                  fontSize: 35,
                ),
              ),

              TextSpan(
                text:
                    '\n${'onboarding_2_subtitle'.tr}',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppPalette.secondaryText(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const Spacer(flex: 2),
    ],
  );
}
