import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Página de ajustes para sincronización con calendario.
class CalendarRemindersSettingPage extends StatefulWidget {
  const CalendarRemindersSettingPage({super.key});

  @override
  State<CalendarRemindersSettingPage> createState() =>
      _CalendarRemindersSettingPageState();
}

class _CalendarRemindersSettingPageState
    extends State<CalendarRemindersSettingPage> {
  /// Variables
  late bool enableSync;
  late bool dailyReminders;
  late bool feedingReminders;
  late bool medicationReminders;
  late bool activityReminders;
  late bool groomingReminders;
  late bool enableTeminderTime;
  Duration? reminderTime;

  final _box = GetStorage();
  final String _keyCalendarSync = "settings_calendar_sync_enabled";

  /// INIT STATE
  @override
  void initState() {
    super.initState();

    // Master desde storage (default true)
    final stored = _box.read(_keyCalendarSync);
    enableSync = stored is bool ? stored : true;

    dailyReminders = true;
    feedingReminders = true;
    medicationReminders = true;
    activityReminders = true;
    groomingReminders = true;
    enableTeminderTime = true;

    if (!enableSync) {
      dailyReminders = false;
      feedingReminders = false;
      medicationReminders = false;
      activityReminders = false;
      groomingReminders = false;
      enableTeminderTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'calendar_reminders_title'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 22,
            ),
          ),
        ),
        actions: const [SizedBox(width: 24.0)],
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10,
              left: -50,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: 0.025,
                  child: SvgPicture.asset(
                    'assets/illustrations/calendar_reminder.svg',
                    height: 250,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: -50,
              child: Transform.rotate(
                angle: -0.3,
                child: Opacity(
                  opacity: 0.025,
                  child: SvgPicture.asset(
                    'assets/illustrations/clock.svg',
                    height: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing.md(context),

                  Text(
                    'calendar_reminders_title'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  VerticalSpacing.xl(context),

                  /// Master: Sincronización calendario
                  _switchTile(
                    'calendar_sync_title'.tr,
                    enableSync
                        ? 'calendar_sync_on'.tr
                        : 'calendar_sync_off'.tr,
                    enableSync,
                    (value) {
                      setState(() {
                        enableSync = value;

                        if (!value) {
                          dailyReminders = false;
                          feedingReminders = false;
                          medicationReminders = false;
                          activityReminders = false;
                          groomingReminders = false;
                          enableTeminderTime = false;
                        } else {
                          enableTeminderTime = true;
                        }
                      });

                      // 🔥 guardar en storage para usarlo como default en citas
                      _box.write(_keyCalendarSync, enableSync);
                    },
                  ),

                  VerticalSpacing.lg(context),
                  Divider(
                    color:
                        AppPalette.disabled(context).withValues(alpha: .5),
                    height: 1,
                    thickness: 1,
                  ),
                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'calendar_todo'.tr,
                      null,
                      dailyReminders,
                      (value) {
                        setState(() {
                          dailyReminders = value;
                          if (!value) enableSync = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'calendar_meals'.tr,
                      null,
                      feedingReminders,
                      (value) {
                        setState(() {
                          feedingReminders = value;
                          if (!value) enableSync = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'calendar_medication'.tr,
                      null,
                      medicationReminders,
                      (value) {
                        setState(() {
                          medicationReminders = value;
                          if (!value) enableSync = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'calendar_activity'.tr,
                      null,
                      activityReminders,
                      (value) {
                        setState(() {
                          activityReminders = value;
                          if (!value) enableSync = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.md(context),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .025,
                    ),
                    child: _switchTile(
                      'calendar_grooming'.tr,
                      null,
                      groomingReminders,
                      (value) {
                        setState(() {
                          groomingReminders = value;
                          if (!value) enableSync = false;
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.xl(context),
                  Divider(
                    color:
                        AppPalette.disabled(context).withValues(alpha: .5),
                    height: 1,
                    thickness: 1,
                  ),
                  VerticalSpacing.md(context),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'calendar_reminder_time_title'.tr,
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppPalette.textOnSecondaryBg(context),
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              '\n${'calendar_reminder_time_subtitle'.tr}',
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.secondaryText(context),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  VerticalSpacing.md(context),
                  _reminderTieWidget(),

                  VerticalSpacing.xl(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    String? subtitle,
    bool value,
    Function(bool) onUpdate,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null)
                  TextSpan(
                    text: '\n$subtitle',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.secondaryText(context),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Switch(value: value, onChanged: onUpdate),
      ],
    );
  }

  Widget _reminderTieWidget() {
    return Row(
      children: [
        Expanded(
          child: DropdownMenu<Duration>(
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('calendar_notify_before'.tr),
            ),
            enabled: enableTeminderTime,
            enableSearch: false,
            textStyle: AppTextStyles.bodyRegular.copyWith(
              color: enableTeminderTime
                  ? AppPalette.textOnSecondaryBg(context)
                  : AppPalette.disabled(context),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            onSelected: (value) {
              setState(() {
                reminderTime = value;
              });
            },
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: const Duration(minutes: 10),
                label: 'calendar_10_min'.tr,
              ),
              DropdownMenuEntry(
                value: const Duration(minutes: 30),
                label: 'calendar_30_min'.tr,
              ),
              DropdownMenuEntry(
                value: const Duration(hours: 1),
                label: 'calendar_1_hour'.tr,
              ),
              DropdownMenuEntry(
                value: const Duration(days: 1),
                label: 'calendar_1_day'.tr,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Switch(
          value: enableTeminderTime,
          onChanged: (value) {
            setState(() {
              reminderTime = null;
              enableTeminderTime = value;
            });
          },
        ),
      ],
    );
  }
}
