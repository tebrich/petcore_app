import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/services/user_service.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:peticare/services/user_avatar_service.dart';




/// A page where users can view and edit their account details. 👤
///
/// This [StatefulWidget] provides a user interface for managing personal
/// information, including full name, email, birthdate, phone number, and
/// address. It features a prominent profile picture editor and a form
/// pre-filled with the user's current data.
class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

/// The state for the [AccountDetailsPage].
///
/// Manages the form's state, including the initialization and disposal of
/// [TextEditingController]s. It also handles the logic for displaying a
/// date picker for the birthdate field.
class _AccountDetailsPageState extends State<AccountDetailsPage> {
  String? birthDateToSend;
  DateTime? createdAt;
  File? _avatarFile;
  String? _avatarUrl;

  String phoneCountryCode = '+595';
   
  /// Variables
  late TextEditingController fullNameTextController;
  late TextEditingController emailTextController;
  late TextEditingController birthDateTextController;
  late TextEditingController phoneNumberTextController;
  late TextEditingController addressTextController;

  Future<void> _loadUserData() async {
    try {
      final user = await UserService.getMe();
      //debugPrint('USER ME RESPONSE: $user');

      fullNameTextController.text = user['full_name'] ?? '';
      emailTextController.text = user['email'] ?? '';

      // 🔴 CLAVE TELÉFONO
      phoneCountryCode = user['phone_country_code'] ?? '+595';
      phoneNumberTextController.text = user['phone_number'] ?? '';

      addressTextController.text = user['address'] ?? '';
      birthDateTextController.text = user['birth_date'] ?? '';

      if (user['created_at'] != null) {
        setState(() {
          createdAt = DateTime.parse(user['created_at']);
        });
      }

      if (user['avatar_url'] != null) {
        setState(() {
          _avatarUrl = user['avatar_url'];
        });
      }

    } catch (e) {
      // Por ahora solo log; no mostramos error aún
      debugPrint('Error loading user data: $e');
    }
  }

  /// ===============================
  /// AVATAR – SELECCIONAR IMAGEN
  /// ===============================
  Future<void> _pickAvatarFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    setState(() {
      _avatarFile = file;
    });

    try {
      await UserAvatarService.uploadAvatar(file);
      debugPrint('Avatar subido correctamente');
    } catch (e) {
      debugPrint('Error subiendo avatar: $e');
    }
  }

  Future<File> _saveAvatarLocally(File originalFile) async {
    final directory = await getApplicationDocumentsDirectory();

    final avatarsDir = Directory(p.join(directory.path, 'avatars'));
    if (!await avatarsDir.exists()) {
      await avatarsDir.create(recursive: true);
    }

    // Nombre fijo (un avatar por usuario en este dispositivo)
    final String filePath = p.join(avatarsDir.path, 'avatar_user.jpg');

    final File savedFile = await originalFile.copy(filePath);
    return savedFile;
  }

  Future<void> _loadLocalAvatar() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarPath = '${directory.path}/avatars/avatar_user.jpg';
      final avatarFile = File(avatarPath);

      if (await avatarFile.exists()) {
        setState(() {
          _avatarFile = avatarFile;
        });
      }
    } catch (e) {
      debugPrint('Error loading local avatar: $e');
    }
  }


  /// Initializes the state of the widget.
  ///
  /// This method sets up the [TextEditingController]s for each form field,
  /// populating them with mock data from the [DummyData] source.
  @override
  void initState() {
    super.initState();

    fullNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    birthDateTextController = TextEditingController();
    phoneNumberTextController = TextEditingController();
    addressTextController = TextEditingController();

    _loadUserData(); // 👈 backend real
    _loadLocalAvatar();   // avatar desde storage local
  }

  /// Disposes the controllers when the widget is removed from the widget tree.
  ///
  /// This is crucial for preventing memory leaks by releasing the resources
  /// held by the [TextEditingController]s.
  @override
  void dispose() {
    super.dispose();
    fullNameTextController.dispose();
    emailTextController.dispose();
    birthDateTextController.dispose();
    phoneNumberTextController.dispose();
    addressTextController.dispose();
  }

  @override
  /// Builds the UI for the Account Details page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'settings_account_details_title'.tr,
          style: AppTextStyles.headingMedium.copyWith(
            color: AppPalette.textOnSecondaryBg(context),
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            /// Decorative background icon, subtly placed for visual texture.
            Positioned(
              top: 0,
              left: -15,
              child: Transform.rotate(
                angle: 0.25,
                child: Icon(
                  FontAwesomeIcons.paw,
                  color: AppPalette.primary.withValues(alpha: .03),
                  size: 300,
                ),
              ),
            ),

            /// Another decorative background icon, creating a layered effect.
            Positioned(
              top: 325,
              right: -15,
              child: Transform.rotate(
                angle: -0.3,
                child: Icon(
                  FontAwesomeIcons.paw,
                  color: AppPalette.secondary(context).withValues(alpha: .1),
                  size: 175,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Column(
                children: [
                  /// The user's profile picture, displayed in a circular avatar.
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppPalette.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2.0),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppPalette.primary.withValues(alpha: 0.1),
                              backgroundImage: _avatarUrl != null
                                  ? NetworkImage(_avatarUrl!)
                                  : null,
                              child: _avatarUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),

                            Material(
                              color: AppPalette.primary.withValues(alpha: .5),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(100),
                              ),
                              child: InkWell(
                                onTap: _pickAvatarFromGallery, // luego conectamos cambio de foto
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(100),
                                ),
                                child: const SizedBox(
                                  height: 40,
                                  width: 120,
                                  child: Icon(
                                    FontAwesomeIcons.camera,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (createdAt != null)
                        Text(
                          'settings_joined_date'.trParams({
                            'date': DateFormat('dd MMM yyyy', 'es_ES').format(createdAt!),
                          }),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppPalette.disabled(context),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  VerticalSpacing.md(context),

                  /// A visual separator between the profile header and the form fields.
                  Divider(
                    color: AppPalette.disabled(context).withValues(alpha: .5),
                    height: 1,
                    thickness: 1,
                  ),

                  VerticalSpacing.xl(context),

                  /// Input field for the user's full name.
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: fullNameTextController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'settings_full_name'.tr,
                        hintText: 'settings_full_name_hint'.tr,
                        prefixIcon: Icon(FontAwesomeIcons.user, size: 15),
                      ),
                    ),
                  ),
                  VerticalSpacing.md(context),

                  /// Input field for the user's email address.
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'settings_email'.tr,
                        hintText: 'yourcutecat@example.com',
                        prefixIcon: Icon(FontAwesomeIcons.at, size: 15),
                      ),
                    ),
                  ),
                  VerticalSpacing.md(context),

                  /// Input field for the user's birthdate. Tapping it opens a date picker.
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: birthDateTextController,
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          locale: const Locale('es', 'ES'),
                          initialDate: DateTime(1990, 1, 1),
                          firstDate: DateTime(1910, 1, 1),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          birthDateTextController.text =
                              DateFormat('dd MMM yyyy', 'es_ES').format(selectedDate);

                          birthDateToSend =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      },

                      decoration: InputDecoration(
                        focusColor: AppPalette.primary,
                        labelText: 'settings_birthdate'.tr,
                        hintText: 'settings_birthdate_hint'.tr,
                        prefixIcon: Icon(
                          FontAwesomeIcons.cakeCandles,
                          size: 15,
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.calendarDay,
                          size: 15,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                  ),
                  VerticalSpacing.md(context),

                  /// Input field for the user's phone number.
                  /// Phone number (country code + number)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'settings_phone'.tr,
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppPalette.disabled(context)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              phoneCountryCode,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: phoneNumberTextController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Número de teléfono',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  VerticalSpacing.md(context),


                  /// Input field for the user's address.
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: addressTextController,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusColor: AppPalette.primary,
                        labelText: 'settings_address'.tr,
                        hintText: 'settings_address_hint'.tr,
                        prefixIcon: Icon(FontAwesomeIcons.house, size: 15),
                      ),
                    ),
                  ),

                  VerticalSpacing.md(context),

                  /// The main call-to-action button to save any changes made to the form.
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 30),
                    child: AnimatedElevatedButton(
                      text: 'settings_save_changes'.tr,
                      size: Size(screenSize.width * 0.8, 45),
                      onClick: () async {
                        try {
                          await UserService.updateMe({
                            "full_name": fullNameTextController.text.trim(),
                            "phone_number": phoneNumberTextController.text.trim(),
                            "address": addressTextController.text.trim(),
                            "birth_date": birthDateToSend,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Datos guardados correctamente'),
                            ),
                          );

                          Get.back();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se pudieron guardar los datos'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
