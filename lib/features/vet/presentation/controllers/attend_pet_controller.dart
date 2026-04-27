import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendPetController extends GetxController {
  final int petId;
  final int? appointmentId;
  AttendPetController({required this.petId, this.appointmentId});

  var isLoading = true.obs;
  var pet = RxMap<String, dynamic>({});
  var medicalRecords = <Map<String, dynamic>>[].obs;
  var owner = RxMap<String, dynamic>({});
  var breeds = <Map<String, dynamic>>[].obs;

  final String baseUrl = "http://192.168.40.54:8000/api/v1";
  final GetConnect http = GetConnect();

  @override
  void onInit() {
    super.onInit();
    http.baseUrl = baseUrl;
    fetchPet();
    fetchMedicalRecords();
  }

  Future<void> fetchPet() async {
    try {
      isLoading.value = true;
      final response = await http.get("/pets/$petId", headers: await _getHeaders());
      if (response.statusCode == 200) {
        pet.value = Map<String, dynamic>.from(response.body);

        // fetch owner info if present
        final userId = pet.value['user_id'] as int?;
        if (userId != null) {
          final r2 = await http.get("/users/$userId", headers: await _getHeaders());
          if (r2.statusCode == 200) owner.value = Map<String, dynamic>.from(r2.body);
        }

        // fetch breeds for species if species_id present
        final speciesId = pet.value['species_id'] as int?;
        if (speciesId != null) {
          final r3 = await http.get("/catalogs/pet-breeds/$speciesId", headers: await _getHeaders());
          if (r3.statusCode == 200) {
            breeds.value = List<Map<String, dynamic>>.from(r3.body);
          }
        }
      } else {
        print("Error fetchPet ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception fetchPet: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMedicalRecords() async {
    try {
      final response = await http.get("/medical-records/pet/$petId", headers: await _getHeaders());
      if (response.statusCode == 200) {
        medicalRecords.value = List<Map<String, dynamic>>.from(response.body);
      } else {
        print("Error fetchMedicalRecords ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception fetchMedicalRecords: $e");
    }
  }

  Future<void> savePetEdits({double? weightKg, double? temperatureC, String? diagnosis}) async {
    try {
      final Map<String, dynamic> payload = {};
      if (weightKg != null) payload['weight_kg'] = weightKg;
      if (temperatureC != null) payload['temperature_c'] = temperatureC;
      if (diagnosis != null) payload['diagnosis_text'] = diagnosis;

      if (payload.isEmpty) return;

      final response = await http.patch("/pets/$petId", payload, headers: await _getHeaders());

      if (response.statusCode == 200) {
        await fetchPet();
        print("Guardado");
      } else {
        print("Error al guardar: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception savePetEdits: $e");
    }
  }

  Future<void> patchBreed(int breedId) async {
    try {
      final payload = {'breed_id': breedId};
      final response = await http.patch("/pets/$petId", payload, headers: await _getHeaders());
      if (response.statusCode == 200) {
        await fetchPet();
        print("Raza actualizada");
      } else {
        print("patchBreed error: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception patchBreed: $e");
    }
  }

  Future<int?> createMedicalRecord({
    double? weightKg,
    double? temperatureC,
    String? diagnosis,
    String? notes,
  }) async {
    try {
      final payload = {
        "pet_id": petId,
        "weight_kg": weightKg,
        "temperature_c": temperatureC,
        "diagnosis_text": diagnosis,
        "notes": notes,
      }..removeWhere((k, v) => v == null);

      final response = await http.post("/medical-records/", payload, headers: await _getHeaders());
      print("CREATE MR RESPONSE: ${response.statusCode} ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchMedicalRecords();
        return response.body['id'] as int?;
      } else {
        print("createMedicalRecord error: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception createMedicalRecord: $e");
      return null;
    }
  }

  /// Crea una cita de seguimiento (vacuna / control) para la mascota.
  /// No envía vet_id para que el backend lo infiera del token del vet.
  Future<bool> createFollowUpAppointment(DateTime dt, {String appointmentType = "follow_up", String? note}) async {
    try {
      final payload = {
        "user_id": pet.value['user_id'],
        "pet_id": petId,
        "appointment_type": appointmentType,
        "appointment_datetime": dt.toIso8601String(),
        "add_to_calendar": true,
        "add_reminder": true,
        "notes": note,
      }..removeWhere((k, v) => v == null);

      final response = await http.post("/vet-appointments/", payload, headers: await _getHeaders());
      print("CREATE APPT RESPONSE: ${response.statusCode} ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Cita programada para ${dt.toLocal()}");
        return true;
      } else {
        print("createFollowUpAppointment error: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception createFollowUpAppointment: $e");
      return false;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: 'access_token');
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }
}
