import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/time_picker.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';

Widget dateTimeSelectionPage(
  Size screenSize,
  AddNewVetAppointmentPageController controller,
) {
  return SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              VerticalSpacing.md(context),

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

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Escoja la fecha & hora",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: constraints.maxHeight > 580 ? 35 : 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              VerticalSpacing.md(context),

              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: .05),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: AppPalette.disabled(context)),
                ),
                child: Column(
                  children: [

                    /// 🔥 FECHA MOSTRADA
                    Text(
                      DateFormat("EEE., MMM dd, yyy hh:mm a").format(
                        controller.appointmentDateTime ?? DateTime.now(),
                      ),
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 15,
                        color: AppPalette.primaryText(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    VerticalSpacing.sm(context),

                    SizedBox(
                      height: constraints.maxHeight > 665
                          ? 350
                          : constraints.maxHeight -
                              (307 +
                                  VerticalSpacing.sm(context).spacing +
                                  VerticalSpacing.md(context).spacing),
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2060, 12, 12),
                          calendarType: CalendarDatePicker2Type.single,
                          selectedDayHighlightColor: AppPalette.primary,
                        ),

                        value: [
                          controller.appointmentDateTime ?? DateTime.now(),
                        ],

                        /// 🔥 FIX REAL
                        onValueChanged: (dates) {
                          if (dates.isEmpty || dates.first == null) return;

                          final selectedDate = dates.first!;

                          final current = controller.appointmentDateTime ?? DateTime.now();

                          final finalDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            current.hour,
                            current.minute,
                          );

                          controller.updateAppointmentDateTime(finalDateTime);
                        },
                      ),
                    ),

                    Divider(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      indent: 24.0,
                      endIndent: 24.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTimePicker(
                        enableParent: false,
                        expandInput: true,
                        initialTime: const TimeOfDay(hour: 9, minute: 30),

                        /// 🔥 FIX REAL
                        onTimeChanged: (TimeOfDay time) {

                          final current = controller.appointmentDateTime ?? DateTime.now();

                          final finalDateTime = DateTime(
                            current.year,
                            current.month,
                            current.day,
                            time.hour,
                            time.minute,
                          );

                          controller.updateAppointmentDateTime(finalDateTime);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              VerticalSpacing.sm(context),
            ],
          ),
        );
      },
    ),
  );
}