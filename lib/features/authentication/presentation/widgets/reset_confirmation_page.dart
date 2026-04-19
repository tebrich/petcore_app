import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// A widget that displays a confirmation message after a password reset email has been sent.
///
/// This UI component informs the user that the reset link is on its way.
/// It features a success-themed illustration and is designed to be used within
/// a [PageView] as the final step of the `ForgotPasswordPage`.
Widget resetConfirmationPage(BuildContext context, Size screenSize) {
  return SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (screenSize.height >= 675) const Spacer(flex: 2),
        Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/illustrations/background_shape.svg',
              height: screenSize.height < 675 ? 350 : 375,
              colorFilter: ColorFilter.mode(
                AppPalette.success(context).withValues(alpha: 0.5),
                BlendMode.srcATop,
              ),
            ),
            FloatingAnimation(
              type: FloatingType.wave,
              duration: Duration(seconds: 8),
              floatStrength: 2.5,
              curve: Curves.linear,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: screenSize.height < 675 ? 275 : 300,
                    colorFilter: ColorFilter.mode(
                      AppPalette.primary.withValues(alpha: 0.5),
                      BlendMode.srcATop,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SvgPicture.asset(
                      'assets/illustrations/email_sent.svg',
                      height: screenSize.height < 675 ? 175 : 200,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Space after illustration
        VerticalSpacing.xl(context),

        /// Texts
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'reset_confirmation_title'.tr,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 32,
                  ),
                ),

                TextSpan(
                  text:
                      '\n${'reset_confirmation_subtitle'.tr}',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.disabled(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Bottom spacer - flexible for centering
        (screenSize.hashCode >= 675)
            ? const Spacer(flex: 3)
            : VerticalSpacing.lg(context),
      ],
    ),
  );
}
