import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/activities_list.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';

class TodosWidget extends StatefulWidget {
  const TodosWidget({super.key});

  @override
  State<TodosWidget> createState() => _TodosWidgetState();
}

class _TodosWidgetState extends State<TodosWidget> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    Size screenSize = MediaQuery.of(context).size;

    return Obx(() {
      final reminders = controller.remindersList;

      return Container(
        width: screenSize.width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),

        /// 🔥 LISTA REAL DESDE BACKEND
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reminders.length,
          itemBuilder: (context, index) =>
              activityTile(reminders[index], index),
        ),
      );
    });
  }

  Widget activityTile(Map<String, dynamic> reminder, int index) {

    final typeMapped = mapType(reminder["type"]);
    final activityMap = activitiesList(context)[typeMapped];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: 45,
      dense: true,

      /// ICONO (SIN CAMBIOS)
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (activityMap?['Color'] ?? Colors.grey)
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: EdgeInsets.only(bottom: 5),
        child: activityMap?['Icon'] != null
            ? SvgPicture.asset(
                activityMap!['Icon'],
                height: 32.5,
              )
            : const SizedBox(),
      ),

      /// 🔥 TITULO TRADUCIDO (CAMBIO CLAVE)
      title: Text(
        mapTitle(reminder["type"], reminder["title"]),
        style: AppTextStyles.bodyRegular.copyWith(
          fontSize: 14,
          color: AppPalette.primaryText(context),
        ),
      ),

      /// HORA (SIN CAMBIOS)
      subtitle: Text(
        formatTime(reminder["time"]),
        style: AppTextStyles.bodyRegular.copyWith(
          color: AppPalette.disabled(context),
          fontSize: 11.5,
        ),
      ),

      /// CHECK (SIN CAMBIOS)
      trailing: Checkbox(
        value: false,
        activeColor: AppPalette.primary,
        shape: CircleBorder(),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            width: states.contains(WidgetState.selected) ? 0.0 : 1.0,
            color: AppPalette.secondaryText(context),
          ),
        ),
        onChanged: (value) {},
      ),
    );
  }

  /// 🔥 MAPEO BACKEND → ICONOS (SIN CAMBIOS)
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

  /// 🔥 NUEVO: TRADUCCIÓN PROFESIONAL
  String mapTitle(String type, String? originalTitle) {
    switch (type) {
      case "feeding":
        return "Alimentar";
      case "walk":
        return "Paseo";
      case "medication":
        return "Medicación";
      case "clean":
        return "Limpieza";
      default:
        return originalTitle ?? "";
    }
  }

  /// 🔥 FORMATO HORA (SIN CAMBIOS)
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