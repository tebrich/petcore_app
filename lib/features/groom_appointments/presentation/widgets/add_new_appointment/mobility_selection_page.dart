import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget mobilitySelectionPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          VerticalSpacing.md(context),

          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedIconButton(
              iconData: Icons.arrow_back_rounded,
              foregroundColor: AppPalette.primaryText(context),
              onClick: () {
                controller.previousPage();
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Text(
              "¿Dónde deseas el servicio de peluquería?",
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: constraints.maxHeight > 580 ? 30 : 28,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          VerticalSpacing.lg(context),

          Expanded(
            child: ListView(
              children: [

                /// 🏥 EN CLÍNICA
                _cardBuilder(
                  context,
                  screenSize,
                  'En clínica',
                  'assets/illustrations/grooming_store.svg',
                  'Lleva tu mascota a una peluquería especializada.',
                  !(controller.isMobileGrooming ?? true),
                  () async {
                    controller.updateGroomingServiceMobility(false);
                    await controller.fetchGroomers();

                    if (controller.isMobileGrooming != null) {
                      controller.nextPage();
                    }
                  },
                ),

                /// 🚐 A DOMICILIO
                _cardBuilder(
                  context,
                  screenSize,
                  'A domicilio',
                  'assets/illustrations/mobile_grooming.svg',
                  'Un profesional va a tu casa. Ideal para mascotas sensibles.',
                  controller.isMobileGrooming ?? false,
                  () async {
                    controller.updateGroomingServiceMobility(true);
                    await controller.fetchGroomers();

                    if (controller.isMobileGrooming != null) {
                      controller.nextPage();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

//////////////////////////////////////////////////////////////
/// 🔥 CARD BUILDER FINAL (ESTABLE Y LIMPIO)
//////////////////////////////////////////////////////////////

Widget _cardBuilder(
  BuildContext context,
  Size screenSize,
  String title,
  String assetPath,
  String description,
  bool isSelected,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue.withOpacity(0.1)
            : Colors.white,
        border: Border.all(
          color: isSelected
              ? Colors.blue
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          /// ICONO
          SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset(assetPath),
          ),

          const SizedBox(width: 16),

          /// TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 18,
                    color: AppPalette.primaryText(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          /// CHECK
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.blue,
            ),
        ],
      ),
    ),
  );
}