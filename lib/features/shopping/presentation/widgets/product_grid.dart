import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/pages/product_details_page.dart';
import 'package:peticare/features/shopping/presentation/widgets/cart_loading_widget.dart';

/// Builds a widget for a single product item in a grid layout. 📱
///
/// This function creates a tappable card that displays essential product
/// information, including its image, name, category, and price. It's designed
/// to be used as a builder item in a `GridView`, such as on the
/// [ProductsListPage] or [ProductSearchPage].
///
/// Key features include:
/// - A responsive layout suitable for grid displays.
/// - An image loader with a custom animated loading state and an error state.
/// - A styled tag for the product category.
/// - Dynamic price display that shows a strikethrough for the original price
///   if a promotional price is available.
/// - Navigation to the [ProductDetailsPage] when the card is tapped.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `productDetails`: The [ProductEntity] object containing the product data.
Widget productGridElementWidget(
  BuildContext context,
  ProductEntity productDetails,
) {
  return Stack(
    /// A unique key for each product, which helps Flutter's rendering engine
    /// efficiently update the grid when the list changes.
    key: Key(productDetails.id),
    children: [
      /// The main container for the card's visual content and styling.
      Container(
        decoration: BoxDecoration(
          color: Theme.brightnessOf(context) == Brightness.dark
              ? AppPalette.surfaces(context)
              : AppPalette.background(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppPalette.primaryText(context).withValues(
                alpha: Theme.brightnessOf(context) == Brightness.dark
                    ? 0.13
                    : 0.05,
              ),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,

              /// A container for the product image with a light background color.
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  color: AppPalette.lBackground,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),

                  /// Uses `Image.network` to load the image, with custom builders for loading and error states.
                  child: Image.network(
                    productDetails.picsUrls[0],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    loadingBuilder: (context, child, loadingProgress) {
                      /// Displays an animated loading cart while the image is being fetched.
                      if (loadingProgress == null) return child;
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(double.infinity * .1),
                          ),
                          color: AppPalette.primary.withValues(alpha: .05),
                        ),
                        child: AnimatedCartLoading(
                          logoSize: Size(40, 40),
                          rightOutsideLineColor: AppPalette.textOnSecondaryBg(
                            context,
                          ),
                          rightOutsideLineStrokeWidth: 0.75,
                          roadLineColor: AppPalette.primaryText(context),
                          roadStrokeWidth: 1.5,
                          color: AppPalette.textOnSecondaryBg(context),
                          strokeWidth: 0.5,
                        ),
                      );
                    },

                    /// Displays a user-friendly error message if the image fails to load.
                    errorBuilder: (context, error, stackTrace) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(double.infinity * .1),
                        ),
                        color: AppPalette.disabled(
                          context,
                        ).withValues(alpha: 0.3),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 30,
                            color: AppPalette.secondaryText(context),
                          ),

                          const SizedBox(height: 4.0),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Image failed to load',
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppPalette.secondaryText(context),
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,

              /// The bottom section of the card containing text details.
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// Displays the product name.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      productDetails.name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.primaryText(context),
                      ),
                    ),
                  ),

                  /// A styled tag that displays the product's category with a unique color.
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:
                          (productDetails.category.toLowerCase() == 'grooming'
                                  ? AppPalette.lavenderMist
                                  : productDetails.category.toLowerCase() ==
                                        'toy'
                                  ? AppPalette.softBlue
                                  : productDetails.category.toLowerCase() ==
                                        'health'
                                  ? AppPalette.coralRose
                                  : AppPalette.dunflowerGold)
                              .withValues(alpha: 0.25),
                    ),
                    child: Text(
                      productDetails.category,
                      style: AppTextStyles.playfulTag.copyWith(
                        fontSize: 10,
                        color:
                            (productDetails.category.toLowerCase() == 'grooming'
                            ? AppPalette.lavenderMist
                            : productDetails.category.toLowerCase() == 'toy'
                            ? AppPalette.softBlue
                            : productDetails.category.toLowerCase() == 'health'
                            ? AppPalette.coralRose
                            : AppPalette.dunflowerGold),
                      ),
                    ),
                  ),

                  /// A rich text widget to display the price, handling both
                  /// regular and promotional pricing with different styles.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "\$",
                              style: AppTextStyles.ctaBold.copyWith(
                                fontSize: productDetails.promoPrice == null
                                    ? 16
                                    : 9,
                                color: AppPalette.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: productDetails.price.toStringAsFixed(2),
                              style: AppTextStyles.ctaBold.copyWith(
                                decoration: productDetails.promoPrice == null
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                                fontSize: productDetails.promoPrice == null
                                    ? 19
                                    : 12,
                                color: productDetails.promoPrice == null
                                    ? AppPalette.primaryText(context)
                                    : AppPalette.textOnSecondaryBg(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (productDetails.promoPrice != null)
                              TextSpan(
                                text: " \$",
                                style: AppTextStyles.ctaBold.copyWith(
                                  fontSize: 16,
                                  color: AppPalette.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            TextSpan(
                              text: productDetails.promoPrice?.toStringAsFixed(
                                2,
                              ),
                              style: AppTextStyles.ctaBold.copyWith(
                                fontSize: 19,
                                color: AppPalette.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// A transparent `Material` widget layered on top to provide the `InkWell`
      /// ripple effect across the entire card.
      Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            /// Navigates to the `ProductDetailsPage` when the card is tapped.
            Get.to(() => ProductDetailsPage(productDetails: productDetails));
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: AppPalette.primary.withValues(alpha: .1),
          highlightColor: AppPalette.primary.withValues(alpha: .25),
        ),
      ),
    ],
  );
}
