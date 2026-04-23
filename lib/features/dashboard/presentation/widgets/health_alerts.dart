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

Widget healthAlerts(BuildContext context, Size screenSize) {
  // Construimos la lista directamente desde allHealthAlerts (manteniendo las claves originales)
  final allAlerts = allHealthAlerts.entries.map((entry) {
    return {
      'alert': entry.key,
      // healthAlertWidget / HealthAlertPage esperan 'conerned_pet' — dejamos vacío por catálogo
      'conerned_pet': {'name': ''},
    };
  }).toList();

  final displayAlerts = allAlerts; // muestra TODO el catálogo
  final int alertsNumber = displayAlerts.length;

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

      /// Health Alerts List (desde allHealthAlerts)
      ...displayAlerts.map(
        (element) {
          return OpenContainer(
            openColor: AppPalette.background(context),
            closedColor: AppPalette.background(context),
            closedElevation: 0,
            closedBuilder: (context, action) =>
                healthAlertWidget(context, screenSize.width, element),
            openBuilder: (context, action) =>
                HealthAlertPage(healthAlert: element),
          );
        },
      ),
    ],
  );
}

/// Builds a single list item widget for a health alert summary.
Widget healthAlertWidget(
  BuildContext context,
  double width,
  Map<String, dynamic> healthAlertDetails,
) {
  // -----------------------------------------------------------------------------
  // NOTE: Refactor this section to use strongly typed entities and models
  // instead of raw maps.
  // -----------------------------------------------------------------------------

  final String alertName = (healthAlertDetails['alert'] as String?) ?? '';

  // Normalizamos la clave para buscar en las traducciones (mismo patrón que en es_es.dart)
  String _sanitizedKey(String name) =>
      'alert_' + name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '_');

  final String displayName = _sanitizedKey(alertName).tr;

  final Map<String, dynamic> alertDetails =
      (allHealthAlerts[alertName] as Map<String, dynamic>?) ?? {};
  final Map<String, dynamic> conernedPetDetails =
      (healthAlertDetails['conerned_pet'] as Map<String, dynamic>?) ??
          {'name': ''};

  // Protegemos CTA cuando sea necesario
  final List<dynamic> ctaList =
      (alertDetails['CTA'] is List) ? List.from(alertDetails['CTA']) : <dynamic>[];

  return Container(
    width: width,
    margin: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: AppPalette.background(context),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
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
        child: alertDetails['icon'] != null
            ? SvgPicture.asset(alertDetails['icon'], fit: BoxFit.contain)
            : const SizedBox.shrink(),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  /// Health Alert Type (displayName traducido si existe)
                  TextSpan(
                    text: displayName,
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppPalette.primaryText(context),
                    ),
                  ),

                  /// Pet Name
                  TextSpan(
                    text: ' (${conernedPetDetails['name'] ?? ''})',
                    style: AppTextStyles.playfulTag.copyWith(
                      fontSize: 14,
                      color: AppPalette.textOnSecondaryBg(context),
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      subtitle: Text(
        alertDetails['description'] ?? '',
        style: AppTextStyles.bodyRegular.copyWith(
          fontSize: 12,
          color: AppPalette.disabled(context),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

class HealthAlertPage extends StatelessWidget {
  final Map<String, dynamic> healthAlert;
  const HealthAlertPage({required this.healthAlert, super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final String alertName = (healthAlert['alert'] as String?) ?? '';
    final Map<String, dynamic> alertDetails =
        (allHealthAlerts[alertName] as Map<String, dynamic>?) ?? {};
    final Map<String, dynamic> conernedPetDetails =
        (healthAlert['conerned_pet'] as Map<String, dynamic>?) ??
            {'name': ''};

    final List<dynamic> ctaList =
        (alertDetails['CTA'] is List) ? List.from(alertDetails['CTA']) : <dynamic>[];
    final String primaryCta =
        ctaList.isNotEmpty ? ctaList.first.toString().toLowerCase() : '';

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
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: 70.0,
                          padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.primary.withValues(alpha: .75),
                          ),
                          child: alertDetails['icon'] != null
                              ? SvgPicture.asset(
                                  alertDetails['icon'],
                                  fit: BoxFit.contain,
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: 16.0),

                        Expanded(
                          child: Text.rich(
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

                                TextSpan(
                                  text: '\n${conernedPetDetails['name']}\n',
                                  style: AppTextStyles.playfulTag.copyWith(
                                    fontSize: 14,
                                    color: AppPalette.secondaryText(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

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
                                      alertDetails['severity'] ?? '',
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
                        ),
                      ],
                    ),

                    VerticalSpacing.md(context),

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

                          TextSpan(
                            text: '\n${alertDetails['description'] ?? ''}',
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontSize: 14,
                              color: AppPalette.secondaryText(context),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),

                    VerticalSpacing.md(context),

                    AnimatedElevatedButton(
                      text: ctaList.isNotEmpty
                          ? ctaList.first.toString()
                          : 'Reservar cita veterinaria',
                      size: Size(screenSize.width * .8, 40),
                      textStyle: AppTextStyles.ctaBold.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      radius: BorderRadius.circular(10),
                      onClick: () {
                        final primary = primaryCta;
                        if (primary.contains("book vet appointment") ||
                            primary.contains("reservar")) {
                          Get.toNamed('/NewVetAppointment');
                        } else if (primary.contains("buy") ||
                            primary.contains("comprar")) {
                          // Get.toNamed('/Shopping');
                        }
                      },
                    ),

                    if (ctaList.length > 1) VerticalSpacing.sm(context),
                    if (ctaList.length > 1)
                      AnimatedElevatedButton(
                        text: "",
                        size: Size(screenSize.width * .8, 40),
                        radius: BorderRadius.circular(10),
                        backgroundcolor: AppPalette.secondaryText(context),
                        onClick: () {},
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            ctaList.length > 1 ? ctaList[1].toString() : '',
                            style: AppTextStyles.ctaBold.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              VerticalSpacing.lg(context),

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
                        text: '\n${alertDetails['possible_causes'] ?? ''}',
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

              VerticalSpacing.lg(context),

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
                      ...(alertDetails['recommended_actions'] is List
                          ? (alertDetails['recommended_actions'] as List)
                              .map(
                                (element) => TextSpan(
                                  text: '\n• $element',
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    fontSize: 12.5,
                                    color: AppPalette.secondaryText(context),
                                  ),
                                ),
                              )
                              .toList()
                          : <TextSpan>[]),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              VerticalSpacing.md(context),
            ],
          ),
        ),
      ),
    );
  }
}
