import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

Widget welcomingFirstPage(Size screenSize) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Top spacing
              const Spacer(flex: 1),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Nueva Cita de Peluquería!",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: constraints.maxHeight > 580 ? 35 : 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Space after Title
              VerticalSpacing.lg(context),

              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: constraints.maxHeight <= 580
                        ? constraints.maxHeight * 0.55
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
                              ? constraints.maxHeight * 0.45
                              : 275,
                          colorFilter: ColorFilter.mode(
                            AppPalette.primary.withValues(alpha: 0.5),
                            BlendMode.srcATop,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: SvgPicture.asset(
                            'assets/illustrations/add_new_grooming_appointment.svg',
                            height: constraints.maxHeight <= 580
                                ? constraints.maxHeight * .3
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
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Elige el servicio y completa los datos para agendar la cita de tu mascota.",
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.primaryText(context),
                    fontSize: constraints.maxHeight <= 580 ? 15 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Bottom spacer - flexible for centering
              const Spacer(flex: 1),
            ],
          ),

          /// A "close" button positioned at the top left to allow the user to exit the flow.
          Positioned(
            top: constraints.maxHeight * 0.075,
            left: 8,
            child: AnimatedIconButton(
              iconData: Icons.close_rounded,
              foregroundColor: AppPalette.primaryText(context),
              onClick: Get.back,
            ),
          ),
        ],
      );
    },
  );
}
