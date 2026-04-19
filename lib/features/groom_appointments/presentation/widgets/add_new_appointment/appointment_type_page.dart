import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget appointmentTypeSelectionPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
) {

  Map<String, Map<String, String>> appointmentTypes = {

    'Baño Completo': {
      'icon': 'assets/illustrations/bath.svg',
      'subtitle':
          'Baño, corte de pelo, corte de uñas y limpieza de oídos — tratamiento completo',
    },

    'Corte de Pelo': {
      'icon': 'assets/illustrations/grooming_tools.svg',
      'subtitle': 'Corte o retoque de estilo',
    },

    'Solo Baño': {
      'icon': 'assets/illustrations/bathtub.svg',
      'subtitle': 'Baño, secado y cepillado — sin corte',
    },

    'Corte de Uñas': {
      'icon': 'assets/illustrations/nails.svg',
      'subtitle': 'Corte o limado de uñas',
    },

    'Limpieza de Oídos': {
      'icon': 'assets/illustrations/ear_cleaning.svg',
      'subtitle': 'Limpieza suave y revisión de oídos',
    },

    'Tratamiento Antipulgas/Garrapatas': {
      'icon': 'assets/illustrations/meds2.svg',
      'subtitle': 'Baño medicado o tratamiento tópico',
    },
  };

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
              "Tipo de servicio",
              style: AppTextStyles.headingLarge.copyWith(
                color: AppPalette.textOnSecondaryBg(context),
                fontSize: constraints.maxHeight > 580 ? 35 : 32,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          VerticalSpacing.lg(context),

          Expanded(
            child: ListView.builder(
              itemCount: appointmentTypes.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenSize.width * 0.05,
                ),
                child: Material(
                  color: controller.appointmentType ==
                          appointmentTypes.keys.elementAt(index)
                      ? AppPalette.primary.withValues(alpha: .25)
                      : AppPalette.background(context),
                  borderRadius: BorderRadius.all(Radius.circular(15)),

                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    splashColor: AppPalette.primary.withValues(alpha: .5),

                    onTap: () {
                      controller.updateAppointmentType(
                        appointmentTypes.keys.elementAt(index),
                      );
                    },

                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight > 580 ? 145 : 120,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color: controller.appointmentType ==
                                  appointmentTypes.keys.elementAt(index)
                              ? AppPalette.primary
                              : AppPalette.disabled(context)
                                  .withValues(alpha: .5),
                        ),
                      ),

                      padding: EdgeInsets.all(16.0),

                      child: Row(
                        children: [

                          SvgPicture.asset(
                            appointmentTypes.values.elementAt(index)['icon']!,
                            height: 50,
                            width: 50,
                          ),

                          const SizedBox(width: 16.0),

                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [

                                  TextSpan(
                                    text: appointmentTypes.keys.elementAt(index),
                                    style: AppTextStyles.playfulTag.copyWith(
                                      color: AppPalette.textOnSecondaryBg(context),
                                      fontWeight: FontWeight.w600,
                                      fontSize: constraints.maxHeight > 580
                                          ? 25
                                          : 22,
                                    ),
                                  ),

                                  TextSpan(
                                    text:
                                        '\n${appointmentTypes.values.elementAt(index)['subtitle']!}',
                                    style: AppTextStyles.bodyRegular.copyWith(
                                      color: AppPalette.secondaryText(context),
                                      fontWeight: FontWeight.w500,
                                      fontSize: constraints.maxHeight > 580
                                          ? 14
                                          : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8.0),

                          if (controller.appointmentType ==
                              appointmentTypes.keys.elementAt(index))
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
              ),
            ),
          ),
        ],
      );
    },
  );
}