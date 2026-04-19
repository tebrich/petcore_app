import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/date_formatter.dart';
import 'package:peticare/core/utils/notification_icons_getter.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';
import 'package:peticare/features/vet_appointments/presentation/controllers/add_new_vet_appointment_page_controller.dart';
import 'package:peticare/features/vet_appointments/presentation/widgets/add_new_appointment/review_page.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  String getStatusLabel(String status) {
    switch (status) {
      case "pending":
        return "En espera";
      case "accepted":
        return "Confirmada";
      case "rejected":
        return "Rechazada";
      case "rescheduled":
        return "Reprogramada";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    Size screenSize = MediaQuery.of(context).size;

    return Obx(() {

      /// 🔥 AHORA TODO VIENE DE notificationsList
      final List<Map<String, dynamic>> appointments =
          controller.notificationsList.map<Map<String, dynamic>>((e) {

        return {
          ...Map<String, dynamic>.from(e),

          "date": DateTime.parse(e["created_at"]),
          "status": e["status"] ?? "pending",
          "title": e["title"],
          "message": e["message"],

          /// 🔥 IMPORTANTE
          "appointment_id": e["appointment_id"],
        };

      }).toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      List<Map<String, dynamic>> todaysAppointments = appointments.where((a) {
        final d = a['date'];
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      }).toList();

      List<Map<String, dynamic>> yesterdaysAppointments = appointments.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        return today.difference(alertDate).inDays == 1;
      }).toList();

      List<Map<String, dynamic>> lastweeksAppointments = appointments.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 1 && diff < 8;
      }).toList();

      List<Map<String, dynamic>> olderAppointments = appointments.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 7;
      }).toList();

      todaysAppointments.sort((a, b) => -a['date'].compareTo(b['date']));
      yesterdaysAppointments.sort((a, b) => -a['date'].compareTo(b['date']));
      lastweeksAppointments.sort((a, b) => -a['date'].compareTo(b['date']));
      olderAppointments.sort((a, b) => -a['date'].compareTo(b['date']));

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacing.md(context),

              _section("Hoy", todaysAppointments, context),
              VerticalSpacing.lg(context),

              _section("Ayer", yesterdaysAppointments, context),
              VerticalSpacing.lg(context),

              _section("Última semana", lastweeksAppointments, context),
              VerticalSpacing.lg(context),

              _section("Anteriores", olderAppointments, context),
            ],
          ),
        ),
      );
    });
  }

  Widget _section(String title, List list, BuildContext context) {
    if (list.isEmpty) return const SizedBox();

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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final alert = list[index];

            return _alertTile(
              context,
              (alert['appointment_id'] ?? "").toString(),
              alert['title'] ?? "Cita",
              alert['message'] ?? "Detalle de cita",
              alert['date'],
              alert['status'],
            );
          },
        ),
      ],
    );
  }

  Widget _alertTile(
    BuildContext context,
    String id,
    String title,
    String subtitle,
    DateTime dateTime,
    String? status,
  ) {

    Color statusColor;
    String statusText;

    switch (status) {
      case "accepted":
        statusColor = Colors.green;
        statusText = "Aceptada";
        break;
      case "rejected":
        statusColor = Colors.red;
        statusText = "Rechazada";
        break;
      case "reprogrammed":
        statusColor = Colors.orange;
        statusText = "Reprogramada";
        break;
      case "completed":
        statusColor = Colors.blue;
        statusText = "Completada";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "Pendiente";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: InkWell(
          onTap: () {
            final appointmentId = id;
            final currentStatus = status ?? "pending";

            print("CLICK >>> $appointmentId");
            print("STATUS >>> $currentStatus");

            if (appointmentId.isEmpty) return;

            if (currentStatus.toLowerCase().trim() != "accepted") {
              Get.snackbar(
                "Cita en proceso",
                "Aún no fue confirmada",
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            final notificationsController = Get.find<NotificationsController>();

            final fullItem = notificationsController.notificationsList.firstWhere(
              (e) => e["appointment_id"].toString() == appointmentId,
              orElse: () => {},
            );

            if (fullItem.isEmpty) {
              print("ERROR: item vacío");
              return;
            }

            final controller = AddNewVetAppointmentPageController();

            controller.selectedPetName = fullItem["pet_name"];
            controller.selectedVetID = fullItem["vet_id"];
            controller.appointmentType = fullItem["appointment_type"];
            controller.appointmentDateTime =
                DateTime.parse(fullItem["appointment_datetime"]);

            Get.to(() => Scaffold(
                  body: reviewAndPayPage(
                    MediaQuery.of(context).size,
                    controller,
                  ),
                ));
          },
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

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),

                VerticalSpacing.sm(context),

                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.primary.withValues(alpha: 0.1),
                      ),
                      alignment: Alignment.center,
                      child: alertsIconGetter("appointment"),
                    ),

                    const SizedBox(width: 8),

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