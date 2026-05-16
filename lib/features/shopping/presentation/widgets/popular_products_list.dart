import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/pages/product_details_page.dart';
import 'package:peticare/features/shopping/presentation/widgets/cart_loading_widget.dart';
import 'package:peticare/features/shopping/presentation/controller/shop_controller.dart';
import 'package:peticare/core/utils/price_formatter.dart';

/// Builds a horizontally scrolling list of "Popular Products". 🌟
///
/// This widget is a key feature on the main `ShoppingPage`, designed to showcase
/// a curated selection of popular items. It uses a `ListView.builder` for
/// efficient rendering of product cards.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
Widget popularProductListWidgetBuilder(BuildContext context) {

final ShopController controller =
    Get.put(ShopController());

  return Obx(() {

  if (controller.isLoadingFeatured.value) {

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  return SizedBox(
    height: 165,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.featuredProducts.length,
      itemBuilder: (context, index) => Center(
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0
                ? MediaQuery.of(context).size.width * 0.05
                : 0,
            right: 16.0,
          ),
          height: 155,
          width: 90,
          child: _productWidgetBuilder(

            context,

            controller.featuredProducts[index]
          ),
        ),
      ),
    ),
  );
});
}

/// Builds the UI for a single product card within the popular products list.
///
/// This private helper widget creates a compact, tappable card that displays
/// essential product information, including its image, category icon, name,
/// and price (with support for promotional pricing).
///
/// **Note:** This widget's UI is very similar to `productGridElementWidget`.
/// In a larger application, this could be refactored into a single, reusable
/// `ProductCard` widget to avoid code duplication.
Widget _productWidgetBuilder(
  BuildContext context,
  ProductEntity productDetails,
) {
  return Stack(
    children: [
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
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppPalette.lBackground,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      child: Image.network(
                        productDetails.picsUrls[0],
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        loadingBuilder: (context, child, loadingProgress) {
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
                              rightOutsideLineColor:
                                  AppPalette.textOnSecondaryBg(context),
                              rightOutsideLineStrokeWidth: 0.75,
                              roadLineColor: AppPalette.primaryText(context),
                              roadStrokeWidth: 1.5,
                              color: AppPalette.textOnSecondaryBg(context),
                              strokeWidth: 0.5,
                            ),
                          );
                        },
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
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.lBackground,
                      ),
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (productDetails.category.toLowerCase() ==
                                          'grooming'
                                      ? AppPalette.lavenderMist
                                      : productDetails.category.toLowerCase() ==
                                            'toy'
                                      ? AppPalette.softBlue
                                      : productDetails.category.toLowerCase() ==
                                            'health'
                                      ? AppPalette.coralRose
                                      : AppPalette.dunflowerGold)
                                  .withValues(alpha: .2),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          productDetails.category.toLowerCase() == 'grooming'
                              ? 'assets/illustrations/grooming_tools.svg'
                              : productDetails.category.toLowerCase() == 'toy'
                              ? 'assets/illustrations/ball_toy.svg'
                              : productDetails.category.toLowerCase() ==
                                    'health'
                              ? 'assets/illustrations/heart.svg'
                              : 'assets/illustrations/food_bowl.svg',
                          height: 22.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      productDetails.name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      8.0,
                      0.0,
                      8.0,
                      0.0,
                    ),

                    child: FittedBox(

                      fit: BoxFit.scaleDown,

                      child: Text(

                        PriceFormatter.formatGs(

                          productDetails.promoPrice ??

                          productDetails.price,
                        ),

                        style: AppTextStyles.ctaBold.copyWith(

                          fontSize: 18,

                          color: AppPalette.primary,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
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

/// A static list of [ProductEntity] objects representing popular products.
///
/// This list is hardcoded for demonstration purposes, pulling specific items
/// from the `DummyData` source. In a real-world application, this data would
/// be fetched dynamically from a backend API (e.g., an endpoint like `/api/products/popular`).
