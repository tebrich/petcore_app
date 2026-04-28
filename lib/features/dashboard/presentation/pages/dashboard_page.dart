// C:\peticare\peticare_app\lib\features\dashboard\presentation\pages\dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/dashboard/presentation/widgets/health_alerts.dart';
import 'package:peticare/features/dashboard/presentation/widgets/pet_widget.dart';
import 'package:peticare/features/dashboard/presentation/widgets/reminders_widget.dart';
import 'package:peticare/features/dashboard/presentation/widgets/todos_widget.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final notifController = Get.find<NotificationsController>();
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // 🔥 construir lista de “próximos eventos” desde notifications y follow-ups
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // DEBUG: listar notificaciones crudas antes de filtrar
          print("DASH DEBUG - NOTIFS COUNT: ${notifController.notificationsList.length}");
          for (var n in notifController.notificationsList) {
            print("DASH DEBUG - NOTIF RAW: $n");
            final st = (n['service_type'] ?? '').toString().toLowerCase();
            final status = (n['status'] ?? '').toString().toLowerCase();
            final dt = n['appointment_datetime'];
            print("DASH DEBUG - svc: $st status: $status dt: $dt");
          }

          // 1) Eventos desde notifications (tu lógica original)
          final notifEvents = notifController.notificationsList.where((e) {
            final type = (e['type'] ?? '').toString().toLowerCase();
            final serviceType = (e['service_type'] ?? '').toString().toLowerCase();
            final status = (e['status'] ?? '').toString().toLowerCase();
            final dtStr = e['appointment_datetime'];
            if (type != 'appointment') return false;
            if (serviceType != 'vet' && serviceType != 'grooming') return false;
            if (status != 'accepted' && status != 'rescheduled') return false;
            if (dtStr == null) return false;
            DateTime dt;
            try {
              dt = DateTime.parse(dtStr.toString());
            } catch (_) {
              return false;
            }
            final date = DateTime(dt.year, dt.month, dt.day);
            return date.isAtSameMomentAs(today) || date.isAfter(today);
          }).map<Map<String, dynamic>>((e) {
            final serviceType = (e['service_type'] ?? '').toString().toLowerCase();
            final dt = DateTime.parse(e['appointment_datetime']);
            final dateLabel = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
            final timeLabel = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
            final isVet = serviceType == 'vet';
            return {
              'source': 'notification',
              'type': 'appointment',
              'title': isVet ? (e['appointment_type'] ?? 'Cita veterinaria') : (e['appointment_type'] ?? 'Cita grooming'),
              'time': timeLabel,
              'date': dateLabel,
              'icon': isVet ? 'assets/illustrations/vet_appointment.svg' : 'assets/illustrations/grooming_appointment.svg',
              'pet_name': e['pet_name'] ?? 'Mascota',
              'raw': e,
            };
          }).toList();

          // 2) Eventos desde vet_appointments (mis citas del usuario)
          final myApptEvents = notifController.myAppointmentsList.where((a) {
            final dtStr = a['appointment_datetime'];
            if (dtStr == null) return false;
            DateTime dt;
            try {
              dt = DateTime.parse(dtStr.toString());
            } catch (_) {
              return false;
            }
            final date = DateTime(dt.year, dt.month, dt.day);
            return date.isAtSameMomentAs(today) || date.isAfter(today);
          }).map<Map<String, dynamic>>((a) {
            final dt = DateTime.parse(a['appointment_datetime']);
            final dateLabel = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
            final timeLabel = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
            return {
              'source': 'my_appointment',
              'type': 'appointment',
              'title': a['appointment_type'] ?? 'Cita veterinaria',
              'time': timeLabel,
              'date': dateLabel,
              'icon': 'assets/illustrations/vet_appointment.svg',
              'pet_name': a['pet_name'] ?? 'Mascota',
              'raw': a,
            };
          }).toList();

          // 2.b) Eventos desde groom_appointments (mis citas grooming del usuario)
          final myGroomApptEvents = notifController.myGroomAppointmentsList.where((a) {
            final dtStr = a['appointment_datetime'];
            if (dtStr == null) return false;
            DateTime dt;
            try {
              dt = DateTime.parse(dtStr.toString());
            } catch (_) {
              return false;
            }
            final date = DateTime(dt.year, dt.month, dt.day);
            return date.isAtSameMomentAs(today) || date.isAfter(today);
          }).map<Map<String, dynamic>>((a) {
            final dt = DateTime.parse(a['appointment_datetime']);
            final dateLabel = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
            final timeLabel = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
            return {
              'source': 'my_groom_appointment',
              'type': 'appointment',
              'title': a['appointment_type'] ?? 'Cita grooming',
              'time': timeLabel,
              'date': dateLabel,
              'icon': 'assets/illustrations/grooming_appointment.svg',
              'pet_name': a['pet_name'] ?? 'Mascota',
              'raw': a,
            };
          }).toList();

          // 3) Eventos desde follow-ups (propuestas del vet)
          final followUpEvents = notifController.followUpsList.where((f) {
            final dtStr = f['scheduled_at'];
            if (dtStr == null) return false;
            DateTime dt;
            try {
              dt = DateTime.parse(dtStr.toString());
            } catch (_) {
              return false;
            }
            final date = DateTime(dt.year, dt.month, dt.day);
            return date.isAtSameMomentAs(today) || date.isAfter(today);
          }).map<Map<String, dynamic>>((f) {
            final dt = DateTime.parse(f['scheduled_at']);
            final dateLabel = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
            final timeLabel = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
            return {
              'source': 'follow_up',
              'type': 'follow_up',
              'title': f['note'] ?? 'Próxima visita propuesta',
              'time': timeLabel,
              'date': dateLabel,
              'icon': 'assets/illustrations/vet_appointment.svg',
              'pet_name': '',
              'raw': f,
            };
          }).toList();

          // 4) Mezclar, ordenar y deduplicar - incluir myGroomApptEvents
          final combined = [...notifEvents, ...myApptEvents, ...myGroomApptEvents, ...followUpEvents];
          combined.sort((a, b) {
            DateTime parseDt(Map<String, dynamic> item) {
              final dparts = (item['date'] as String?)?.split('/') ?? ['00', '00'];
              final tparts = (item['time'] as String?)?.split(':') ?? ['00', '00'];
              final day = int.tryParse(dparts[0]) ?? 0;
              final month = int.tryParse(dparts[1]) ?? 0;
              final hour = int.tryParse(tparts[0]) ?? 0;
              final minute = int.tryParse(tparts[1]) ?? 0;
              final now = DateTime.now();
              return DateTime(now.year, month, day, hour, minute);
            }

            return parseDt(a).compareTo(parseDt(b));
          });

          // Dedupe
          final seen = <String>{};
          final deduped = <Map<String, dynamic>>[];
          for (final item in combined) {
            String key;
            if (item['source'] == 'notification' && item['raw'] != null) {
              final raw = item['raw'];
              final apptId = raw['vet_appointment_id'] ?? raw['groom_appointment_id'] ?? raw['appointment_id'] ?? raw['id'];
              final serviceType = (raw['service_type'] ?? item['raw']?['service_type'] ?? item['source']).toString().toLowerCase();
              key = apptId != null ? 'appt_${serviceType}_$apptId' : 'notif_${item['type']}_${item['date']}_${item['time']}_${item['pet_name']}';
            } else if ((item['source'] == 'my_appointment' || item['source'] == 'my_groom_appointment') && item['raw'] != null) {
              final raw = item['raw'];
              final apptId = raw['id'] ?? raw['appointment_id'];
              // normalize serviceType for "my" sources: my_appointment -> vet, my_groom_appointment -> grooming
              String serviceType;
              if (item['source'] == 'my_groom_appointment') {
                serviceType = 'grooming';
              } else if (item['source'] == 'my_appointment') {
                serviceType = 'vet';
            } else {
              serviceType = (raw['service_type'] ?? item['source']).toString().toLowerCase();
            }
            key = apptId != null ? 'appt_${serviceType}_$apptId' : 'myappt_${item['type']}_${item['date']}_${item['time']}_${item['pet_name']}';
          } else if (item['source'] == 'follow_up' && item['raw'] != null) {
            key = 'fu_${item['raw']['id']}';
          } else {
            key = '${item['type']}_${item['date']}_${item['time']}_${item['pet_name']}';
          }

            if (!seen.contains(key)) {
              seen.add(key);
              deduped.add(item);
            }
          }

          final upcomingEvents = deduped;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacing.lg(context),
                /// HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'dashboard_greeting'.trParams({
                                  'name': controller.userName.value,
                                }),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '\n${'dashboard_subtitle'.tr}',
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.disabled(context),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      AnimatedIconButton(
                        iconData: Icons.shopping_cart,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset('assets/illustrations/notification_bell.svg', height: 35),
                            Positioned(
                              top: -6.0,
                              right: 0.0,
                              child: Container(
                                height: 17.5,
                                width: 17.5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppPalette.danger(context),
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(() {
                                  // 🔥 contar solo citas vet/grooming aceptadas o reprogramadas
                                  final total = notifController.notificationsList.where((e) {
                                    final type = (e['type'] ?? '').toString().toLowerCase();
                                    final serviceType = (e['service_type'] ?? '').toString().toLowerCase();
                                    final status = (e['status'] ?? '').toString().toLowerCase();

                                    // exclude non-appointments
                                    if (type != 'appointment') return false;
                                    // only vet or grooming
                                    if (!(serviceType == 'vet' || serviceType == 'grooming')) return false;
                                    // only relevant statuses
                                    if (!(status == 'accepted' || status == 'rescheduled')) return false;

                                    // exclude paid
                                    final paid = (e['paid'] == true) ||
                                        (e['raw'] != null && (e['raw']['paid'] == true)) ||
                                        (e['raw'] != null && (e['raw']['paid']?.toString()?.toLowerCase() == 'true'));
                                    if (paid) return false;

                                    // get appointment datetime (try top-level then raw)
                                    final dtStr = e['appointment_datetime'] ?? (e['raw'] != null ? e['raw']['appointment_datetime'] : null);
                                    if (dtStr == null) return true; // keep if no datetime info

                                    DateTime dt;
                                    try {
                                      dt = DateTime.parse(dtStr.toString());
                                    } catch (_) {
                                      return true; // keep if unparsable
                                    }

                                    final now = DateTime.now();
                                    final today = DateTime(now.year, now.month, now.day);
                                    final apptDate = DateTime(dt.year, dt.month, dt.day);

                                    // count only if appointment is today or in the future
                                    return apptDate.isAtSameMomentAs(today) || apptDate.isAfter(today);
                                  }).length;
                                  return Text(
                                    total.toString(),
                                    style: AppTextStyles.playfulTag.copyWith(
                                      fontSize: 12,
                                      color: AppPalette.lBackground,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        onClick: () {
                          Get.toNamed('/Notifications');
                        },
                      ),
                    ],
                  ),
                ),
                VerticalSpacing.xl(context),
                /// 🔥 PETS REALES
                SizedBox(
                  height: 235,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.petsList.length,
                          itemBuilder: (context, index) {
                            final pet = controller.petsList[index];
                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(left: screenSize.width * 0.05, right: 10)
                                  : index == controller.petsList.length - 1
                                      ? EdgeInsets.only(left: 10, right: screenSize.width * 0.05)
                                      : const EdgeInsets.symmetric(horizontal: 10),
                              child: petWidget(context, screenSize, pet),
                            );
                          },
                        ),
                ),
                VerticalSpacing.xxl(context),
                /// TODOS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Text(
                    'dashboard_todos_today'.tr,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 17,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                VerticalSpacing.md(context),
                const TodosWidget(),
                VerticalSpacing.xl(context),
                /// UPCOMING EVENTS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Text(
                    'dashboard_upcoming_events'.tr,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 17,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                VerticalSpacing.md(context),
                remindersWidget(context, upcomingEvents),
                VerticalSpacing.xl(context),
                /// ALERTAS
                healthAlerts(context, screenSize),
                VerticalSpacing.xxl(context),
              ],
            ),
          );
        }),
      ),
    );
  }
}
