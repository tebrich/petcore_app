import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/all_health_alerts_list.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';

/// A widget function that builds the "Health Alerts" section for the dashboard.
///
/// This function constructs a `Column` containing a title and a list of health
/// alerts. Each alert is wrapped in an `OpenContainer` from the `animations`
/// package, which provides a seamless transition to the detailed `HealthAlertPage`
/// when an alert is tapped.
///
/// [context] The build context.
/// [screenSize] The size of the screen, used for responsive padding.
///
/// > **Note:** The number of alerts is currently hardcoded. This should be replaced
/// with a dynamic value from a state management solution.
Widget healthAlerts(BuildContext context, Size screenSize) {
  // -----------------------------------------------------------------------------
  // NOTE: The value below is a placeholder for demonstration purposes only.
  // 'alertsNumber' should not be hardcoded. Replace this static value with a
  // dynamically fetched value from your database, API, or state management source
  // (e.g., Firestore, Supabase, or local provider) to display the real number of
  // health alerts associated with the current user or pet profile.
  // -----------------------------------------------------------------------------
  const int alertsNumber = 3;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Title
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Text(
          'health_alerts_title'.trParams({
            'count': alertsNumber.toString(),
          }),
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 17,
            color: AppPalette.textOnSecondaryBg(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      /// Heath Alerts List
      ...DummyData.healthAlertsList(context).map(
        (element) => OpenContainer(
          openColor: AppPalette.background(context),
          closedColor: AppPalette.background(context),
          closedElevation: 0,
          closedBuilder: (context, action) =>
              healthAlertWidget(context, screenSize.width, element),
          openBuilder: (context, action) =>
              HealthAlertPage(healthAlert: element),
        ),
      ),
    ],
  );
}

/// Builds a single list item widget for a health alert summary.
///
/// This widget displays a concise summary of a health alert, including a
/// severity-colored icon, the alert name, the concerned pet's name, and a
/// brief description. It is designed to be used within a `ListView`.
///
/// [context] The build context.
/// [width] The width of the widget, typically the screen width.
/// [healthAlertDetails] A map containing the details of the specific alert.
///
/// > **Refactoring Note:** This function should be refactored to accept a strongly-typed `HealthAlert` model object instead of a `Map` for better type safety.
Widget healthAlertWidget(
  BuildContext context,
  double width,
  Map<String, dynamic> healthAlertDetails,
) {
  // -----------------------------------------------------------------------------
  /// NOTE: Refactor this section to use strongly typed entities and models
  /// instead of raw maps.
  ///
  /// This will improve type safety, maintainability, and make it easier to
  /// integrate with your domain layer or state management solution.
  // -----------------------------------------------------------------------------

  String alertName = healthAlertDetails['alert'];
  Map<String, dynamic> alertDetails = allHealthAlerts[alertName] ?? {};
  Map<String, dynamic> conernedPetDetails = healthAlertDetails['conerned_pet'];

  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// //
  return Container(
    width: width,
    margin: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: AppPalette.background(context),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      leading: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: alertDetails['severity'] == "Urgent"
              ? AppPalette.danger(context).withValues(alpha: .4)
              : alertDetails['severity'] == "Medium"
              ? AppPalette.warning(context).withValues(alpha: .6)
              : AppPalette.success(context).withValues(alpha: .4),
        ),
        child: SvgPicture.asset(alertDetails['icon'], fit: BoxFit.contain),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            /// Health Alert Type
            TextSpan(
              text: alertName,
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppPalette.primaryText(context),
              ),
            ),

            /// Pet Name
            TextSpan(
              text: ' (${conernedPetDetails['name']})',
              style: AppTextStyles.playfulTag.copyWith(
                fontSize: 14,
                color: AppPalette.textOnSecondaryBg(context),
              ),
            ),
          ],
        ),
      ),

      subtitle: Text(
        alertDetails['description'],
        style: AppTextStyles.bodyRegular.copyWith(
          fontSize: 12,
          color: AppPalette.disabled(context),
        ),
      ),
    ),
  );
}

/// A full-screen page that displays detailed information about a specific health alert.
///
/// This page provides an in-depth view of a health alert, including:
/// - A summary card with the alert name, pet name, and severity.
/// - Call-to-action (CTA) buttons based on the alert's recommendations.
/// - A detailed explanation of "Possible Causes".
/// - A list of "Recommended Actions" for the pet owner.
///
/// The page is typically presented via a transition from the `healthAlertWidget`.
///
/// > **Refactoring Note:** This page currently relies on `Map<String, dynamic>` for data.
/// For a production application, this should be refactored to use a strongly-typed
/// `HealthAlert` model to ensure data integrity and easier state management.
class HealthAlertPage extends StatelessWidget {
  /// The health alert data to display on the page.
  final Map<String, dynamic> healthAlert;
  const HealthAlertPage({required this.healthAlert, super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // -----------------------------------------------------------------------------
    /// NOTE: Refactor this section to use strongly typed entities and models
    /// instead of raw maps.
    ///
    /// This will improve type safety, maintainability, and make it easier to
    /// integrate with your domain layer or state management solution.
    // -----------------------------------------------------------------------------
    String alertName = healthAlert['alert'];
    Map<String, dynamic> alertDetails = allHealthAlerts[alertName] ?? {};
    Map<String, dynamic> conernedPetDetails = healthAlert['conerned_pet'];

    /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// ///

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 30,
          width: 30,
          child: AnimatedIconButton(
            iconData: Icons.close,
            onClick: Get.back,
            foregroundColor: AppPalette.primaryText(context),
            size: Size(30, 30),
          ),
        ),
        title: Text(
          'health_alert_details_title'.tr,
          style: AppTextStyles.headingMedium.copyWith(
            color: AppPalette.textOnSecondaryBg(context),
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Alert Details
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * .05,
                  vertical: 8.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16.0),

                decoration: BoxDecoration(
                  color: AppPalette.surfaces(context),
                  /* boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],*/
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /// Pet Avatar
                        /* healthAlert['conerned_pet']['avatar'](
                          80.0,
                          0.9,
                          healthAlert['conerned_pet'] == 'Female'
                              ? AppPalette.roseQuartz
                              : AppPalette.softBlue,
                        ),*/
                        Container(
                          height: 70.0,
                          width: 70.0,
                          padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.primary.withValues(alpha: .75),
                          ),
                          child: SvgPicture.asset(
                            alertDetails['icon'],
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// Some Horizontal Spacing
                        const SizedBox(width: 16.0),

                        /// Alert
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: alertName,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.primaryText(context),
                                ),
                              ),

                              /// Pet Name
                              TextSpan(
                                text: '\n${conernedPetDetails['name']}\n',
                                style: AppTextStyles.playfulTag.copyWith(
                                  fontSize: 14,
                                  color: AppPalette.secondaryText(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              /// Severity
                              WidgetSpan(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.5),
                                    ),
                                    color: alertDetails['severity'] == "Urgent"
                                        ? AppPalette.danger(context)
                                        : alertDetails['severity'] == "Medium"
                                        ? AppPalette.warning(context)
                                        : AppPalette.success(context),
                                  ),
                                  child: Text(
                                    alertDetails['severity'],
                                    style: AppTextStyles.playfulTag.copyWith(
                                      fontSize: 12,
                                      color: AppPalette.background(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),

                    /// Some Vertical Spacing
                    VerticalSpacing.md(context),

                    /// Alert Description
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'health_alert_details_section'.tr,
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.primaryText(context),
                            ),
                          ),

                          /// Pet Name
                          TextSpan(
                            text: '\n${alertDetails['description']}',
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 14,
                              color: AppPalette.secondaryText(context),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),

                    /// CTA Vertical Spacing
                    VerticalSpacing.md(context),
                    AnimatedElevatedButton(
                      text: alertDetails['CTA'].first,
                      size: Size(screenSize.width * .8, 40),
                      textStyle: AppTextStyles.ctaBold.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      radius: BorderRadius.circular(10),
                      onClick: () {},
                    ),

                    /// CTA Vertical Spacing
                    if (alertDetails['CTA'].length > 1)
                      VerticalSpacing.sm(context),
                    if (alertDetails['CTA'].length > 1)
                      AnimatedElevatedButton(
                        text: "",
                        size: Size(screenSize.width * .8, 40),

                        radius: BorderRadius.circular(10),
                        backgroundcolor: AppPalette.secondaryText(context),

                        onClick: () {},
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            alertDetails['CTA'][1],
                            style: AppTextStyles.ctaBold.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              /// Section Vertical Spacing
              VerticalSpacing.lg(context),

              /// Alert Possible Causes
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * .05,
                  vertical: 8.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16.0),

                decoration: BoxDecoration(
                  color: AppPalette.surfaces(context),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'health_alert_possible_causes'.tr + '\n',
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppPalette.primaryText(context),
                          height: .5,
                        ),
                      ),

                      TextSpan(
                        text: '\n${alertDetails['possible_causes']}',
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontSize: 12.5,
                          color: AppPalette.secondaryText(context),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              /// Section Vertical Spacing
              VerticalSpacing.lg(context),

              /// Alert Recommended Actions
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * .05,
                  vertical: 8.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16.0),

                decoration: BoxDecoration(
                  color: AppPalette.surfaces(context),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'health_alert_recommended_actions'.tr + '\n',
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppPalette.primaryText(context),
                          height: .7,
                        ),
                      ),

                      ...(alertDetails['recommended_actions'] as List<String>)
                          .map(
                            (element) => TextSpan(
                              text: '\n• $element',
                              style: AppTextStyles.bodyRegular.copyWith(
                                fontSize: 12.5,
                                color: AppPalette.secondaryText(context),
                              ),
                            ),
                          ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              /// Some Bottom Vertical Spacing
              VerticalSpacing.md(context),
            ],
          ),
        ),
      ),
    );
  }
}
