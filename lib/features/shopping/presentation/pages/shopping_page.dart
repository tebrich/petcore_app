import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_text_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/shopping/presentation/widgets/popular_products_list.dart';
import 'package:peticare/features/shopping/presentation/widgets/promos_sections.dart';
import 'package:peticare/features/shopping/presentation/widgets/promotion_banner_widget.dart';
import 'package:peticare/features/shopping/presentation/widgets/submenu_widget.dart';

/// The main entry point for the shopping feature of the application. 🛍️
///
/// This `StatelessWidget` constructs the primary shopping interface, serving as a
/// hub for users to discover products. It aggregates several smaller widgets
/// to create a comprehensive and engaging user experience.
///
/// Key sections of this page include:
/// - A header with the page title and a cart icon that shows the item count.
/// - A tappable search bar that navigates to the [ProductSearchPage].
/// - A horizontal submenu for browsing product categories.
/// - A dynamic section for displaying promotional banners.
/// - A list of "Popular Products" with a "See All" navigation option.
class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  /// Builds the main UI for the shopping page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    /*
    * TEXT FORMATTING GUIDE FOR PROMOTIONAL CONTENT
    * =============================================
    * 
    * To properly format promotional text with bold discount/offer text:
    * 
    * FORMAT: ***DISCOUNT_TEXT*** remaining_description_text
    * 
    * RULES:
    * - Use exactly THREE asterisks (***) before and after the discount/offer text
    * - The text between *** will be extracted and displayed in BOLD
    * - The remaining text after the closing *** will be regular text
    * - No spaces needed between *** and the discount text
    * 
    * EXAMPLES:
    * ✅ CORRECT:
    * "***20% OFF*** all grooming services – only this weekend!"
    * "***BUY 1 GET 1 FREE*** on all hair products this month"
    * "***50% DISCOUNT*** limited time offer - hurry up!"
    * "***NEW ARRIVAL*** premium skincare collection now available"
    * 
    * ❌ INCORRECT:
    * "**20% OFF** all grooming services"           // Only 2 asterisks
    * "*** 20% OFF *** all grooming services"      // Spaces around asterisks
    * "*20% OFF* all grooming services"            // Only 1 asterisk
    * "20% OFF all grooming services"              // No formatting markers
    * 
    * RESULT:
    * - Bold text: The content between ***...***
    * - Regular text: Everything after the closing ***
    * 
    * NOTE: This formatting is automatically parsed by the app to create
    * proper text styling with bold highlights for promotional content.
    */

    /// A list of promotional banner widgets to be displayed.
    ///
    /// The `promotionBannerWidget` uses a special text formatting convention
    /// (wrapping text in `***...***`) to highlight promotional offers. This
    /// allows for dynamic styling of promotional text directly from the
    /// string data.
    final List<Widget> listOfPromos = [
      promotionBannerWidget(
        context,
        promoText: 'Just for You',
        promoColor: AppPalette.primary,
        title: 'Happy Pet',
        subtitle: '***30% OFF*** all pet food the whole month!',
        color: AppPalette.primary,
        imageUrl:
            "https://www.laughingdogfood.com/wp-content/uploads/2021/06/LaughingDog-Food-Treat-Fruit.webp",
      ),
      promotionBannerWidget(
        context,
        promoText: 'Limited Time',
        promoColor: AppPalette.lavenderMist,
        title: 'Groom & Glow',
        subtitle: '***20% OFF*** all grooming services – only this weekend!',
        color: AppPalette.lavenderMist,
        imageUrl:
            "https://www.canaanalpha.com/wp-content/uploads/2023/05/Aniflea_.png",
      ),
      promotionBannerWidget(
        context,
        promoColor: AppPalette.success(context),
        title: 'Toy Fiesta',
        subtitle: 'Buy 2 toys, get 1 FREE – because playtime never ends!',
        color: AppPalette.success(context),
        imageUrl:
            "https://static.vecteezy.com/system/resources/previews/049/106/208/non_2x/cute-dog-toy-isolated-on-transparent-background-free-png.png",
      ),
      promotionBannerWidget(
        context,
        promoText: 'Special Offer',
        promoColor: AppPalette.coralRose,
        title: 'Wellness Week',
        subtitle:
            '***Get 25% OFF*** all health care items – let your pet thrive!',
        color: AppPalette.coralRose,
        imageUrl:
            "https://zestypaws.com/cdn/shop/products/API2.0CalmingTurkey-01.png",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Top spacing for visual balance.
              VerticalSpacing.lg(context),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Row(
                  /// The header row containing the page title and the shopping cart icon.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Peticare Shopping',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppPalette.textOnSecondaryBg(context),
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "\nAll your pet care essentials in one place!",
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppPalette.disabled(context),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    /// Horizontal spacing between the title and the cart icon.
                    SizedBox(width: 4),

                    AnimatedIconButton(
                      /// The shopping cart icon, which navigates to the [ShoppingCartPage].
                      iconData: Icons.shopping_cart,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            'assets/illustrations/cart.svg',
                            height: 40,
                          ),
                          Positioned(
                            /// A badge indicating the number of items in the cart.
                            top: -6.0,
                            right: 0.0,
                            child: Container(
                              height: 17.5,
                              width: 17.5,
                              padding: EdgeInsets.all(0.5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppPalette.danger(context),
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  // TODO: Replace with dynamic data from CartController.
                                  "3",
                                  style: AppTextStyles.playfulTag.copyWith(
                                    fontSize: 12,
                                    color: AppPalette.lBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onClick: () {
                        Get.toNamed('/ShoppingCart');
                      },
                    ),
                  ],
                ),
              ),

              /// Space after the title section.
              VerticalSpacing.xl(context),

              SizedBox(
                /// A read-only text field that acts as a search bar, navigating to the search page on tap.
                width: screenSize.width * 0.9,
                height: 50,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: Theme.of(context).inputDecorationTheme
                        .copyWith(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: AppPalette.secondaryText(context),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: AppPalette.primary,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: AppPalette.danger(context),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: AppPalette.secondaryText(context),
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: AppPalette.secondaryText(context),
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: AppPalette.danger(context),
                              strokeAlign: 0.5,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            maxWidth: 45,
                            minHeight: 30,
                            maxHeight: 50,
                          ),
                        ),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    readOnly: true,
                    onTap: () {
                      Get.toNamed('ProductSearch');
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppPalette.surfaces(
                        context,
                      ).withValues(alpha: .5),
                      hintText: 'Search for products',
                      prefixIcon: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),

              /// Section Spacing
              VerticalSpacing.xl(context),
              subMenuWidget(context, screenSize),

              /// Section Spacing
              VerticalSpacing.xl(context),
              PromosSections(listOfPromos: listOfPromos),

              /// Section Spacing
              VerticalSpacing.xxl(context),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Popular Products',
                      style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 18,
                        color: AppPalette.textOnSecondaryBg(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    AnimatedTextButton(
                      text: 'See All',
                      onClick: () {
                        // TODO: Implement navigation to a full list of popular products.
                      },
                    ),
                  ],
                ),
              ),
              popularProductListWidgetBuilder(context),

              VerticalSpacing.xl(context),
            ],
          ),
        ),
      ),
    );
  }
}
