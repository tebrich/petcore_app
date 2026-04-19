import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/presentation/controller/product_search_controller.dart';
import 'package:peticare/features/shopping/presentation/widgets/product_grid.dart';
import 'package:shimmer/shimmer.dart';

/// A page that allows users to search for products. 🔍
///
/// This `StatelessWidget` provides the user interface for the product search
/// functionality. It integrates with the [ProductSearchController] via `GetX`
/// to manage state and handle search logic.
///
/// The page displays three different states in its body:
/// 1.  **Initial/Loading State**: When no search has been performed yet
///     (`searchResultList == null`), it shows a grid of shimmer placeholders
///     to indicate that content is available to be searched.
/// 2.  **No Results State**: If a search is performed but yields no results
///     (`searchResultList.isEmpty`), it displays a user-friendly message
///     with an icon.
/// 3.  **Results State**: When search results are available, it displays them
///     in a responsive `GridView`.
class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage({super.key});

  @override
  /// Builds the main UI for the product search page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GetBuilder<ProductSearchController>(
      init: ProductSearchController(),
      builder: (searchingPageController) => Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          scrolledUnderElevation: 3,
          automaticallyImplyLeading: true,
          titleSpacing: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 45,

              /// The main text field for user input.
              child: TextField(
                controller: searchingPageController.searchFieldController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),

                  /// A button to clear the search field and results.
                  suffixIcon: AnimatedIconButton(
                    foregroundColor: AppPalette.disabled(context),
                    iconSize: 20,
                    iconData: Icons.cancel_rounded,
                    onClick: () => searchingPageController.clearSearch(),
                  ),
                ),

                /// Handles real-time search logic by calling the controller.
                /// It clears results on empty input or triggers a debounced search.
                onChanged: (value) {
                  if (value.isEmpty) {
                    searchingPageController.clearSearch();
                  } else {
                    searchingPageController.autocompleteDebounce();
                  }
                },
              ),
            ),
          ),
        ),

        /// The body of the scaffold, which conditionally renders content
        /// based on the state of the search results from the controller.
        body: searchingPageController.searchResultList == null
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                padding: EdgeInsets.fromLTRB(
                  screenSize.width * 0.05,
                  24,
                  screenSize.width * 0.025,
                  16,
                ),
                physics: const NeverScrollableScrollPhysics(),
                // TODO: The item count is hardcoded. Consider making this dynamic
                // or setting it to a smaller, more reasonable number (e.g., 8 or 10)
                // to fill the initial screen view.
                itemCount: 20,
                itemBuilder: (context, index) {
                  return shimmerProductWidget(context);
                },
              )
            : searchingPageController.searchResultList!.isEmpty
            // Displays a message when no products match the search query.
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.1,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Icon(
                              FontAwesomeIcons.circleXmark,
                              size: 100,
                              color: AppPalette.primary,
                            ),
                          ),
                        ),
                        TextSpan(
                          text:
                              "\nSorry, no products match your search criteria",
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\nPlease try a different search term or browse our categories for more options.",
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.disabled(context),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            // Displays the grid of products that match the search query.
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                padding: EdgeInsets.fromLTRB(
                  screenSize.width * 0.05,
                  24,
                  screenSize.width * 0.025,
                  16,
                ),
                itemCount: searchingPageController.searchResultList!.length,
                itemBuilder: (context, index) {
                  return productGridElementWidget(
                    context,
                    searchingPageController.searchResultList![index],
                  );
                },
              ),
      ),
    );
  }

  /// Builds a shimmer loading placeholder for a single product grid item.
  ///
  /// This widget is used to create a skeleton loading effect before the initial
  /// product suggestions are displayed. The width of the text placeholders is
  /// randomized to create a more dynamic and less repetitive appearance.
  Widget shimmerProductWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: AppPalette.background(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppPalette.primaryText(context).withValues(alpha: .075),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Shimmer.fromColors(
                baseColor: Theme.brightnessOf(context) == Brightness.dark
                    ? AppPalette.dBackground
                    : AppPalette.lSurfaces,
                highlightColor: Theme.brightnessOf(context) == Brightness.dark
                    ? AppPalette.dSurfaces
                    : AppPalette.lBackground,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPalette.background(context),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 1, child: SizedBox()),

                  /// // Product name
                  Expanded(
                    flex: 2,
                    child: Shimmer.fromColors(
                      baseColor: Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dBackground
                          : AppPalette.lSurfaces,
                      highlightColor:
                          Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dSurfaces
                          : AppPalette.lBackground,
                      child: Container(
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 10),

                        width:
                            constraints.maxWidth *
                            (Random().nextInt(5) + 5) /
                            10,
                        decoration: BoxDecoration(
                          color: AppPalette.background(context),
                          borderRadius: BorderRadius.all(Radius.circular(2.5)),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),

                  /// /// Product Category
                  Expanded(
                    flex: 1,
                    child: Shimmer.fromColors(
                      baseColor: Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dBackground
                          : AppPalette.lSurfaces,
                      highlightColor:
                          Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dSurfaces
                          : AppPalette.lBackground,
                      child: Container(
                        height: 35,
                        width: constraints.maxWidth * .25,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppPalette.background(context),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),

                  /// /// Product Price
                  Expanded(
                    flex: 3,
                    child: Shimmer.fromColors(
                      baseColor: Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dBackground
                          : AppPalette.lSurfaces,
                      highlightColor:
                          Theme.brightnessOf(context) == Brightness.dark
                          ? AppPalette.dSurfaces
                          : AppPalette.lBackground,
                      child: Container(
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 10),

                        width:
                            constraints.maxWidth *
                            (Random().nextInt(4) + 4) /
                            10,
                        decoration: BoxDecoration(
                          color: AppPalette.background(context),
                          borderRadius: BorderRadius.all(Radius.circular(2.5)),
                        ),
                      ),
                    ),
                  ),

                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
