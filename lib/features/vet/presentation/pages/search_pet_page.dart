import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'attend_pet_page.dart';
import 'medical_records_page.dart';

class SearchPetPage extends StatefulWidget {

  final bool openMedicalHistory;

  const SearchPetPage({
    super.key,
    this.openMedicalHistory = false,
  });

  @override
  State<SearchPetPage> createState() =>
      _SearchPetPageState();
}

class _SearchPetPageState extends State<SearchPetPage> {
  final TextEditingController searchCtrl = TextEditingController();
  final GetConnect http = GetConnect();

  List results = [];

  final String baseUrl = "http://192.168.40.54:8000/api/v1";

  @override
  void initState() {
    super.initState();
    http.baseUrl = baseUrl;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: 'access_token');

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<void> search() async {
    if (searchCtrl.text.isEmpty) return;

    final res = await http.get(
      "/pets/search?name=${searchCtrl.text}",
      headers: await _getHeaders(),
    );

    print("SEARCH STATUS: ${res.statusCode}");
    print("SEARCH BODY: ${res.body}");

    if (res.statusCode == 200) {
      setState(() {
        results = res.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔍 INPUT
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: "Nombre de mascota",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📋 RESULTADOS
            Expanded(
              child: results.isEmpty
                  ? const Text("Sin resultados")
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final r = results[i];

                        return Card(
                          child: ListTile(

                            onTap: () {

                              if (widget.openMedicalHistory) {

                                Get.to(
                                      () => MedicalRecordsPage(
                                    petId: r['pet_id'],
                                  ),
                                );

                              } else {

                                Get.to(
                                      () => AttendPetPage(
                                    petId: r['pet_id'],
                                  ),
                                );
                              }
                            },

                            leading: const Icon(Icons.pets),

                            title: Text(
                              r['pet_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dueño: ${r['owner_name']}"),
                                Text("Tel: ${r['phone']}"),
                                Text("Email: ${r['email']}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
