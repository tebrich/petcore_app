import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:peticare/core/commn/presentation/widgets/animated_paw.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDarkMode = Theme.brightnessOf(context) == Brightness.dark;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [
                    AppPalette.primary.withValues(alpha: 0.025),
                    AppPalette.primary.withValues(alpha: 0.125),
                    AppPalette.primary.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : RadialGradient(
                  colors: [
                    AppPalette.primary.withValues(alpha: 0.285),
                    AppPalette.primary.withValues(alpha: 0.3),
                    AppPalette.primary.withValues(alpha: 0.4),
                    AppPalette.primary.withValues(alpha: 0.45),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(flex: screenSize.height < 675 ? 2 : 3),

              /// Illustration
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: screenSize.height < 675 ? 225 : 250,
                    colorFilter: ColorFilter.mode(
                      AppPalette.primary.withValues(alpha: 0.5),
                      BlendMode.srcATop,
                    ),
                  ),
                  Positioned(
                    bottom: -35,
                    child: SvgPicture.asset(
                      'assets/illustrations/happy_pets.svg',
                      height: screenSize.height < 675 ? 250 : 275,
                    ),
                  ),

                  Positioned(
                    bottom: -10,
                    left: -32.5,
                    child: AnimatedPaw(
                      rotationAngle: 20,
                      pawColor: AppPalette.primary.withValues(
                        alpha: isDarkMode ? 0.1 : 0.35,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: -27.5,
                    child: AnimatedPaw(
                      rotationAngle: 20,
                      pawSize: 40,
                      pawColor: AppPalette.primary.withValues(
                        alpha: isDarkMode ? 0.2 : 0.45,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: -30,
                    child: AnimatedPaw(
                      rotationAngle: 20,
                      pawColor: AppPalette.primary.withValues(
                        alpha: isDarkMode ? 0.2 : 0.45,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    right: -25,
                    child: AnimatedPaw(
                      rotationAngle: 20,
                      pawSize: 40,
                      pawColor: AppPalette.primary.withValues(
                        alpha: isDarkMode ? 0.15 : 0.4,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 4),

              /// 🌍 TEXTOS (TRADUCIDOS)
              Text(
                'welcome_title'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.textOnSecondaryBg(context),
                  fontSize: 35,
                ),
              ),

              const Spacer(flex: 2),

              AnimatedElevatedButton(
                size: Size(screenSize.width * 0.6, 55),
                backgroundcolor: AppPalette.primary,
                text: 'welcome_get_started'.tr,
                onClick: () {
                  Get.toNamed('/onBoarding');
                },
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
