import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

Widget appointmentTypeSelectionPage(
  Size screenSize,
  AddNewVetAppointmentPageController controller,
) {
  /// 🔥 DATOS DINÁMICOS (PERO FORMATO ORIGINAL)
  final types = controller.appointmentTypes;

  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        color: AppPalette.background(context),
        child: SafeArea(
          child: Column(
            children: [
              VerticalSpacing.md(context),

              /// 🔙 BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedIconButton(
                  iconData: Icons.arrow_back_rounded,
                  foregroundColor: AppPalette.primaryText(context),
                  onClick: () {
                    controller.pageController.previousPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    );
                  },
                ),
              ),

              /// 🧠 TITLE (MISMO FORMATO)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Tipo de consulta",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: constraints.maxHeight > 580 ? 35 : 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              VerticalSpacing.lg(context),

              /// 📋 LISTA (MISMO DISEÑO)
              Expanded(
                child: ListView.builder(
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];

                    final id = type["id"];
                    final label = type["label_es"];
                    final icon = type["icon"];

                    final isSelected =
                        controller.selectedAppointmentTypeId == id;

                    /// 🔥 MAPEO DE ICONOS (puedes mejorar luego)
                    final iconPath = _mapIcon(icon);

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: screenSize.width * 0.05,
                      ),
                      child: Material(
                        color: isSelected
                            ? AppPalette.primary.withValues(alpha: .25)
                            : AppPalette.background(context),
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          splashColor:
                              AppPalette.primary.withValues(alpha: .5),
                          onTap: () {
                            controller.selectAppointmentType(id, label);
                          },
                          child: Container(
                            height: 125,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected
                                    ? AppPalette.primary
                                    : AppPalette.disabled(context)
                                        .withValues(alpha: .5),
                              ),
                            ),
                            child: Row(
                              children: [
                                /// 🧠 ICONO
                                SvgPicture.asset(
                                  iconPath,
                                  height: 60,
                                  width: 60,
                                ),

                                const SizedBox(width: 16),

                                /// 🧠 TEXTO
                                Expanded(
                                  child: Text(
                                    label,
                                    style:
                                        AppTextStyles.playfulTag.copyWith(
                                      color: AppPalette
                                          .textOnSecondaryBg(context),
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          constraints.maxHeight > 580
                                              ? 30
                                              : 28,
                                    ),
                                  ),
                                ),

                                /// ✅ CHECK
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppPalette.primary,
                                    size: 35,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 🔥 MAPEO SIMPLE DE ICONOS (ajustable)
String _mapIcon(String iconName) {
  switch (iconName) {
    case "Check":
      return 'assets/illustrations/routine_checkup.svg';
    case "Vaccine":
      return 'assets/illustrations/vaccination2.svg';
    case "Emergency":
      return 'assets/illustrations/sick_visit.svg';
    default:
      return 'assets/illustrations/routine_checkup.svg';
  }
}