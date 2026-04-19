import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A widget function that builds the success confirmation screen. ✅
///
/// This widget serves as the final step in the `PageView` of the
/// `AddNewVetAppoitnmentPage`. It is displayed after the user has successfully
/// confirmed and paid for their appointment.
///
/// Key UI elements include:
/// - A prominent "Success" title.
/// - A central illustration (`happy_pet_chekmark.svg`) enhanced with a
///   `FloatingAnimation` for subtle motion.
/// - A descriptive text confirming that the appointment has been scheduled.
///
/// The "Done" button in the `BottomNavigationBar` of the parent page will
/// typically navigate the user away from this flow.
///
/// [screenSize] The size of the screen, used for responsive layouts.
Widget successPage(Size screenSize) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Top spacing
          const Spacer(flex: 1),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "Success",
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: constraints.maxHeight > 580 ? 35 : 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          /// Space after Title
          VerticalSpacing.lg(context),

          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/illustrations/background_shape.svg',
                height: constraints.maxHeight <= 580
                    ? constraints.maxHeight * 0.65
                    : 350,
                colorFilter: ColorFilter.mode(
                  AppPalette.surfaces(context),
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
                      height: constraints.maxHeight <= 580
                          ? constraints.maxHeight * 0.5
                          : 275,
                      colorFilter: ColorFilter.mode(
                        AppPalette.primary.withValues(alpha: .5),
                        BlendMode.srcATop,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: SvgPicture.asset(
                        'assets/illustrations/happy_pet_chekmark.svg',
                        height: constraints.maxHeight <= 580
                            ? constraints.maxHeight * .375
                            : 200,
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
            child: Text(
              "Your appointment has been successfully scheduled",
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppPalette.primaryText(context),
                fontSize: constraints.maxHeight <= 580 ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Bottom spacer
          const Spacer(flex: 1),
        ],
      );
    },
  );
}
