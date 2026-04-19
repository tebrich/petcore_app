import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/activities_list.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/features/reminders/presentation/pages/reminder_detail_page.dart';

class TodosWidget extends StatefulWidget {
  const TodosWidget({super.key});

  @override
  State<TodosWidget> createState() => _TodosWidgetState();
}

class _TodosWidgetState extends State<TodosWidget> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final screenSize = MediaQuery.of(context).size;

    return Obx(() {
      final reminders = controller.remindersList;

      return Container(
        width: screenSize.width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            return activityTile(reminders[index], context);
          },
        ),
      );
    });
  }

  Widget activityTile(Map<String, dynamic> reminder, BuildContext context) {
    final typeMapped = mapType(reminder["type"]);
    final activityMap = activitiesList(context)[typeMapped];

    return ListTile(
      onTap: () {
        Get.to(() => ReminderDetailPage(reminder: reminder));
      },
      contentPadding: EdgeInsets.zero,
      minTileHeight: 45,
      dense: true,

      /// ICONO
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (activityMap?['Color'] ?? Colors.grey)
              .withValues(alpha: 0.4),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        margin: const EdgeInsets.only(bottom: 5),
        child: activityMap?['Icon'] != null
            ? SvgPicture.asset(
                activityMap!['Icon'],
                height: 32.5,
              )
            : const SizedBox(),
      ),

      /// TITULO
      title: Text(
        reminder["title"] ?? "",
        style: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14,
          color: AppPalette.primaryText(context),
        ),
      ),

      /// SUBTITULO
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatTime(reminder["time"]),
            style: AppTextStyles.bodyRegular.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 11.5,
            ),
          ),
          Text(
            "Mascota: ${getPetName(reminder["pet_id"])}",
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),

      /// CHECK
      trailing: Checkbox(
        value: false,
        activeColor: AppPalette.primary,
        shape: const CircleBorder(),
        onChanged: (value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Confirmar"),
                content: const Text(
                    "¿Desea marcar esta tarea como completada?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      final api = GetConnect();

                      await api.put(
                        "http://192.168.40.54:8000/api/v1/reminders/complete/${reminder["id"]}",
                        {},
                      );

                      Get.find<DashboardController>().loadReminders();
                    },
                    child: const Text("Confirmar"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// MAP TYPE
  String mapType(String type) {
    switch (type) {
      case "feeding":
        return "Food";
      case "medication":
        return "Medocs";
      case "walk":
        return "Walk";
      case "clean":
        return "Clean-Cage";
      default:
        return "Food";
    }
  }

  /// FORMAT TIME
  String formatTime(String? time) {
    if (time == null) return "-";

    try {
      final parts = time.split(":");
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final suffix = hour >= 12 ? "pm" : "am";

      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return "$hour:$minute $suffix";
    } catch (e) {
      return time;
    }
  }
}

/// GET PET NAME
String getPetName(dynamic petId) {
  final controller = Get.find<DashboardController>();

  final pet = controller.petsList.firstWhere(
    (p) => p["id"].toString() == petId.toString(),
    orElse: () => {"name": "Mascota"},
  );

  return pet["name"];
}