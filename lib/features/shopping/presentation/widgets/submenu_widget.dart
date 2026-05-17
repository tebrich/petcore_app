import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/pages/products_list_page.dart';
import 'package:peticare/features/shopping/presentation/controller/shop_controller.dart';

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
Widget subMenuWidget(
  BuildContext context,
  Size screenSize,
) {

  final ShopController controller =
      Get.find<ShopController>();

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
            "Alimentos",
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

            title: 'Alimentos',

            listOfProducts:

                controller.allProducts

                    .where(

                      (product) =>

                          product.category
                              .toLowerCase()

                              == 'food',
                    )

                    .toList(),
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
            "Juguetes",
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

            title: 'Juguetes',

            listOfProducts:

                controller.allProducts

                    .where(

                      (product) =>

                          product.category
                              .toLowerCase()

                              == 'toys',
                    )

                    .toList(),
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
            "Salud",
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

            title: 'Salud',

            listOfProducts:

                controller.allProducts

                    .where(

                      (product) =>

                          product.category
                              .toLowerCase()

                              == 'health',
                    )

                    .toList(),
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
            "Peluquería",
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

            title: 'Peluquería',

            listOfProducts:

                controller.allProducts

                    .where(

                      (product) =>

                          product.category
                              .toLowerCase()

                              == 'grooming',
                    )

                    .toList(),
          ),
        );
      },
    ),

    AnimatedIconButton(

      iconData: FontAwesomeIcons.plus,

      foregroundColor: AppPalette.softBlue.withValues(
        alpha: Theme.brightnessOf(context)
                == Brightness.dark
            ? 0.7
            : 0.5,
      ),

      radius: BorderRadius.all(
        Radius.circular(20),
      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [

          Container(

            height: 61,
            width: 61,

            alignment: Alignment.center,

            decoration: BoxDecoration(

              color: AppPalette.softBlue
                  .withValues(
                alpha: Theme.brightnessOf(
                            context)
                        == Brightness.dark
                    ? 0.7
                    : 0.4,
              ),

              borderRadius:
                  BorderRadius.all(
                Radius.circular(25),
              ),
            ),

            margin: EdgeInsets.only(
              bottom: 5,
            ),

            child: Icon(
              Icons.checkroom,
              size: 34,
              color: Colors.white,
            ),
          ),

          Text(

            "Accesorios",

            style: AppTextStyles.ctaBold
                .copyWith(

              fontSize: 12,

              fontWeight:
                  FontWeight.w500,

              color: AppPalette
                  .textOnSecondaryBg(
                      context),
            ),

            textAlign: TextAlign.center,
          ),
        ],
      ),

      onClick: () {

        Get.to(

          () => ProductsListPage(

            title: 'Accesorios',

            listOfProducts:

                controller.allProducts

                    .where(

                      (product) =>

                          product.category
                              .toLowerCase()

                              == 'accessories',
                    )

                    .toList(),
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
              child: Wrap(

                alignment: WrapAlignment.spaceAround,

                spacing: 16,

                runSpacing: 18,

                children: subMenuWidgets,
              ),
            );
    },
  );
}
