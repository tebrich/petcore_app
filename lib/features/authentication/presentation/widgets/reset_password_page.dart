import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A widget that displays the initial step of the password reset process.
///
/// This UI component prompts the user to enter their email address to receive
/// a password reset link. It features a decorative illustration and a clear
/// call to action. It is designed to be used within a [PageView] as part of
/// the `ForgotPasswordPage`.
Widget resetPasswordPage(BuildContext context, Size screenSize) {
  return SafeArea(
    child: Column(
      children: [
        screenSize.height >= 675
            ? VerticalSpacing.lg(context)
            : VerticalSpacing.md(context),
        Stack(
          alignment: Alignment.center,
          children: [
            Transform.flip(
              flipX: true,
              child: SvgPicture.asset(
                'assets/illustrations/background_shape.svg',
                height: screenSize.height < 675 ? 325 : 350,
                colorFilter: ColorFilter.mode(
                  AppPalette.surfaces(context),
                  BlendMode.srcATop,
                ),
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
                  Transform.flip(
                    flipX: true,
                    child: SvgPicture.asset(
                      'assets/illustrations/background_shape.svg',
                      height: screenSize.height < 675 ? 250 : 275,
                      colorFilter: ColorFilter.mode(
                        AppPalette.primary.withValues(alpha: 0.5),
                        BlendMode.srcATop,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SvgPicture.asset(
                      'assets/illustrations/forgot_password.svg',
                      height: screenSize.height < 675 ? 175 : 200,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 0,
              left: -screenSize.width * 0.025,
              child: AnimatedIconButton(
                iconData: FontAwesomeIcons.arrowLeftLong,
                foregroundColor: AppPalette.textOnSecondaryBg(context),
                iconSize: 17.5,
                onClick: () {
                  Get.back();
                },
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
                  text: 'reset_password_title'.tr,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 32,
                  ),
                ),

                TextSpan(
                  text:
                      '\n${'reset_password_subtitle'.tr}',
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

        // Space after title
        VerticalSpacing.xl(context),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: SizedBox(
            height: 45,
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppPalette.background(context),
                labelText: 'reset_password_email'.tr,
                hintText: 'reset_password_email_hint'.tr,
                prefixIcon: Icon(
                  FontAwesomeIcons.at,
                  size: 15,
                  color: AppPalette.primary,
                ),
              ),
            ),
          ),
        ),

        // Bottom spacer - flexible for centering
        (screenSize.hashCode >= 675)
            ? const Spacer(flex: 1)
            : VerticalSpacing.lg(context),
      ],
    ),
  );
}
