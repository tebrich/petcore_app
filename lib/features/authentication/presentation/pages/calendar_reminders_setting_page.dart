import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';


/// A settings page for managing calendar synchronization.
///
/// This page allows users to control which Peticare events are synced to their
/// device's native calendar and to set default alert times for those events.
/// The layout is built within a `SingleChildScrollView` and includes decorative
/// background illustrations.
///
/// Key UI elements include:
/// - A main "Calendar Sync" switch that acts as a master control, enabling or
///   disabling all calendar synchronization.
/// - A series of individual `_switchTile` widgets for fine-grained control over
///   which specific event types are synced, such as:
///   - To-Do Notifications
///   - Meal Reminders
///   - Medication Alerts
/// - A section to configure a default reminder time (e.g., "10 mins before")
///   using a `DropdownMenu` and an associated `Switch`.
///
/// The state for each setting is managed locally within the `_CalendarRemindersSettingPageState`.
class CalendarRemindersSettingPage extends StatefulWidget {
  const CalendarRemindersSettingPage({super.key});

  @override
  State<CalendarRemindersSettingPage> createState() =>
      _CalendarRemindersSettingPageState();
}

/// Manages the state for the [CalendarRemindersSettingPage].
///
/// This state class holds the boolean flags for the main sync toggle and each
/// individual event type. It also manages the state for the default reminder
/// time dropdown. It includes logic to handle the master switch's behavior,
/// where disabling "Calendar Sync" also disables all other related toggles on the page.
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

  /// INIT STATE
  @override
  void initState() {
    super.initState();
    enableSync = true;
    dailyReminders = true;
    feedingReminders = true;
    medicationReminders = true;
    activityReminders = true;
    groomingReminders = true;
    enableTeminderTime = true;
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
        actions: [SizedBox(width: 24.0)],
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
                  // Heading Space
                  VerticalSpacing.md(context),

                  Text(
                    'calendar_reminders_title'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  // Sections Spacing
                  VerticalSpacing.xl(context),
                  _switchTile(
                    'calendar_sync_title'.tr,
                    enableSync 
                        ? 'calendar_sync_on'.tr: 'calendar_sync_off'.tr,
                    enableSync,
                    (value) {
                      if (value == false) {
                        setState(() {
                          enableSync = false;
                          dailyReminders = false;
                          feedingReminders = false;
                          medicationReminders = false;
                          activityReminders = false;
                          groomingReminders = false;
                          enableTeminderTime = false;
                        });
                      } else {
                        setState(() {
                          enableSync = true;
                          enableTeminderTime = true;
                        });
                      }
                    },
                  ),
                  VerticalSpacing.lg(context),
                  Divider(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
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
                        });
                      },
                    ),
                  ),

                  VerticalSpacing.xl(context),
                  Divider(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
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

                  /// Bottom Spacing
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
                value: Duration(minutes: 10),
                label: 'calendar_10_min'.tr,
              ),
              DropdownMenuEntry(
                value: Duration(minutes: 30),
                label: 'calendar_30_min'.tr,
              ),
              DropdownMenuEntry(
                value: Duration(hours: 1),
                label: 'calendar_1_hour'.tr,
              ),
              DropdownMenuEntry(
                value: Duration(days: 1),
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
