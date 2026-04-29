// C:\peticare\peticare_app\lib\features\groom_appointments\presentation\widgets\add_new_appointment\success_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Pantalla completa de confirmación de cita de peluquería ✅
class GroomSuccessPageScreen extends StatelessWidget {
  const GroomSuccessPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/HomePage');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Confirmación"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAllNamed('/HomePage');
            },
          ),
        ),
        body: successPage(size),
      ),
    );
  }
}

/// Contenido de la pantalla de éxito (cita grooming)
Widget successPage(Size screenSize) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ESPACIO SUPERIOR
          const Spacer(flex: 1),

          /// TÍTULO
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "¡Cita confirmada!",
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: constraints.maxHeight > 580 ? 35 : 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          /// ESPACIO
          VerticalSpacing.lg(context),

          /// ILUSTRACIÓN ANIMADA
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
                        AppPalette.primary.withValues(alpha: 0.5),
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

          /// ESPACIO
          VerticalSpacing.xl(context),

          /// MENSAJE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "Tu pago fue procesado correctamente.\n\n"
              "Podrás ver el detalle de tu cita en:\n"
              "📅 Mis citas.\n\n"
              "Te enviaremos recordatorios según tus configuraciones.",
              style: AppTextStyles.bodyRegular.copyWith(
                fontWeight: FontWeight.w500,
                color: AppPalette.primaryText(context),
                fontSize: constraints.maxHeight <= 580 ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          VerticalSpacing.lg(context),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/HomePage');
                },
                child: const Text('Ir al Dashboard'),
              ),
            ),
          ),

          /// ESPACIO FINAL
          const Spacer(flex: 1),
        ],
      );
    },
  );
}
