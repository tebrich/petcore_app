import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_connect.dart';

class CalendarController extends GetxController {
  final GetConnect http = GetConnect();

  var events = <DateTime, List<Map<String, dynamic>>>{}.obs;
  var selectedDay = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      final vetRes = await http.get("/vet-appointments/vet");
      final groomRes = await http.get("/groom-appointments/vet");

      final all = [
        ...(vetRes.body ?? []),
        ...(groomRes.body ?? []),
      ];

      Map<DateTime, List<Map<String, dynamic>>> temp = {};

      for (var e in all) {
        final dt = DateTime.parse(e['appointment_datetime']);
        final day = DateTime(dt.year, dt.month, dt.day);

        if (!temp.containsKey(day)) {
          temp[day] = [];
        }

        temp[day]!.add({
          "time": dt,
          "pet": e['pet_name'] ?? 'Mascota',
          "type": e.containsKey('groomer_id') ? 'groom' : 'vet',
        });
      }

      events.value = temp;

      print("📅 EVENTS LOADED: ${events.length}");
    } catch (e) {
      print("ERROR CALENDAR: $e");
    }
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return events[d] ?? [];
  }
}
