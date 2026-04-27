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

// 👇 import de grooming (alias para no chocar nombres)
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';
import 'package:peticare/features/groom_appointments/presentation/widgets/add_new_appointment/review_page.dart'
    as groom_review;

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  String getStatusLabel(String status) {
    switch (status) {
      case "pending":
        return "En espera";
      case "accepted":
        return "Confirmada";
      case "rescheduled":
        return "Reprogramada";
      case "rejected":
        return "Rechazada";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    Size screenSize = MediaQuery.of(context).size;

    return Obx(() {
      final List<Map<String, dynamic>> appointments =
          controller.notificationsList.map<Map<String, dynamic>>((e) {
        return {
          ...Map<String, dynamic>.from(e),
          "date": DateTime.parse(e["created_at"]),
          "status": e["status"] ?? "pending",
          "title": e["title"],
          "message": e["message"],
          "appointment_id": e["appointment_id"],
          "service_type": e["service_type"],   // 👈 vet / grooming
        };
      }).toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Solo citas relevantes (no alertas genéricas)
      final filtered = appointments.where((a) {
        final st = (a["service_type"] ?? "").toString();
        return st == "vet" || st == "grooming";
      }).toList();

      List<Map<String, dynamic>> todaysAppointments = filtered.where((a) {
        final d = a['date'];
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      }).toList();

      List<Map<String, dynamic>> yesterdaysAppointments = filtered.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        return today.difference(alertDate).inDays == 1;
      }).toList();

      List<Map<String, dynamic>> lastweeksAppointments = filtered.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 1 && diff < 8;
      }).toList();

      List<Map<String, dynamic>> olderAppointments = filtered.where((a) {
        final d = a['date'];
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 7;
      }).toList();

      // Orden
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
              (alert['service_type'] ?? "").toString(),
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
    String serviceType,
  ) {
    Color statusColor;
    String statusText;

    switch (status) {
      case "accepted":
        statusColor = Colors.green;
        statusText = "Aceptada";
        break;
      case "rescheduled":
        statusColor = Colors.orange;
        statusText = "Reprogramada";
        break;
      case "rejected":
        statusColor = Colors.red;
        statusText = "Rechazada";
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
            print("SERVICE_TYPE >>> $serviceType");

            if (appointmentId.isEmpty) return;

            // Solo permitir entrar a review si está aceptada o reprogramada
            final allowed = currentStatus.toLowerCase().trim() == "accepted" ||
                currentStatus.toLowerCase().trim() == "rescheduled";

            if (!allowed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                content: Text("Aún no fue confirmada"),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          final notificationsController = Get.find<NotificationsController>();

          final fullItem =
              notificationsController.notificationsList.firstWhere(
            (e) => e["appointment_id"].toString() == appointmentId,
            orElse: () => {},
          );

          if (fullItem.isEmpty) {
            print("ERROR: item vacío");
            return;
          }

          // CHECK: si ya fue pagada, mostrar diálogo con detalles y NO navegar
          final paid = (fullItem['paid'] == true) ||
              (fullItem['paid']?.toString().toLowerCase() == 'true');

          if (paid) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Cita pagada'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Servicio: ${fullItem['appointment_type'] ?? '-'}'),
                    Text('Mascota: ${fullItem['pet_name'] ?? fullItem['pet_id'] ?? '-'}'),
                    Text('Fecha: ${fullItem['appointment_datetime'] ?? '-'}'),
                    const SizedBox(height: 8),
                    Text('Estado: ${getStatusLabel(fullItem['status'] ?? '')}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
            return;
          }

          // 🔥 RUTEAR SEGÚN TIPO (no pagada)
          final st = (fullItem["service_type"] ?? "vet").toString();

          if (st == "vet") {
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
          } else if (st == "grooming") {
            final controller = AddNewGroomAppointmentPageController();

            controller.selectedPet = {
              "id": fullItem["pet_id"],
              "name": fullItem["pet_name"],
            };
            controller.selectedPetId = fullItem["pet_id"];
            controller.appointmentType = fullItem["appointment_type"];
            controller.appointmentDateTime =
                DateTime.parse(fullItem["appointment_datetime"]);
            controller.selectedGroomerID =
                fullItem["groomer_id"]?.toString();

            Get.to(() => Scaffold(
                  body: groom_review.reviewAndPayPage(
                    MediaQuery.of(context).size,
                    controller,
                  ),
                ));
          }
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
