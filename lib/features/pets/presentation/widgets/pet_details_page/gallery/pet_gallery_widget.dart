import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a pet's photo gallery in a responsive, staggered grid. 🖼️
///
/// This widget is designed to be the content of the "Gallery" tab within the
/// `PetDetailsMenu`. It uses `MasonryGridView` to create a visually interesting
/// layout that adapts to different screen sizes.
///
/// Key features include:
/// - A special "Add New Image" card as the first item in the grid.
/// - Network images loaded with a `Shimmer` placeholder for a smooth loading experience.
/// - A randomized height for the shimmer placeholder to create a more dynamic look.
/// - An error widget that is displayed if an image fails to load.
class PetGalleryWidget extends StatelessWidget {
  const PetGalleryWidget({super.key});

  @override
  /// Builds the main UI for the pet gallery.
  Widget build(BuildContext context) {
    /// Determines the number of columns based on screen width for responsiveness.
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: crossAxisCount,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        itemCount: DummyData.lunaGallery.length + 1,
        scrollDirection: Axis.vertical,

        itemBuilder: (context, index) {
          /// The first item in the grid is always the "Add New Image" widget.
          if (index == 0) {
            return addNewImageToGalleryWidget(context);
          }

          /// Fetches the image URL from the dummy data list.
          /// The index is offset by -1 because the first grid item is the add button.
          final imageUrl = DummyData.lunaGallery[index - 1];

          /// Randomizes the placeholder height to create a more dynamic loading skeleton.
          final double placeHolderHeight = Random().nextBool() ? 200 : 120;

          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,

              /// Displays a shimmer effect while the image is loading.
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: AppPalette.surfaces(context),
                  highlightColor: AppPalette.background(context),
                  child: Container(
                    height: placeHolderHeight,
                    color: AppPalette.background(context),
                  ),
                );
              },

              /// Displays a user-friendly error message if the image fails to load.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: placeHolderHeight,
                  color: AppPalette.surfaces(context),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        size: placeHolderHeight == 200 ? 48 : 35,
                        color: AppPalette.secondaryText(context),
                      ),

                      Text(
                        'There was an error loading this picture.',
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppPalette.primaryText(context),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds the "Add New Image" card for the gallery.
  ///
  /// This helper widget creates a tappable card with an icon and text,
  /// prompting the user to add a new photo. In a real application, the
  /// `onTap` would trigger an image picker.
  Widget addNewImageToGalleryWidget(BuildContext context) {
    return Material(
      elevation: 2,
      color: AppPalette.surfaces(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppPalette.secondaryText(context)),
      ),

      clipBehavior: Clip.antiAlias,
      child: InkWell(
        /// TODO: Implement image picking logic (e.g., from camera or gallery).
        onTap: () {},
        splashColor: AppPalette.secondary(context).withValues(alpha: .5),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  /// A decorative background shape behind the main illustration.
                  Positioned(
                    bottom: 0,
                    child: SvgPicture.asset(
                      'assets/illustrations/background_shape.svg',
                      height: 110,
                      colorFilter: ColorFilter.mode(
                        AppPalette.secondary(context).withValues(alpha: 0.65),
                        BlendMode.srcATop,
                      ),
                    ),
                  ),

                  /// The main illustration for adding a new image.
                  SvgPicture.asset(
                    'assets/illustrations/new_image.svg',
                    height: 90,
                  ),
                ],
              ),

              /// The text prompt for the user.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Add new Image to Gallery",
                  style: AppTextStyles.playfulTag.copyWith(
                    color: AppPalette.secondaryText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
