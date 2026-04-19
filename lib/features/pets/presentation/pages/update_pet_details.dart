import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/constants/global_consts.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A page for editing the basic details of an existing pet's profile. 📝
///
/// This `StatefulWidget` provides a form pre-filled with the pet's current
/// information, allowing the user to make changes and save them. It handles
/// user input for various fields like name, breed, gender, weight, birthdate,
/// and activity level.
///
/// The "Update" button in the `BottomAppBar` is dynamically enabled or disabled
/// based on two conditions:
/// 1. All fields must be filled.
/// 2. At least one field must have a value different from the original pet data.
class UpdatePetDetails extends StatefulWidget {
  final Map<String, dynamic> petDetails;
  const UpdatePetDetails({required this.petDetails, super.key});

  @override
  State<UpdatePetDetails> createState() => _UpdatePetDetailsState();
}

class _UpdatePetDetailsState extends State<UpdatePetDetails> {
  // ===========================================================================
  // 🚀 State Variables & Controllers
  // ===========================================================================

  /// Form field controllers, initialized with the existing pet data.
  late TextEditingController petNameController;
  late TextEditingController petBreedController;
  late TextEditingController petGenderController;
  late TextEditingController petWeightController;
  DateTime? petBirthdate;
  late TextEditingController petActivityLevelController;

  @override
  /// Initializes the state and pre-fills the form controllers.
  ///
  /// This method is called when the widget is first created. It populates
  /// all the `TextEditingController`s and the `petBirthdate` variable with
  /// the data from `widget.petDetails` to ensure the form starts with the
  /// current values.
  void initState() {
    super.initState();
    petBirthdate = widget.petDetails['birthdate'];
    petNameController = TextEditingController(text: widget.petDetails['name']);
    petBreedController = TextEditingController(text: widget.petDetails['race']);
    petGenderController = TextEditingController(
      text: widget.petDetails['gender'],
    );
    petWeightController = TextEditingController(
      text: widget.petDetails['weight'].toString(),
    );
    petActivityLevelController = TextEditingController(
      text: energyLevels[widget.petDetails['energy'] - 1]
          .split('-')
          .first
          .trim(),
    );
  }

  @override
  /// Builds the main UI for the "Update Pet Details" page.
  ///
  /// The layout consists of a decorative header, a title, and a `Column`
  /// of form fields for editing the pet's information.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Top spacing for visual balance.
                screenSize.height > 675
                    ? VerticalSpacing.xxl(context)
                    : VerticalSpacing.xl(context),

                /// A decorative header with a floating illustration and a back button.
                SizedBox(
                  width: screenSize.width * 0.9,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'assets/illustrations/background_shape.svg',
                        height: screenSize.height < 675 ? 250 : 275,
                        colorFilter: ColorFilter.mode(
                          AppPalette.surfaces(context),
                          BlendMode.srcATop,
                        ),
                      ),

                      /// The animated illustration in the center.
                      FloatingAnimation(
                        type: FloatingType.wave,
                        duration: Duration(seconds: 8),
                        floatStrength: 2.5,
                        curve: Curves.linear,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              'assets/illustrations/background_shape.svg',
                              height: screenSize.height < 675 ? 175 : 200,
                              colorFilter: ColorFilter.mode(
                                AppPalette.primary.withValues(alpha: 0.5),
                                BlendMode.srcATop,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                right: 7.5,
                              ),
                              child: SvgPicture.asset(
                                'assets/illustrations/happy_pet.svg',
                                height: screenSize.height < 675 ? 125 : 150,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// The back button to exit the update page.
                      Positioned(
                        top: 0,
                        left: -screenSize.width * 0.025,
                        child: AnimatedIconButton(
                          iconData: FontAwesomeIcons.arrowLeftLong,
                          foregroundColor: AppPalette.textOnSecondaryBg(
                            context,
                          ),
                          iconSize: 17.5,
                          onClick: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                VerticalSpacing.xl(context),

                /// The main page title.
                Text(
                  "Update Pet's Basic Infos",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),

                VerticalSpacing.lg(context),

                SizedBox(
                  /// Input field for the pet's name.
                  height: 45,
                  child: TextFormField(
                    controller: petNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalette.background(context),
                      labelText: 'Pet Name',
                      hintText: 'Luna',

                      prefixIcon: Center(
                        child: Icon(
                          FontAwesomeIcons.tag,
                          size: 15,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalSpacing.md(context),
                SizedBox(
                  /// Input field for the pet's breed.
                  height: 45,
                  child: TextFormField(
                    controller: petBreedController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalette.background(context),
                      labelText: 'Breed',
                      hintText: 'Ragdoll',
                      prefixIcon: Center(
                        child: Icon(
                          FontAwesomeIcons.paw,
                          size: 15,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalSpacing.md(context),
                SizedBox(
                  /// Dropdown menu for selecting the pet's gender.
                  height: 45,
                  child: DropdownMenu(
                    label: Text('Gender'),
                    hintText: "Select the pet's gender",
                    controller: petGenderController,
                    textInputAction: TextInputAction.done,
                    onSelected: (value) {
                      setState(() {
                        petGenderController.text = value ?? '';
                      });
                    },
                    leadingIcon: Center(
                      child: Icon(
                        FontAwesomeIcons.venusMars,
                        size: 15,
                        color: AppPalette.primary,
                      ),
                    ),

                    width: double.infinity,
                    dropdownMenuEntries: [
                      DropdownMenuEntry<String>(value: "Male", label: "Male"),
                      DropdownMenuEntry<String>(
                        value: "Female",
                        label: "Female",
                      ),
                    ],
                  ),
                ),
                VerticalSpacing.md(context),

                SizedBox(
                  /// Input field for the pet's weight.
                  height: 45,
                  child: TextFormField(
                    controller: petWeightController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalette.background(context),
                      labelText: 'Weight',
                      hintText: '25',
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 30,
                        maxWidth: 50,
                        minHeight: 30,
                        maxHeight: 50,
                      ),
                      prefixIcon: Center(
                        child: Icon(
                          FontAwesomeIcons.weightScale,
                          size: 15,
                          color: AppPalette.primary,
                        ),
                      ),
                      suffixIcon: Center(
                        child: Text(
                          "KG",
                          style: AppTextStyles.playfulTag.copyWith(
                            fontSize: 13,
                            color: AppPalette.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalSpacing.md(context),
                SizedBox(
                  /// Read-only input field that opens a date picker for the pet's birthdate.
                  height: 45,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: petBirthdate == null
                          ? null
                          : '${petBirthdate!.month}/${petBirthdate!.day}/${petBirthdate!.year}',
                    ),
                    textInputAction: TextInputAction.next,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 18250),
                        ),
                        lastDate: DateTime.now(),
                      );
                      setState(() {
                        petBirthdate = selectedDate;
                      });
                    },
                    readOnly: true,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalette.background(context),
                      labelText: 'Birthdate',
                      hintText: "Enter your pet's birthdate",
                      prefixIcon: Center(
                        child: Icon(
                          FontAwesomeIcons.cakeCandles,
                          size: 15,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                VerticalSpacing.md(context),

                SizedBox(
                  /// Dropdown menu for selecting the pet's activity level.
                  height: 45,
                  child: DropdownMenu(
                    label: Text('Activity Level'),
                    hintText: "Select you pet's activity level",
                    textInputAction: TextInputAction.done,
                    controller: petActivityLevelController,
                    onSelected: (value) {
                      setState(() {
                        petActivityLevelController.text = value ?? '';
                      });
                    },
                    leadingIcon: Center(
                      child: Icon(
                        FontAwesomeIcons.venusMars,
                        size: 15,
                        color: AppPalette.primary,
                      ),
                    ),
                    width: screenSize.width * 0.9,
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppPalette.surfaces(context),
                      ),
                      elevation: WidgetStateProperty.all(4),
                    ),

                    dropdownMenuEntries: [
                      /// Each entry uses a custom `labelWidget` to display rich text.
                      DropdownMenuEntry<String>(
                        value: "High Energy",
                        label: 'High Energy',
                        labelWidget: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${energyLevels[0].split('-').first} - ",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: energyLevels[0].split('-').last,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  fontSize: 11,
                                  color: AppPalette.secondaryText(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DropdownMenuEntry<String>(
                        value: "Moderate Energy",
                        label: 'Moderate Energy',
                        labelWidget: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${energyLevels[1].split('-').first} - ",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: energyLevels[1].split('-').last,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  fontSize: 11,
                                  color: AppPalette.secondaryText(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DropdownMenuEntry<String>(
                        value: "Low Energy",
                        label: 'Low Energy',
                        labelWidget: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${energyLevels[2].split('-').first} - ",
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppPalette.textOnSecondaryBg(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: energyLevels[2].split('-').last,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  fontSize: 11,
                                  color: AppPalette.secondaryText(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Bottom spacer
                VerticalSpacing.lg(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        padding: EdgeInsets.all(5),
        child: Center(
          child: AnimatedElevatedButton(
            text: 'Update',
            size: Size(screenSize.width * 0.85, 45),

            /// The "Update" button is disabled if validation fails.
            ///
            /// Validation fails under two conditions:
            /// 1. **Incomplete Form:** Any of the required fields are empty.
            /// 2. **No Changes Made:** All form fields have the same values as the
            ///    initial `widget.petDetails`. This prevents the user from submitting
            ///    an unchanged form.
            onClick:
                (petNameController.text.isEmpty ||
                        petBreedController.text.isEmpty ||
                        petGenderController.text.isEmpty ||
                        petWeightController.text.isEmpty ||
                        petBirthdate == null ||
                        petActivityLevelController.text.isEmpty) ||
                    // Check if all fields are identical to the initial data.
                    (petNameController.text.trim() ==
                            widget.petDetails['name'] &&
                        petBreedController.text.trim() ==
                            widget.petDetails['race'] &&
                        petGenderController.text.trim() ==
                            widget.petDetails['gender'] &&
                        petWeightController.text.trim() ==
                            widget.petDetails['weight'].toString() &&
                        // Compare dates by ignoring the time component.
                        petBirthdate?.copyWith(
                              hour: 0,
                              minute: 0,
                              second: 0,
                              millisecond: 0,
                              microsecond: 0,
                            ) ==
                            (widget.petDetails['birthdate'] as DateTime)
                                .copyWith(
                                  hour: 0,
                                  minute: 0,
                                  second: 0,
                                  millisecond: 0,
                                  microsecond: 0,
                                ) &&
                        petActivityLevelController.text.trim() ==
                            energyLevels[widget.petDetails['energy'] - 1]
                                .split('-')
                                .first
                                .trim())
                ? null
                : () {
                    /// TODO: Implement the update logic here (e.g., call an API).
                    Get.back();
                  },
          ),
        ),
      ),
    );
  }
}
