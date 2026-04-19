import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/pets/presentation/pages/pet_details_page.dart';
import 'package:peticare/features/pets/presentation/widgets/pets_page/pet_widget.dart';
import 'package:peticare/features/pets/presentation/widgets/pets_page/tips_widget.dart';

/// The main page for displaying a user's list of registered pets. 🐾
///
/// This widget serves as a central hub where users can see all their pets at a
/// glance. It features a welcoming header, a horizontally scrollable `TipsWidget`
/// for helpful advice, and a vertical list of pets.
///
/// Each pet in the list is rendered using a `petWidget` and wrapped in an
/// `OpenContainer` from the `animations` package. This provides a seamless
/// "container transform" transition when a user taps on a pet, smoothly
/// animating to the `PetDetailsPage`.
class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  /// Builds the main UI for the "My Pets" page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top spacing for visual balance.
              VerticalSpacing.lg(context),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),

                /// The main page heading with a title and a friendly subtitle.
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'pets_page_title'.tr,
                        style: AppTextStyles.petName.copyWith(
                          color: AppPalette.textOnSecondaryBg(context),
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:'\n${'pets_page_subtitle'.tr}',
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppPalette.disabled(context),
                          fontSize: 14,
                          //fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Space after the title.
              VerticalSpacing.lg(context),

              /// A horizontally scrollable widget displaying helpful pet care tips.
              TipsWidget(),

              /// Vertical spacing to separate the tips from the pet list.
              VerticalSpacing.xl(context),

              /// A `ListView` that dynamically builds a list of pet widgets.
              ///
              /// It fetches pet data from `DummyData` and creates an `OpenContainer`
              /// for each pet, enabling a smooth transition to the details page.
              /// The `NeverScrollableScrollPhysics` is used because the parent
              /// is already a `SingleChildScrollView`.
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                itemCount: DummyData.petsList(context).length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),

                  /// An animated container that transitions to the `PetDetailsPage`.
                  ///
                  /// This provides a seamless "material motion" transition where the
                  /// `petWidget` appears to grow into the `PetDetailsPage`.
                  child: OpenContainer(
                    clipBehavior: Clip.none,
                    openElevation: 0,
                    closedElevation: 0,
                    openColor: AppPalette.background(context),
                    closedColor: AppPalette.background(context),
                    transitionDuration: const Duration(milliseconds: 500),
                    useRootNavigator: true,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    closedBuilder: (context, action) => petWidget(
                       context,
                       screenSize,
                       DummyData.petsList(context)[index],
                    ),
                    openBuilder: (context, action) => PetDetailsPage(
                      petDetails: DummyData.petsList(context)[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
