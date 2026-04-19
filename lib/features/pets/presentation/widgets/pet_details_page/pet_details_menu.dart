import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/appointments/appointment_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/gallery/pet_gallery_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/health/overall_welness_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/health/pet_blood_pressure_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/health/pet_weight_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pet_details_page/health/sleep_record_widget.dart';

/// A tabbed menu widget for displaying detailed information about a pet.
///
/// This `StatefulWidget` creates a dynamic menu with three main sections:
/// "Health," "Appointments," and "Gallery." Users can switch between these
/// tabs to view different aspects of their pet's profile.
///
/// The widget manages its own state to track the currently active tab and
/// conditionally renders the appropriate content below the tab bar.
class PetDetailsMenu extends StatefulWidget {
  const PetDetailsMenu({super.key});

  @override
  State<PetDetailsMenu> createState() => _PetDetailsMenuState();
}

/// The state for the [PetDetailsMenu].
///
/// Manages the `selectedMenuIndex` to control which tab's content is visible.
class _PetDetailsMenuState extends State<PetDetailsMenu> {
  /// The index of the currently selected menu item.
  /// 0: Health, 1: Appointments, 2: Gallery.
  int selectedMenuIndex = 0;
  @override
  /// Builds the tabbed menu UI and the corresponding content section.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    /// Defines the properties for each menu item, including title, icon, and color.
    final List<Map<String, dynamic>> menuValues = [
      {
        'title': 'Salud',
        'icon': FontAwesomeIcons.heartPulse,
        'color': AppPalette.danger(context),
      },

      {
        'title': 'Cita',
        'icon': FontAwesomeIcons.calendarDays,
        'color': AppPalette.success(context),
      },
      {
        'title': 'Galeria',
        'icon': FontAwesomeIcons.images,
        'color': AppPalette.secondary(context),
      },
    ];

    return Column(
      children: [
        /// The horizontal list of tappable menu tabs.
        /// A `Wrap` widget is used to allow tabs to flow to the next line on smaller screens if needed.
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(
            menuValues.length,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedMenuIndex = index;
                });
              },
              borderRadius: BorderRadius.all(Radius.circular(20)),
              splashColor: menuValues[index]['color'].withValues(alpha: 0.3),
              child: Container(
                /// The visual style of the tab, which changes based on whether it is selected.
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    width: 0.5,
                    color: index == selectedMenuIndex
                        ? menuValues[index]['color']
                        : AppPalette.disabled(context),
                  ),
                  color: index == selectedMenuIndex
                      ? menuValues[index]['color'].withValues(alpha: 0.2)
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      menuValues[index]['icon'],
                      size: 14,
                      color: menuValues[index]['color'],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      menuValues[index]['title'],
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 14,
                        color: AppPalette.textOnSecondaryBg(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// Space between Sections
        VerticalSpacing.xxl(context),

        /// Conditionally renders the content widget based on the `selectedMenuIndex`.
        selectedMenuIndex == 0
            ? healthSectionWidgetBuilder(context, screenSize)
            : selectedMenuIndex == 1
            ? appointmentsSectionWidgetBuilder(context, screenSize)
            : const PetGalleryWidget(),
      ],
    );
  }

  /// Builds the content for the "Health" tab.
  ///
  /// This widget composes several smaller health-related widgets into a
  /// single column, including wellness status, blood pressure, sleep records,
  /// and weight reports.
  Widget healthSectionWidgetBuilder(BuildContext context, Size screenSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        overallWelnessWidget(context, screenSize),

        /// Space between Sections
        VerticalSpacing.xl(context),

        /// Blood Pressure
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              petBloodPressure(context, screenSize),
              SizedBox(width: screenSize.width * 0.05),
              petSleepRecordWidget(context, screenSize),
            ],
          ),
        ),

        /// Space between Sections
        VerticalSpacing.xl(context),
        PetWeightWidget(),
      ],
    );
  }

  /// Builds the content for the "Appointments" tab.
  ///
  /// This widget fetches appointment data and separates it into two lists:
  /// "Upcoming" and "History". It uses `ListView.builder` to display each
  /// appointment using the `appointmentwidget`. The filtering logic is based
  /// on comparing the appointment date with the current date.
  Widget appointmentsSectionWidgetBuilder(
    BuildContext context,
    Size screenSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Próximo',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.primaryText(context),
              fontSize: 20,
            ),
          ),

          /// Space after title
          VerticalSpacing.sm(context),
          ListView.builder(
            /// Filters the list to show only appointments that are in the future.
            itemCount: DummyData.lunaApointments(context)
                .where(
                  (element) =>
                      !element['date'].compareTo(DateTime.now()).isNegative,
                )
                .toList()
                .length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: appointmentwidget(
                context,
                screenSize,
                DummyData.lunaApointments(context)
                    .where(
                      (element) =>
                          !element['date'].compareTo(DateTime.now()).isNegative,
                    )
                    .toList()[index],
              ),
            ),
          ),

          /// Space between Sections
          VerticalSpacing.xl(context),

          Text(
            'Historial',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.primaryText(context),
              fontSize: 20,
            ),
          ),

          /// Space after title
          VerticalSpacing.sm(context),
          ListView.builder(
            /// Filters the list to show only appointments that are in the past.
            itemCount: DummyData.lunaApointments(context)
                .where(
                  (element) =>
                      element['date'].compareTo(DateTime.now()).isNegative,
                )
                .toList()
                .length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: appointmentwidget(
                context,
                screenSize,
                DummyData.lunaApointments(context)
                    .where(
                      (element) =>
                          element['date'].compareTo(DateTime.now()).isNegative,
                    )
                    .toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
