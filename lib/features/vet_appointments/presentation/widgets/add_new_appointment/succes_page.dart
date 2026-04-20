import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Pantalla completa de confirmación de cita ✅
class SuccessPageScreen extends StatelessWidget {
  const SuccessPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Confirmación"),
        centerTitle: true,
      ),
      body: successPage(size),
    );
  }
}

/// Contenido de la pantalla de éxito
Widget successPage(Size screenSize) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Espacio superior
          const Spacer(flex: 1),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "Cita enviada",
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: constraints.maxHeight > 580 ? 35 : 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          /// Espacio después del título
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
                duration: const Duration(seconds: 8),
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

          // Espacio después de la ilustración
          VerticalSpacing.xl(context),

          /// Textos
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "Tu solicitud de cita fue enviada correctamente.\n\n"
              "Podrás ver el estado en:\n"
              "🔔 Alertas o 📅 Mis citas.\n\n"
              "Te notificaremos cuando sea confirmada.",
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppPalette.primaryText(context),
                fontSize: constraints.maxHeight <= 580 ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Espacio inferior
          const Spacer(flex: 1),
        ],
      );
    },
  );
}
