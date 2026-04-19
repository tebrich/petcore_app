import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/date_formatter.dart';
import 'package:peticare/core/utils/notification_icons_getter.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    Size screenSize = MediaQuery.of(context).size;

    return Obx(() {

      /// 🔥 TRANSFORMACIÓN DENTRO DEL OBX (CLAVE)
      final List<Map<String, dynamic>> alerts =
          controller.notificationsList.map<Map<String, dynamic>>((e) {
        return {
          ...Map<String, dynamic>.from(e),
          "date": DateTime.parse(e["created_at"]),
        };
      }).toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final todaysAlerts = alerts.where((alert) {
        final d = alert['date'];
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      }).toList();

      final yesterdaysAlerts = alerts.where((alert) {
        final d = alert['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        return today.difference(alertDate).inDays == 1;
      }).toList();

      final lastweeksAlerts = alerts.where((alert) {
        final d = alert['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 1 && diff < 8;
      }).toList();

      final olderAlerts = alerts.where((alert) {
        final d = alert['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 7;
      }).toList();

      /// 🔥 ORDENAR
      todaysAlerts.sort((a, b) => -a['date'].compareTo(b['date']));
      yesterdaysAlerts.sort((a, b) => -a['date'].compareTo(b['date']));
      lastweeksAlerts.sort((a, b) => -a['date'].compareTo(b['date']));
      olderAlerts.sort((a, b) => -a['date'].compareTo(b['date']));

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacing.md(context),

              _section("Hoy", todaysAlerts, context),
              VerticalSpacing.lg(context),

              _section("Ayer", yesterdaysAlerts, context),
              VerticalSpacing.lg(context),

              _section("Última semana", lastweeksAlerts, context),
              VerticalSpacing.lg(context),

              _section("Anteriores", olderAlerts, context),
            ],
          ),
        ),
      );
    });
  }

  //////////////////////////////////////////////////////////////
  /// 🔹 SECCIÓN
  //////////////////////////////////////////////////////////////
  Widget _section(String title, List alerts, BuildContext context) {
    if (alerts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.playfulTag.copyWith(
            fontSize: 15,
            color: AppPalette.textOnSecondaryBg(context).withValues(alpha: .5),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];

            return _alertTile(
              context,
              alert['id'].toString(),
              alert['type'] ?? 'info',
              null,
              alert['title'] ?? '',
              alert['message'] ?? '',
              alert['date'],
            );
          },
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// 🔹 TILE
  //////////////////////////////////////////////////////////////
  Widget _alertTile(
    BuildContext context,
    String id,
    String type,
    String? subtype,
    String title,
    String subtitle,
    DateTime dateTime,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: InkWell(
          onTap: () {},
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppPalette.surfaces(context).withValues(alpha: .5),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 TIPO
                Text(
                  type.toUpperCase(),
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 14,
                    color: AppPalette.disabled(context),
                  ),
                ),

                VerticalSpacing.sm(context),

                Row(
                  children: [

                    /// 🔹 ICONO
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.primary.withValues(alpha: 0.1),
                      ),
                      alignment: Alignment.center,
                      child: alertsIconGetter(subtype ?? type),
                    ),

                    const SizedBox(width: 8),

                    /// 🔹 TEXTO
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$title\n',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: subtitle,
                              style: AppTextStyles.bodyRegular.copyWith(
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// 🔹 FECHA
                    Text(
                      dateFormatter(dateTime),
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}