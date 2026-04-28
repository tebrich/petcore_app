// C:\peticare\peticare_app\lib\features\notifications\pages\appointments_page.dart

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

// grooming imports (alias)
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
          "date": e["created_at"] != null
              ? DateTime.tryParse(e["created_at"].toString()) ?? DateTime.now()
              : DateTime.now(),
          "status": e["status"] ?? "pending",
          "title": e["title"],
          "message": e["message"],
          "appointment_id": e["appointment_id"],
          "service_type": e["service_type"], // vet / grooming
        };
      }).toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final filtered = appointments.where((a) {
        final st = (a["service_type"] ?? "").toString();
        return st == "vet" || st == "grooming";
      }).toList();

      List<Map<String, dynamic>> todaysAppointments = filtered.where((a) {
        final d = a['date'] as DateTime;
        return d.year == today.year && d.month == today.month && d.day == today.day;
      }).toList();

      List<Map<String, dynamic>> yesterdaysAppointments = filtered.where((a) {
        final d = a['date'] as DateTime;
        final alertDate = DateTime(d.year, d.month, d.day);
        return today.difference(alertDate).inDays == 1;
      }).toList();

      List<Map<String, dynamic>> lastweeksAppointments = filtered.where((a) {
        final d = a['date'] as DateTime;
        final alertDate = DateTime(d.year, d.month, d.day);
        final diff = today.difference(alertDate).inDays;
        return diff > 1 && diff < 8;
      }).toList();

      List<Map<String, dynamic>> olderAppointments = filtered.where((a) {
        final d = a['date'] as DateTime;
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
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final alert = list[index] as Map<String, dynamic>;
            final id = (alert['appointment_id'] ?? "").toString();
            final title = alert['title'] ?? "Cita";
            final message = alert['message'] ?? "Detalle de cita";
            final date = alert['date'] as DateTime;
            final status = alert['status'] as String? ?? "pending";
            final serviceType = (alert['service_type'] ?? "").toString();
            return _alertTile(context, id, title, message, date, status, serviceType);
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

    // determine paid from notifications list (safe)
    final notificationsController = Get.find<NotificationsController>();
    final fullItem = notificationsController.notificationsList.firstWhere(
      (e) => (e["appointment_id"] ?? e["id"]).toString() == id,
      orElse: () => {},
    );
    final paid = (fullItem != null && fullItem.isNotEmpty)
        ? ((fullItem['paid'] == true) || (fullItem['paid']?.toString().toLowerCase() == 'true'))
        : false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // re-evaluate paid at tap time
            final notificationsController = Get.find<NotificationsController>();
            final fullItemLocal = notificationsController.notificationsList.firstWhere(
              (e) {
                final apptId = (e['appointment_id'] ?? e['vet_appointment_id'] ?? e['groom_appointment_id'] ?? e['id']).toString();
                final svc = (e['service_type'] ?? '').toString().toLowerCase();
                if (apptId != id) return false;
                // si el tile pasó serviceType, match por tipo (vet/grooming)
                if ((serviceType ?? '').isNotEmpty) {
                  return svc == serviceType.toLowerCase();
                }
                return true;
              },
              orElse: () => {},
            );
            final paidNow = notificationsController.notificationsList.any((n) {
              final appt = (n['appointment_id'] ?? n['vet_appointment_id'] ?? n['groom_appointment_id'] ?? n['id']).toString();
              if (appt != id) return false;
              final t = (n['title'] ?? '').toString().toLowerCase();
              final m = (n['message'] ?? '').toString().toLowerCase();
              return (n['paid'] == true) || t.contains('pagad') || m.contains('pagad');
            });

            // debug
            print("DEBUG TAP id=$id paidNow=$paidNow");

            if (paidNow) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Cita pagada'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Servicio: ${fullItemLocal['appointment_type'] ?? '-'}'),
                      Text('Mascota: ${fullItemLocal['pet_name'] ?? fullItemLocal['pet_id'] ?? '-'}'),
                      Text('Fecha: ${fullItemLocal['appointment_datetime'] ?? '-'}'),
                      const SizedBox(height: 8),
                      Text('Estado: ${getStatusLabel(fullItemLocal['status'] ?? '')}'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
                  ],
                ),
              );
              return;
            }

            // si no está pagada, seguir flujo normal
            final appointmentId = id;
            final currentStatus = (status ?? "pending").toLowerCase().trim();

            final allowed = currentStatus == "accepted" || currentStatus == "rescheduled";
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

            final st = (fullItemLocal["service_type"] ?? serviceType ?? "vet").toString();

            if (st == "vet") {
              final controller = AddNewVetAppointmentPageController();
              controller.setFromNotificationItem(fullItemLocal);
              controller.onInit();
              controller.isReadOnly.value = (fullItemLocal['paid'] == true);
              Get.to(() => Scaffold(body: reviewAndPayPage(MediaQuery.of(context).size, controller)));
            } else {
              final controller = AddNewGroomAppointmentPageController();
              controller.setFromNotificationItem(fullItemLocal);
              controller.onInit();
              controller.isReadOnly.value = (fullItemLocal['paid'] == true);
              Get.to(() => Scaffold(body: groom_review.reviewAndPayPage(MediaQuery.of(context).size, controller)));
            }
          },

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppPalette.surfaces(context).withValues(alpha: .5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STATUS pill + optional PAGADO badge
                Row(
                  children: [
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
                    const SizedBox(width: 8),
                    if (paid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.25)),
                        ),
                        child: Text(
                          'PAGADO',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
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
