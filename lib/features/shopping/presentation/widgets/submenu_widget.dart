import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/pages/products_list_page.dart';

/// Builds a responsive submenu for browsing product categories. 🐾
///
/// This widget displays a set of tappable category icons (e.g., Feeding, Toys)
/// that allow users to navigate to a filtered list of products. It's a key
/// navigation component on the main `ShoppingPage`.
///
/// The layout is responsive:
/// - On wider screens, it displays as a `Row`.
/// - On narrower screens (<= 320px), it becomes a horizontally scrolling `ListView`
///   to prevent overflow.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
Widget subMenuWidget(BuildContext context, Size screenSize) {
  /// A hardcoded list of `AnimatedIconButton` widgets, one for each product category.
  /// Each button is configured with a unique icon, color, and `onClick` action.
  List<Widget> subMenuWidgets = [
    AnimatedIconButton(
      iconData: FontAwesomeIcons.plus,
      foregroundColor: AppPalette.dunflowerGold.withValues(
        alpha: Theme.brightnessOf(context) == Brightness.dark ? 0.7 : 0.5,
      ),
      radius: BorderRadius.all(Radius.circular(20)),

      /// The visual content of the button, including the icon and text.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 61,
            width: 61,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppPalette.dunflowerGold.withValues(
                alpha: Theme.brightnessOf(context) == Brightness.dark
                    ? 0.7
                    : 0.4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              'assets/illustrations/food_bowl.svg',
              height: 40,
            ),
          ),
          Text(
            "Feeding",
            style: AppTextStyles.ctaBold.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPalette.textOnSecondaryBg(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),

      /// The action to perform on tap. Navigates to a `ProductsListPage`
      /// filtered for the "Feeding" category.
      onClick: () {
        Get.to(
          () => ProductsListPage(
            title: 'Food Products',
            listOfProducts: List.generate(
              DummyData.listOfFood.length,
              (index) => ProductEntity(
                id: DummyData.listOfFood[index]['id'],
                category: DummyData.listOfFood[index]['type'],
                name: DummyData.listOfFood[index]['name'],
                price: DummyData.listOfFood[index]['price'],
                quantity: DummyData.listOfFood[index]['quantity'],
                picsUrls: [DummyData.listOfFood[index]['image']],
                description: DummyData.listOfFood[index]['description'],

                /// TODO: The promo price is randomly generated. In a real app,
                /// this should come from the data source.
                promoPrice: Random().nextBool()
                    ? (DummyData.listOfFood[index]['price'] *
                          ((Random().nextInt(4) + 1.0) / 10))
                    : null,
              ),
            ),
          ),
        );
      },
    ),

    /// The button for the "Toys" category.
    AnimatedIconButton(
      iconData: FontAwesomeIcons.plus,
      foregroundColor: AppPalette.softBlue.withValues(
        alpha: Theme.brightnessOf(context) == Brightness.dark ? 0.7 : 0.5,
      ),
      radius: BorderRadius.all(Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 61,
            width: 61,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppPalette.softBlue.withValues(
                alpha: Theme.brightnessOf(context) == Brightness.dark
                    ? 0.7
                    : 0.4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              'assets/illustrations/ball_toy.svg',
              height: 40,
            ),
          ),
          Text(
            "Toys",
            style: AppTextStyles.ctaBold.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPalette.textOnSecondaryBg(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),

      /// The action to perform on tap. Navigates to a `ProductsListPage`
      /// filtered for the "Toys" category.
      onClick: () {
        Get.to(
          () => ProductsListPage(
            title: 'Toys',
            listOfProducts: List.generate(
              DummyData.listOfToys.length,
              (index) => ProductEntity(
                id: DummyData.listOfToys[index]['id'],
                category: DummyData.listOfToys[index]['type'],
                name: DummyData.listOfToys[index]['name'],
                price: DummyData.listOfToys[index]['price'],
                picsUrls: [DummyData.listOfToys[index]['image']],
                quantity: DummyData.listOfToys[index]['quantity'],
                description: DummyData.listOfToys[index]['description'],
                promoPrice: Random().nextBool()
                    ? (DummyData.listOfToys[index]['price'] *
                          ((Random().nextInt(4) + 1.0) / 10))
                    : null,
              ),
            ),
          ),
        );
      },
    ),

    /// The button for the "Health" category.
    AnimatedIconButton(
      iconData: FontAwesomeIcons.plus,
      foregroundColor: AppPalette.coralRose.withValues(
        alpha: Theme.brightnessOf(context) == Brightness.dark ? 0.7 : 0.5,
      ),

      radius: BorderRadius.all(Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 61,
            width: 61,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppPalette.coralRose.withValues(
                alpha: Theme.brightnessOf(context) == Brightness.dark
                    ? 0.7
                    : 0.4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              'assets/illustrations/heart.svg',
              height: 45,
            ),
          ),
          Text(
            "Health",
            style: AppTextStyles.ctaBold.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPalette.textOnSecondaryBg(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),

      /// The action to perform on tap. Navigates to a `ProductsListPage`
      /// filtered for the "Health" category.
      onClick: () {
        Get.to(
          () => ProductsListPage(
            title: 'Health Products',
            listOfProducts: List.generate(
              DummyData.listOfMedecines.length,
              (index) => ProductEntity(
                id: DummyData.listOfMedecines[index]['id'],
                category: DummyData.listOfMedecines[index]['type'],
                name: DummyData.listOfMedecines[index]['name'],
                price: DummyData.listOfMedecines[index]['price'],
                picsUrls: [DummyData.listOfMedecines[index]['image']],
                quantity: DummyData.listOfMedecines[index]['quantity'],
                description: DummyData.listOfMedecines[index]['description'],
                promoPrice: Random().nextBool()
                    ? (DummyData.listOfMedecines[index]['price'] *
                          ((Random().nextInt(4) + 1.0) / 10))
                    : null,
              ),
            ),
          ),
        );
      },
    ),

    /// The button for the "Grooming" category.
    AnimatedIconButton(
      iconData: FontAwesomeIcons.plus,
      foregroundColor: AppPalette.lavenderMist.withValues(
        alpha: Theme.brightnessOf(context) == Brightness.dark ? 0.7 : 0.5,
      ),
      radius: BorderRadius.all(Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 61,
            width: 61,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppPalette.lavenderMist.withValues(
                alpha: Theme.brightnessOf(context) == Brightness.dark
                    ? 0.7
                    : 0.3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            margin: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              'assets/illustrations/grooming_tools.svg',
              height: 40,
            ),
          ),
          Text(
            "Grooming",
            style: AppTextStyles.ctaBold.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppPalette.textOnSecondaryBg(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),

      /// The action to perform on tap. Navigates to a `ProductsListPage`
      /// filtered for the "Grooming" category.
      onClick: () {
        Get.to(
          () => ProductsListPage(
            title: 'Grooming Products',
            listOfProducts: List.generate(
              DummyData.listOfGrommingProducts.length,
              (index) => ProductEntity(
                id: DummyData.listOfGrommingProducts[index]['id'],
                category: DummyData.listOfGrommingProducts[index]['type'],
                name: DummyData.listOfGrommingProducts[index]['name'],
                price: DummyData.listOfGrommingProducts[index]['price'],
                picsUrls: [DummyData.listOfGrommingProducts[index]['image']],
                quantity: DummyData.listOfGrommingProducts[index]['quantity'],
                description:
                    DummyData.listOfGrommingProducts[index]['description'],
                promoPrice: Random().nextBool()
                    ? (DummyData.listOfGrommingProducts[index]['price'] *
                          ((Random().nextInt(4) + 1.0) / 10))
                    : null,
              ),
            ),
          ),
        );
      },
    ),
  ];

  /// A `LayoutBuilder` is used to create a responsive layout. It checks the
  /// available width and chooses the appropriate widget (`ListView` or `Row`).
  return LayoutBuilder(
    builder: (context, constraints) {
      /// For very narrow screens (e.g., small phones in portrait), use a
      /// horizontally scrolling `ListView` to prevent the buttons from overflowing.
      return constraints.maxWidth <= 320
          ? SizedBox(
              height: 105,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: subMenuWidgets,
              ),
            )
          /// For wider screens, use a `Row` to display the buttons side-by-side.
          /// The `mainAxisAlignment` is adjusted based on the width for better centering.
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth >= 360
                    ? screenSize.width * 0.05
                    : 0,
              ),
              child: Row(
                mainAxisAlignment: constraints.maxWidth >= 360
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: subMenuWidgets,
              ),
            );
    },
  );
}
