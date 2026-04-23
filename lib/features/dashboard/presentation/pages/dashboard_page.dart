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
          // 🔥 construir lista de “próximos eventos” desde notifications
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final upcomingEvents =
              notifController.notificationsList.where((e) {
            final type =
                (e['type'] ?? '').toString().toLowerCase(); // "appointment"
            final serviceType =
                (e['service_type'] ?? '').toString().toLowerCase();
            final status =
                (e['status'] ?? '').toString().toLowerCase();
            final dtStr = e['appointment_datetime'];

            if (type != 'appointment') return false;
            if (serviceType != 'vet' && serviceType != 'grooming') {
              return false;
            }
            if (status != 'accepted' && status != 'rescheduled') {
              return false;
            }
            if (dtStr == null) return false;

            DateTime dt;
            try {
              dt = DateTime.parse(dtStr.toString());
            } catch (_) {
              return false;
            }
            final date = DateTime(dt.year, dt.month, dt.day);

            // Solo citas de hoy en adelante
            return date.isAtSameMomentAs(today) || date.isAfter(today);
          }).map<Map<String, dynamic>>((e) {
            final serviceType =
                (e['service_type'] ?? '').toString().toLowerCase();
            final dt = DateTime.parse(e['appointment_datetime']);

            final dateLabel =
                "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}";
            final timeLabel =
                "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

            final isVet = serviceType == 'vet';

            return {
              'title': isVet
                  ? (e['appointment_type'] ?? 'Cita veterinaria')
                  : (e['appointment_type'] ?? 'Cita grooming'),
              'time': timeLabel,
              'date': dateLabel,
              'icon': isVet
                  ? 'assets/illustrations/vet_appointment.svg'
                  : 'assets/illustrations/grooming_appointment.svg',
              'pet_name': e['pet_name'] ?? 'Mascota',   // 👈 NUEVO
            };
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacing.lg(context),

                /// HEADER
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
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
                            SvgPicture.asset(
                              'assets/illustrations/notification_bell.svg',
                              height: 35,
                            ),
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
                                  final total = notifController.notificationsList
                                      .where((e) {
                                    final type =
                                        (e['type'] ?? '').toString().toLowerCase();
                                    final serviceType = (e['service_type'] ?? '')
                                        .toString()
                                        .toLowerCase();
                                    final status =
                                        (e['status'] ?? '').toString().toLowerCase();

                                    final isAppointment =
                                        type == 'appointment';
                                    final isVetOrGroom =
                                        serviceType == 'vet' ||
                                            serviceType == 'grooming';
                                    final isRelevantStatus =
                                        status == 'accepted' ||
                                            status == 'rescheduled';

                                    return isAppointment &&
                                        isVetOrGroom &&
                                        isRelevantStatus;
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
                                  ? EdgeInsets.only(
                                      left: screenSize.width * 0.05,
                                      right: 10,
                                    )
                                  : index ==
                                          controller.petsList.length - 1
                                      ? EdgeInsets.only(
                                          left: 10,
                                          right: screenSize.width * 0.05,
                                        )
                                      : const EdgeInsets.symmetric(
                                          horizontal: 10),
                              child: petWidget(
                                context,
                                screenSize,
                                pet,
                              ),
                            );
                          },
                        ),
                ),

                VerticalSpacing.xxl(context),

                /// TODOS
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
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
