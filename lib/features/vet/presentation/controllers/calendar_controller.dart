import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final GetConnect http = GetConnect();

  var events = <DateTime, List<Map<String, dynamic>>>{}.obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  final String baseUrl = "https://api.pet-core.app/api/v1";

  @override
  void onInit() {
    super.onInit();
    http.baseUrl = baseUrl;
    loadAppointments();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: 'access_token');

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<void> loadAppointments() async {
    try {
      final headers = await _getHeaders();

      final vetRes = await http.get("/vet-appointments/vet", headers: headers);
      final groomRes = await http.get("/groom-appointments/vet", headers: headers);

      print("VET STATUS: ${vetRes.statusCode}");
      print("GROOM STATUS: ${groomRes.statusCode}");

      final all = [
        if (vetRes.statusCode == 200) ...(vetRes.body ?? []),
        if (groomRes.statusCode == 200) ...(groomRes.body ?? []),
      ];

      final Map<DateTime, List<Map<String, dynamic>>> temp = {};

      for (var e in all) {

        final status =
        (e['status'] ?? '').toString().toLowerCase();

        // ❌ NO mostrar rechazadas
        if (status == 'rejected') {
          continue;
        }

        // 🔥 usar fecha reprogramada si existe
        final rawDt =
            e['proposed_datetime'] ??
                e['appointment_datetime'];

        final dt = DateTime.parse(rawDt.toString());

        final day = DateTime(dt.year, dt.month, dt.day);

        temp.putIfAbsent(day, () => []);

        temp[day]!.add({
          "time": dt,
          "pet": e['pet_name'] ?? 'Mascota',
          "type": e.containsKey('groomer_id') ? 'groom' : 'vet',
        });
      }

      events.value = temp;

      print("📅 EVENTS LOADED: ${events.length}");

      /// 🔥 AUTO SELECCIÓN DE DÍA CON EVENTO
      if (temp.isNotEmpty) {
        final firstDay = temp.keys.first;

        selectedDay.value = firstDay;
        focusedDay.value = firstDay;

        print("📍 AUTO SELECT DAY: $firstDay");
      }
    } catch (e) {
      print("ERROR CALENDAR: $e");
    }
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return events.entries
        .where((entry) => isSameDay(entry.key, day))
        .expand((entry) => entry.value)
        .toList();
  }
}