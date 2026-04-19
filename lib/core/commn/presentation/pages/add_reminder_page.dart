import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_text_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/constants/global_consts.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/dashboard/presentation/controllers/dashboard_controller.dart';

/// A page for creating a new reminder for one or more pets.
///
/// This page provides a form for users to input a reminder's details,
/// Title, type,associated pets, date/time, and optional notes.
class AddReminderPage extends StatefulWidget {
  /// An optional pet name to pre-select when the page is opened.
  final String? selectedPetName;
  const AddReminderPage({this.selectedPetName, super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

/// The state for the [AddReminderPage].
///
/// Manages the form's state, including text controllers, selected date/time,
/// and the list of selected pets. It also handles the logic for showing
/// date/time pickers and the pet selection bottom sheet.
class _AddReminderPageState extends State<AddReminderPage> {
  /// Controller for the reminder's title input field.
  late TextEditingController titleTextController;

  /// Controller for the reminder's type dropdown menu.
  late TextEditingController typeTextController;

  /// Controller for the optional notes input field.
  late TextEditingController noteTextController;

  /// The date and time selected for the reminder.
  DateTime? selectedDateTime;

  /// A list of names for the pets associated with this reminder.
  late List<Map<String, dynamic>> selectedPets;

  late List<Map<String, dynamic>> reminderTypesList = [];

  /// INIT STATE
  @override
  void initState() {
    super.initState();
    titleTextController = TextEditingController();
    typeTextController = TextEditingController();
    noteTextController = TextEditingController();
    // Default the reminder time to 9:00 AM on the current day.
    selectedDateTime = DateTime.now().copyWith(
      hour: 09,
      minute: 0,
      microsecond: 0,
      millisecond: 0,
    );
    selectedPets = [];
    // If a pet name was passed to the widget, add it to the selection.
    if (widget.selectedPetName != null) {
    // selectedPets.add(widget.selectedPetName!);
    }
    loadReminderTypes();
  }

  @override
  Widget build(BuildContext context) {

    print("🔥 ESTE ES EL ADD REMINDER NUEVO");
    final dashboard = Get.find<DashboardController>();

    final petsDetails = dashboard.petsList;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Heading Spacing
                  constraints.maxHeight >= 675
                      ? VerticalSpacing.xl(context)
                      : VerticalSpacing.lg(context),
                  SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/illustrations/background_shape.svg',
                          height: constraints.maxHeight <= 580
                              ? constraints.maxHeight * 0.35
                              : 350,
                          colorFilter: ColorFilter.mode(
                            AppPalette.surfaces(context),
                            BlendMode.srcATop,
                          ),
                        ),

                        SvgPicture.asset(
                          'assets/illustrations/background_shape.svg',
                          height: constraints.maxHeight <= 580
                              ? constraints.maxHeight * 0.325
                              : 300,
                          colorFilter: ColorFilter.mode(
                            AppPalette.primary.withValues(alpha: 0.5),
                            BlendMode.srcATop,
                          ),
                        ),
                        FloatingAnimation(
                          type: FloatingType.wave,
                          duration: Duration(seconds: 8),
                          floatStrength: 1.5,
                          curve: Curves.linear,
                          child: SvgPicture.asset(
                            'assets/illustrations/reminder.svg',
                            height: constraints.maxHeight <= 580
                                ? constraints.maxHeight * 0.25
                                : 250,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: -constraints.maxWidth * 0.025,
                          child: AnimatedIconButton(
                            iconData: Icons.close_rounded,
                            foregroundColor: AppPalette.primaryText(context),
                            onClick: Get.back,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Space after illustration
                  VerticalSpacing.lg(context),

                  /// Input Section
                  Container(
                    width: constraints.maxWidth * 0.9,
                    margin: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .05,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: AppPalette.disabled(context)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        /// Reminder Title
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: titleTextController,
                          decoration: InputDecoration(
                            hintText: 'Ingrese el título del recordatorio',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,

                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              maxWidth: 90,
                            ),
                            prefixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 6.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/illustrations/notification_bell.svg',
                                    height: 22.5,
                                  ),
                                ),
                                Text(
                                  "Título",
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    color: AppPalette.textOnSecondaryBg(
                                      context,
                                    ),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Divider
                        Divider(
                          color: AppPalette.disabled(context),
                          height: 1,
                          thickness: 1,
                        ),

                        /// Type
                        DropdownMenu(
                          hintText: "Selecciones Recordatorio",
                          controller: typeTextController,
                          textInputAction: TextInputAction.done,
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              maxWidth: 90,
                            ),
                          ),

                          onSelected: (value) {
                            setState(() {
                              typeTextController.text = value ?? '';
                            });
                          },

                          leadingIcon: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 6.0,
                                ),
                                child: typeTextController.text.isEmpty
                                    ? Icon(
                                        FontAwesomeIcons.question,
                                        size: 15,
                                        color: AppPalette.secondaryText(context),
                                      )
                                    : Builder(
                                        builder: (_) {
                                          final selected = reminderTypesList.firstWhere(
                                            (e) => e["label_es"] == typeTextController.text,
                                            orElse: () => {},
                                          );

                                          return selected.isEmpty
                                              ? Icon(Icons.notifications)
                                              : SvgPicture.asset(
                                                  getIconPath(selected["icon"]),
                                                  height: 22,
                                                );
                                        },
                                      ),
                              ),         
                              Text(
                                "Tipo",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          width: constraints.maxWidth * 0.9,
                          menuHeight: 150,
                          dropdownMenuEntries: reminderTypesList.map((item) {
                            return DropdownMenuEntry<String>(
                              value: item["label_es"],
                              label: item["label_es"],
                              leadingIcon: SvgPicture.asset(
                                getIconPath(item["icon"]),
                                height: 25,
                              ),
                            );
                          }).toList(),
                        ),

                        /// Divider
                        Divider(
                          color: AppPalette.disabled(context),
                          height: 1,
                          thickness: 1,
                        ),

                        /// Concerned Pets
                        //"Select the concerned pet(s)"
                        Container(
                          constraints: BoxConstraints(minHeight: 50),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔥 TÍTULO
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                                child: Text(
                                  "Mascota",
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    color: AppPalette.textOnSecondaryBg(context),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              /// 🔥 CONTENIDO ORIGINAL
                              Row(
                                children: [
                                  Expanded(
                                    child: selectedPets.isEmpty
                                        ? Text(
                                            "Seleccione la(s) mascota(s)",
                                            style: AppTextStyles.ctaBold.copyWith(
                                              color: AppPalette.secondaryText(context),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Wrap(
                                            spacing: 16.0,
                                            runSpacing: 16.0,
                                            children: selectedPets.map((pet) {
                                              final petDetails = petsDetails.firstWhere(
                                                (details) => details['id'] == pet["id"],
                                              );
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  petDetails['avatar'](
                                                    40.0,
                                                    0.9,
                                                    AppPalette.primary,
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Text(
                                                    petDetails['name'],
                                                    style: AppTextStyles.petName.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: AppPalette.textOnSecondaryBg(context),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                  ),

                                  /// 🔥 ESTE ES EL BOTÓN (SEPARADO DEL EXPANDED)
                                  AnimatedIconButton(
                                    iconData: Icons.chevron_right_rounded,
                                    foregroundColor: AppPalette.textOnSecondaryBg(context),
                                    onClick: () => showNestedNavigationBottomSheet(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /// Divider
                        Divider(
                          color: AppPalette.disabled(context),
                          height: 1,
                          thickness: 1,
                        ),

                        /// Time
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          onTap: () {
                            if (checkIfSameDay()) {
                              launchTimePicker(context);
                            } else {
                              launchDateTimePicker(context);
                            }
                          },
                          controller: TextEditingController(
                            text: checkIfSameDay()
                                ? DateFormat(
                                    'KK:mm a',
                                  ).format(selectedDateTime!)
                                : DateFormat(
                                    'MM/dd/yyy KK:mm a',
                                  ).format(selectedDateTime!),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ingrese Hora',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            suffixIcon: checkIfSameDay()
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: AnimatedTextButton(
                                      foregroundColor: AppPalette.primary,
                                      text: 'cambie la fecha',
                                      onClick: () {
                                        launchDateTimePicker(context);
                                      },
                                    ),
                                  )
                                : null,
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              maxWidth: 90,
                            ),
                            prefixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 6.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/illustrations/clock.svg',
                                    height: 22.5,
                                  ),
                                ),
                                Text(
                                  "Hora",
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    color: AppPalette.textOnSecondaryBg(
                                      context,
                                    ),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Divider
                        Divider(
                          color: AppPalette.disabled(context),
                          height: 1,
                          thickness: 1,
                        ),

                        /// Reminder Title
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: noteTextController,
                          decoration: InputDecoration(
                            hintText: 'Ingrese notas (opcional)',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,

                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              maxWidth: 90,
                            ),
                            prefixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 6.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/illustrations/note.svg',
                                    height: 22.5,
                                  ),
                                ),
                                Text(
                                  "Notas",
                                  style: AppTextStyles.bodyRegular.copyWith(
                                    color: AppPalette.textOnSecondaryBg(
                                      context,
                                    ),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing
                  constraints.maxHeight > 675
                      ? VerticalSpacing.lg(context)
                      : VerticalSpacing.sm(context),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 61,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: AppPalette.background(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    offset: Offset(0, -1),
                    blurRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child:
                  /// CTA - Save Button
                  AnimatedElevatedButton(
                    text: '',
                    size: Size(constraints.maxWidth * .9, 45),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Guardar', style: AppTextStyles.ctaBold),
                        ),
                        FaIcon(FontAwesomeIcons.paw, size: 15),
                      ],
                    ),
                    onClick: () async {
                      try {
                        final api = GetConnect();

                      /// 1️ TYPE
                      final selectedType = reminderTypesList.firstWhere(
                        (item) => item["label_es"] == typeTextController.text,
                      );

                      final type = selectedType["code"];

                      /// 2️ TIME
                      final time = DateFormat("HH:mm:ss").format(selectedDateTime!);

                      /// 3️ TITLE
                      final title = titleTextController.text;

                      /// 4️ NOTES
                      final notes = noteTextController.text;

                      /// 5️ MASCOTAS SELECCIONADAS (YA LO TIENES ✔)
                      final pets = selectedPets;

                      /// 🔥 ITERAR POR CADA MASCOTA (DINÁMICO)
                      for (var pet in selectedPets) {

                        final petId = int.parse(pet["id"].toString());

                        final payload = {
                          "user_id": 4, // luego lo haremos dinámico
                          "pet_id": petId,
                          "type": type,
                          "title": title,
                          "reminder_time": time,
                          "notes": notes,
                        };

                        final response = await api.post(
                          "http://192.168.40.54:8000/api/v1/reminders/",
                          payload,
                        );

                        if (response.statusCode != 200) {
                          print("ERROR: ${response.body}");
                        }
                      }

                      /// 🔄 refrescar dashboard
                      Get.find<DashboardController>().loadReminders();

                      Get.back();

                    } catch (e) {
                      print("SAVE ERROR: $e");
                    }
                  },
                ),         
            ),
          ),
        );
      },
    );
  }

  Future<void> loadReminderTypes() async {
    try {
      final api = GetConnect();

      final response = await api.get(
        "http://192.168.40.54:8000/api/v1/reminders/reminder-types",
      );

      if (response.statusCode == 200) {
        setState(() {
          reminderTypesList = List<Map<String, dynamic>>.from(response.body);
        });
      } else {
        print("Error loading reminder types: ${response.body}");
      }
    } catch (e) {
      print("ERROR loading reminder types: $e");
    }
  }

  /// 🔥 AQUÍ PEGAS LA NUEVA FUNCIÓN
  String getIconPath(String iconName) {
    switch (iconName) {
      case "Food":
        return "assets/illustrations/food_bowl.svg";

      case "Medocs":
        return "assets/illustrations/medecines2.svg";

      case "Water":
        return "assets/illustrations/hydration.svg";

      case "Walk":
        return "assets/illustrations/pet_walking.svg";

      case "Clean-Cage":
        return "assets/illustrations/cage.svg";

      default:
        return "assets/illustrations/notification_bell.svg";
    }
  }

  /// Checks if the [selectedDateTime] is on the same day as the current date.
  bool checkIfSameDay() {
    if (selectedDateTime?.year == DateTime.now().year &&
        selectedDateTime?.month == DateTime.now().month &&
        selectedDateTime?.day == DateTime.now().day) {
      return true;
    } else {
      return false;
    }
  }

  /// Shows a modal bottom sheet containing the [PetSelectionWdiget].
  void showNestedNavigationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      useSafeArea: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PetSelectionWdiget(
        initialSelection: selectedPets,
        onSave: (selectedPetsList) {
          setState(() {
            selectedPets = selectedPetsList;
          });
          Get.back();
        },
      ),
    );
  }

  /// Launches the system's time picker dialog and updates the state.
  Future<void> launchTimePicker(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 09, minute: 00),
    );

    if (selectedTime != null) {
      setState(() {
        selectedDateTime = DateTime.now().copyWith(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      });
    }
  }

  /// Launches the system's date picker, followed by the time picker,
  /// and updates the state with the combined result.
  Future<void> launchDateTimePicker(BuildContext context) async {
    DateTime? newSelectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2060, 12, 31),
    );

    if (newSelectedDateTime != null) {
      if (context.mounted) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 09, minute: 00),
        );
        if (selectedTime != null) {
          newSelectedDateTime = newSelectedDateTime.copyWith(
            hour: selectedTime.hour,
            minute: selectedTime.minute,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          );
          setState(() {
            selectedDateTime = newSelectedDateTime;
          });
        }
      }
    }
  }
}

/// A widget displayed in a modal bottom sheet for selecting one or more pets.
///
/// It displays a list of the user's pets and allows for multiple selections.
class PetSelectionWdiget extends StatefulWidget {
  /// The list of pet names that are initially selected.
  final List<Map<String, dynamic>> initialSelection;

  /// The callback function that is triggered when the user saves their selection.
  final Function(List<Map<String, dynamic>> selectedPetsList) onSave;

  const PetSelectionWdiget({
    required this.initialSelection,
    required this.onSave,
    super.key,
  });

  @override
  State<PetSelectionWdiget> createState() => _PetSelectionWdigetState();
}

class _PetSelectionWdigetState extends State<PetSelectionWdiget> {
  /// The current list of selected pet names within the bottom sheet.
  late List<Map<String, dynamic>> selectedPets;

  @override
  void initState() {
    super.initState();
    selectedPets = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final dashboard = Get.find<DashboardController>();
    final petsDetails = dashboard.petsList;

    return SafeArea(
      child: SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            /// Heading Spacing
            Text(
              "Seleccione Mascota",
              style: AppTextStyles.headingMedium.copyWith(
                fontSize: 30,
                color: AppPalette.textOnSecondaryBg(context),
              ),
            ),

            /// Space after title
            VerticalSpacing.lg(context),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: petsDetails.length,
                itemBuilder: (context, index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {

                        print("PET RAW >>> ${petsDetails[index]}"); // 👈 AQUÍ

                        final pet = {
                          "id": petsDetails[index]["id"],
                          "name": petsDetails[index]["name"],
                        };

                        final exists = selectedPets.any((p) => p["id"] == pet["id"]);

                        setState(() {
                          if (exists) {
                            selectedPets.removeWhere((p) => p["id"] == pet["id"]);
                          } else {
                            selectedPets.add(pet);
                          }
                        });
                      },
                      splashColor: AppPalette.primary.withValues(alpha: .1),
                      contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 24.0, 8.0),
                      leading: petsDetails[index]['avatar'](
                        75.0,
                        0.9,
                        AppPalette.primary,
                      ),
                      title: Text(
                        petsDetails[index]['name'],
                        style: AppTextStyles.petName.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      trailing:
                          selectedPets.any((p) => p["id"] == petsDetails[index]["id"])
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppPalette.primary,
                              size: 35,
                            )
                          : null,
                    ),

                    Divider(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      height: 1,
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                  ],
                ),
              ),
            ),

            /// CTA Spacing
            VerticalSpacing.md(context),

            /// CTA - Save Button
            AnimatedElevatedButton(
              text: 'Guardar',
              size: Size(screenSize.width * 0.6, 45),

              onClick: () => widget.onSave(selectedPets),
            ),
            // Bottom Spacing
            VerticalSpacing.md(context),
          ],
        ),
      ),
    );
  }
}
