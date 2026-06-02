import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:peticare/core/commn/presentation/widgets/pet_avatar_widget.dart';

class EditPetPage extends StatefulWidget {

  final Map<String, dynamic> pet;

  const EditPetPage({
    required this.pet,
    super.key,
  });

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {

  File? selectedImage;

  bool isUploading = false;

  final api = GetConnect();

  ////////////////////////////////////////////////////////////
  /// PICK IMAGE
  ////////////////////////////////////////////////////////////
  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {

      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  /// UPLOAD PET PHOTO
  ////////////////////////////////////////////////////////////
  Future<void> uploadPetPhoto() async {

    if (selectedImage == null) return;

    try {

      setState(() {
        isUploading = true;
      });

      final token = await const FlutterSecureStorage()
          .read(key: 'access_token');

      final form = FormData({
        'file': MultipartFile(selectedImage!,
            filename: 'pet_photo.jpg'),
      });

      final response = await api.post(
        "http://192.168.40.54:8000/api/v1/pets/${widget.pet["id"]}/avatar",
        form,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("UPLOAD PET PHOTO STATUS >>> ${response.statusCode}");
      print("UPLOAD PET PHOTO BODY >>> ${response.body}");

      if (response.statusCode == 200) {

        Get.snackbar(
          "OK",
          "Foto actualizada correctamente",
        );

        setState(() {
          widget.pet["photo_url"] =
          response.body["photo_url"];
        });

      } else {

        Get.snackbar(
          "Error",
          "No se pudo subir la foto",
        );
      }

    } catch (e) {

      print("UPLOAD PET PHOTO ERROR >>> $e");

      Get.snackbar(
        "Error",
        "Error al subir imagen",
      );

    } finally {

      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.pet["name"] ?? "Mascota",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

          selectedImage != null

              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(selectedImage!),
                )

              : PetAvatarWidget(
                  pet: widget.pet,
                  radius: 60,
                ),


            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,

              child: const Text(
                "Seleccionar Foto",
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed:
              isUploading ? null : uploadPetPhoto,

              child: Text(
                isUploading
                    ? "Subiendo..."
                    : "Guardar Foto",
              ),
            ),

            const SizedBox(height: 30),

            ListTile(
              title: const Text("Nombre"),
              subtitle: Text(widget.pet["name"] ?? "-"),
            ),

            ListTile(
              title: const Text("Especie"),
              subtitle: Text(widget.pet["species"] ?? "-"),
            ),

            ListTile(
              title: const Text("Raza"),
              subtitle: Text(widget.pet["breed"] ?? "-"),
            ),
          ],
        ),
      ),
    );
  }
}
