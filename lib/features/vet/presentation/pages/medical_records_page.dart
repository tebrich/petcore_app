import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/vet/presentation/controllers/attend_pet_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class MedicalRecordsPage extends StatefulWidget {

  final int petId;

  const MedicalRecordsPage({
    super.key,
    required this.petId,
  });

  @override
  State<MedicalRecordsPage> createState() =>
      _MedicalRecordsPageState();
}

class _MedicalRecordsPageState
    extends State<MedicalRecordsPage> {

  late AttendPetController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      AttendPetController(
        petId: widget.petId,
      ),
    );


    controller.fetchMedicalRecords();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Historial Médico",
        ),
      ),

      body: Obx(() {

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // HEADER MASCOTA
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Obx(() {

                    final petMap =
                        controller.pet;

                    final avatarUrl =
                    petMap['photo_url']
                    as String?;

                    final avatarCode =
                    petMap['avatar_code']
                    as String?;

                    if (avatarUrl != null &&
                        avatarUrl.isNotEmpty) {

                      return ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    if (avatarCode != null &&
                        avatarCode.isNotEmpty) {

                      final lowerAvatar =
                      avatarCode.toLowerCase();

                      String assetPath = '';

                      if (lowerAvatar.startsWith('dog')) {

                        assetPath =
                        'assets/avatars/dogs/$lowerAvatar.svg';

                      } else if (lowerAvatar.startsWith('cat')) {

                        assetPath =
                        'assets/avatars/cats/$lowerAvatar.svg';

                      } else if (lowerAvatar.startsWith('bird')) {

                        assetPath =
                        'assets/avatars/birds/$lowerAvatar.svg';

                      } else if (lowerAvatar.startsWith('rabbit')) {

                        assetPath =
                        'assets/avatars/rabbits/$lowerAvatar.svg';

                      } else if (lowerAvatar.startsWith('fish')) {

                        assetPath =
                        'assets/avatars/fishs/$lowerAvatar.svg';
                      }

                      return Container(
                        height: 80,
                        width: 80,
                        padding:
                        const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.primary
                              .withOpacity(.1),
                        ),
                        child: SvgPicture.asset(
                          assetPath,
                          fit: BoxFit.contain,
                        ),
                      );
                    }

                    return Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.primary
                            .withOpacity(.1),
                      ),
                      child: const Icon(
                        Icons.pets,
                        size: 40,
                      ),
                    );
                  }),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Obx(() => Text(
                          controller.pet['name']
                              ??
                              'Mascota',
                          style: AppTextStyles
                              .headingMedium,
                        )),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                "Historial Médico",
                style:
                AppTextStyles.headingMedium,
              ),

              const SizedBox(height: 16),

              ...controller.medicalRecords
                  .map((r) {

                final docs =
                    (r['documents']
                    as List<dynamic>?) ??
                        [];

                return Card(
                  margin:
                  const EdgeInsets.only(
                      bottom: 16),

                  child: Padding(
                    padding:
                    const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          r['visit_date'] ?? '',
                          style: AppTextStyles
                              .bodyMedium
                              .copyWith(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Diagnóstico:",
                          style: AppTextStyles
                              .bodyMedium
                              .copyWith(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        Text(
                          r['diagnosis_text'] ??
                              '-',
                        ),

                        const SizedBox(height: 12),

                        if (docs.isNotEmpty)
                          Text(
                            "Documentos:",
                            style: AppTextStyles
                                .bodyMedium
                                .copyWith(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                        ...docs.map((d) {

                          final url =
                              d['file_url']
                              as String? ??
                                  '';

                          final name =
                              d['original_name'] ??
                                  '';

                          return InkWell(

                            onTap: () async {

                              if (await canLaunchUrl(
                                  Uri.parse(url))) {

                                await launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode
                                      .externalApplication,
                                );
                              }
                            },

                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 4,
                              ),

                              child: Row(
                                children: [

                                  const Icon(
                                    Icons.picture_as_pdf,
                                    size: 18,
                                  ),

                                  const SizedBox(
                                      width: 8),

                                  Expanded(
                                    child: Text(
                                      name,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 12),

                        Align(
                          alignment:
                          Alignment.centerRight,

                          child:
                          OutlinedButton.icon(

                            onPressed: () async {

                              final result =
                              await FilePicker
                                  .platform
                                  .pickFiles(
                                type:
                                FileType.custom,
                                allowedExtensions: [
                                  'pdf',
                                  'jpg',
                                  'jpeg',
                                  'png',
                                ],
                              );

                              if (result ==
                                  null) return;

                              final filePath =
                                  result.files
                                      .single.path;

                              if (filePath ==
                                  null) return;

                              final success =
                              await controller
                                  .uploadDocument(
                                medicalRecordId:
                                r['id'],
                                filePath:
                                filePath,
                              );

                              if (success) {

                                Get.showSnackbar(
                                  const GetSnackBar(
                                    message:
                                    "Documento subido correctamente",
                                    duration:
                                    Duration(
                                      seconds: 2,
                                    ),
                                  ),
                                );

                                controller
                                    .fetchMedicalRecords();
                              }
                            },

                            icon: const Icon(
                              Icons.upload_file,
                            ),

                            label: const Text(
                              "Agregar documento",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}
