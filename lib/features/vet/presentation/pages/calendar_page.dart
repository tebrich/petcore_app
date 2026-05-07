import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/calendar_controller.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());

    return Scaffold(
      appBar: AppBar(title: const Text("Calendario")),

      body: Column(
        children: [

          /// 📅 CALENDARIO
          Obx(() => SizedBox(
            height: 420,
            child: TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: controller.selectedDay.value,

              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),

              onDaySelected: (selectedDay, focusedDay) {
                controller.selectedDay.value = selectedDay;
              },

              eventLoader: (day) {
                return controller.getEventsForDay(day);
              },

              /// 🔥 HEADER
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),

              /// 🔥 DÍAS DE LA SEMANA (SOLUCIONA TEXTO CORTADO)
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 11),
                weekendStyle: TextStyle(fontSize: 11),
              ),

              /// 🔥 ESTILO GENERAL (SOLUCIONA ESPACIADO)
              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(2),

                defaultTextStyle: const TextStyle(fontSize: 12),
                weekendTextStyle: const TextStyle(fontSize: 12),
                outsideTextStyle: const TextStyle(fontSize: 11),

                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),

              /// 🔥 PUNTOS DE EVENTOS
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((e) {
                      final event = e as Map<String, dynamic>;

                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: event['type'] == 'vet'
                              ? Colors.blue
                              : Colors.green,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          )),

          const SizedBox(height: 10),

          /// 🕒 LISTA DE EVENTOS DEL DÍA
          Expanded(
            child: Obx(() {
              final events =
                  controller.getEventsForDay(controller.selectedDay.value);

              if (events.isEmpty) {
                return const Center(child: Text("Sin citas"));
              }

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (_, i) {
                  final e = events[i];

                  return ListTile(
                    leading: Icon(
                      e['type'] == 'vet'
                          ? Icons.medical_services
                          : Icons.cut,
                    ),
                    title: Text(e['pet']),
                    subtitle: Text(
                      DateFormat.Hm().format(e['time']),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
