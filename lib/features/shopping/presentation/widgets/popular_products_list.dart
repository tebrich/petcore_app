import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/pages/product_details_page.dart';
import 'package:peticare/features/shopping/presentation/widgets/cart_loading_widget.dart';

/// Builds a horizontally scrolling list of "Popular Products". 🌟
///
/// This widget is a key feature on the main `ShoppingPage`, designed to showcase
/// a curated selection of popular items. It uses a `ListView.builder` for
/// efficient rendering of product cards.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
Widget popularProductListWidgetBuilder(BuildContext context) {
  return SizedBox(
    height: 165,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: popularProductsList.length,
      itemBuilder: (context, index) => Center(
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0 ? MediaQuery.of(context).size.width * 0.05 : 0,
            right: 16.0,
          ),
          height: 155,
          width: 90,
          child: _productWidgetBuilder(
            context,
            ProductEntity(
              id: popularProductsList[index].id,
              category: popularProductsList[index].category,
              name: popularProductsList[index].name,
              price: popularProductsList[index].price,
              picsUrls: popularProductsList[index].picsUrls,
              quantity: popularProductsList[index].quantity,
              promoPrice: popularProductsList[index].promoPrice,
              description: popularProductsList[index].description,
            ),
          ),
        ),
      ),
    ),
  );
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
                        fit: BoxFit.cover,
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
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
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
                                color: AppPalette.textOnSecondaryBg(context),
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
final List<ProductEntity> popularProductsList = [
  ProductEntity(
    id: DummyData.listOfFood[4]['id'],
    category: DummyData.listOfFood[4]['type'],
    name: DummyData.listOfFood[4]['name'],
    price: DummyData.listOfFood[4]['price'],
    picsUrls: [DummyData.listOfFood[4]['image']],
    quantity: DummyData.listOfFood[4]['quantity'],
    description: DummyData.listOfFood[4]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfFood[4]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfGrommingProducts[5]['id'],
    category: DummyData.listOfGrommingProducts[5]['type'],
    name: DummyData.listOfGrommingProducts[5]['name'],
    price: DummyData.listOfGrommingProducts[5]['price'],
    picsUrls: [DummyData.listOfGrommingProducts[5]['image']],
    quantity: DummyData.listOfGrommingProducts[5]['quantity'],
    description: DummyData.listOfGrommingProducts[5]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfGrommingProducts[5]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfMedecines[4]['id'],
    category: DummyData.listOfMedecines[4]['type'],
    name: DummyData.listOfMedecines[4]['name'],
    price: DummyData.listOfMedecines[4]['price'],
    picsUrls: [DummyData.listOfMedecines[4]['image']],
    quantity: DummyData.listOfMedecines[4]['quantity'],
    description: DummyData.listOfMedecines[4]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfMedecines[4]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfFood[9]['id'],
    category: DummyData.listOfFood[9]['type'],
    name: DummyData.listOfFood[9]['name'],
    price: DummyData.listOfFood[9]['price'],
    picsUrls: [DummyData.listOfFood[9]['image']],
    quantity: DummyData.listOfFood[9]['quantity'],
    description: DummyData.listOfFood[9]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfFood[9]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfGrommingProducts[10]['id'],
    category: DummyData.listOfGrommingProducts[10]['type'],
    name: DummyData.listOfGrommingProducts[10]['name'],
    price: DummyData.listOfGrommingProducts[10]['price'],
    picsUrls: [DummyData.listOfGrommingProducts[10]['image']],
    quantity: DummyData.listOfGrommingProducts[10]['quantity'],
    description: DummyData.listOfGrommingProducts[10]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfGrommingProducts[10]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfMedecines[8]['id'],
    category: DummyData.listOfMedecines[8]['type'],
    name: DummyData.listOfMedecines[8]['name'],
    price: DummyData.listOfMedecines[8]['price'],
    picsUrls: [DummyData.listOfMedecines[8]['image']],
    quantity: DummyData.listOfMedecines[8]['quantity'],
    description: DummyData.listOfMedecines[8]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfMedecines[8]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfFood[14]['id'],
    category: DummyData.listOfFood[14]['type'],
    name: DummyData.listOfFood[14]['name'],
    price: DummyData.listOfFood[14]['price'],
    picsUrls: [DummyData.listOfFood[14]['image']],
    quantity: DummyData.listOfFood[14]['quantity'],
    description: DummyData.listOfFood[14]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfFood[14]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
  ProductEntity(
    id: DummyData.listOfGrommingProducts[14]['id'],
    category: DummyData.listOfGrommingProducts[14]['type'],
    name: DummyData.listOfGrommingProducts[14]['name'],
    price: DummyData.listOfGrommingProducts[14]['price'],
    picsUrls: [DummyData.listOfGrommingProducts[14]['image']],
    quantity: DummyData.listOfGrommingProducts[14]['quantity'],
    description: DummyData.listOfGrommingProducts[14]['description'],
    promoPrice: Random().nextBool()
        ? (DummyData.listOfGrommingProducts[14]['price'] *
              ((Random().nextInt(4) + 1.0) / 10))
        : null,
  ),
];
