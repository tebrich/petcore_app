import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/time_picker.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget dateTimeSelectionPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
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
                    controller.previousPage();
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Selecciona fecha y hora",
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: AppPalette.disabled(context)),
                ),
                child: Column(
                  children: [

                    /// 📅 FECHA + HORA ACTUAL
                    Text(
                      DateFormat("EEE dd MMM yyyy - hh:mm a", "es")
                          .format(controller.appointmentDateTime),
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 15,
                        color: AppPalette.primaryText(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    VerticalSpacing.sm(context),

                    /// 📆 CALENDARIO
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
                          hideNextMonthIcon: true,
                          hideLastMonthIcon: true,

                          calendarType: CalendarDatePicker2Type.single,
                          daySplashColor: AppPalette.primary.withValues(alpha: .1),
                          selectedDayHighlightColor: AppPalette.primary,

                          weekdayLabelTextStyle: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.textOnSecondaryBg(context),
                            fontWeight: FontWeight.w600,
                          ),

                          dayTextStyle: AppTextStyles.bodyRegular.copyWith(
                            fontSize: constraints.maxHeight > 580 ? 14 : 13,
                          ),

                          selectedDayTextStyle: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.background(context),
                            fontSize: constraints.maxHeight > 580 ? 16 : 14,
                          ),
                        ),
                        value: [controller.appointmentDateTime],

                        onValueChanged: (dates) {

                          TimeOfDay selectedTime = TimeOfDay(
                            hour: controller.appointmentDateTime.hour,
                            minute: controller.appointmentDateTime.minute,
                          );

                          controller.updateAppointmentDateTime(
                            dates.first.copyWith(
                              hour: selectedTime.hour,
                              minute: selectedTime.minute,
                              second: 0,
                              millisecond: 0,
                              microsecond: 0,
                            ),
                          );
                        },
                      ),
                    ),

                    Divider(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      indent: 24.0,
                      endIndent: 24.0,
                    ),

                    /// ⏰ TIME PICKER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTimePicker(
                        enableParent: false,
                        expandInput: true,
                        initialTime: TimeOfDay(hour: 09, minute: 30),

                        onTimeChanged: (TimeOfDay time) {
                          controller.updateAppointmentDateTime(
                            controller.appointmentDateTime.copyWith(
                              hour: time.hour,
                              minute: time.minute,
                              second: 0,
                              millisecond: 0,
                              microsecond: 0,
                            ),
                          );
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