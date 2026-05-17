import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';
import 'package:peticare/features/shopping/presentation/widgets/cart_loading_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import 'package:peticare/features/shopping/presentation/controller/cart_controller.dart';
import 'package:peticare/core/utils/price_formatter.dart';

/// A page that displays detailed information about a single product. 📱
///
/// This `StatefulWidget` provides a comprehensive view of a product, allowing
/// users to see multiple images, read the description, check the price, select
/// a quantity, and add the item to their cart.
///
/// Key features include:
/// - An interactive image viewer with a page indicator.
/// - A "favorite" button to toggle the product's favorite status.
/// - A quantity selector with "+" and "-" buttons.
/// - Dynamic price display that shows a strikethrough for the original price
///   if a promotional price is available.
/// - An "OUT OF STOCK" indicator if the product is unavailable.
/// - A primary "ADD TO CART" action button.
class ProductDetailsPage extends StatefulWidget {
  /// The product data to be displayed on the page.
  final ProductEntity productDetails;
  const ProductDetailsPage({required this.productDetails, super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

/// The state for the [ProductDetailsPage].
///
/// Manages the UI state, including the selected quantity and favorite status.
class _ProductDetailsPageState extends State<ProductDetailsPage> {
    final CartController cartController =
        Get.find<CartController>();
  // ===========================================================================
  // 🚀 State Variables
  // ===========================================================================

  /// The quantity of the product selected by the user. Defaults to 1.
  int selectedQte = 1;

  /// A boolean to track if the product is marked as a favorite.
  bool isFavoris = false;

  late PageController pageController;

  int currentPage = 0;

  // ===========================================================================
    // ♻️ LIFECYCLE
    // ===========================================================================

    @override
    void initState() {

      super.initState();

      pageController = PageController();
    }

    @override
    void dispose() {

      pageController.dispose();

      super.dispose();
    }

  // ===========================================================================
  // ⚙️ Business Logic & State Management
  // ===========================================================================

  /// Increases the selected quantity, up to the available stock limit.
  void increaseSelectedQte() {
    if (selectedQte < widget.productDetails.quantity) {
      setState(() {
        selectedQte++;
      });
    }
  }

  /// Decreases the selected quantity, with a minimum of 1.
  void decreaseSelectedQte() {
    if (selectedQte > 1) {
      setState(() {
        selectedQte--;
      });
    }
  }

  @override
  /// Builds the main UI for the product details page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// The main image viewer section, built as a [Stack] to overlay controls.
              SizedBox(
                width: screenSize.width,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    /// A container with a curved bottom border that holds the product image.
                    // TODO: Implement a PageView here to allow swiping between multiple product images.
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(screenSize.width * 0.3),
                      ),
                      child: Container(
                        color: const Color(0xFFF8F9FB),
                        height: screenSize.height < 600
                            ? 300
                            : screenSize.height * 0.5,
                        child: PageView.builder(

                          controller: pageController,

                          itemCount: widget.productDetails.picsUrls.length,

                          onPageChanged: (index) {

                            setState(() {

                              currentPage = index;

                            });

                          },

                          itemBuilder: (context, index) {

                            return Image.network(

                              widget.productDetails.picsUrls[index],

                              height: screenSize.height < 600
                                  ? 300
                                  : screenSize.height * 0.5,

                              width: screenSize.width,

                              fit: BoxFit.contain,

                              alignment: Alignment.center,

                              loadingBuilder:
                                  (context, child, loadingProgress) {

                                if (loadingProgress == null) {
                                  return child;
                                }

                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                );
                              },

                              errorBuilder:
                                  (context, error, stackTrace) {

                                return Container(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.error),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    /// A page indicator to show which image is currently visible.
                    Positioned(
                      bottom: -24.0,
                      child: AnimatedSmoothIndicator(
                        // TODO: This should be connected to the PageController of the PageView.
                        activeIndex: currentPage,
                        count: widget.productDetails.picsUrls.length,
                        effect: ExpandingDotsEffect(
                          expansionFactor: 2,
                          dotHeight: 10,
                          dotWidth: 10,
                          radius: 10,
                          spacing: 5,
                          activeDotColor: AppPalette.primary,
                          dotColor: AppPalette.disabled(context),
                        ),
                      ),
                    ),

                    /// A button to toggle the product's favorite status.
                    Positioned(
                      top: 8.0,
                      right: 16.0,
                      child: AnimatedIconButton(
                        iconSize: 20,
                        foregroundColor: isFavoris
                            ? AppPalette.lDanger
                            : AppPalette.lPrimaryText,
                        iconData: isFavoris
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,

                        // TODO: This should be connected to a controller to persist the favorite state.
                        onClick: () {

                          setState(() {

                            isFavoris = !isFavoris;

                          });
                        },
                      ),
                    ),

                    /// The back button to navigate to the previous screen.
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: AnimatedIconButton(
                        iconSize: 25,
                        foregroundColor: AppPalette.lPrimaryText,
                        iconData: Icons.arrow_back_rounded,

                        onClick: () => Navigator.pop(context),
                      ),
                    ),

                    /// A button to navigate to the previous image in the gallery.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedIconButton(
                        iconSize: 22.5,
                        foregroundColor: AppPalette.lDisabled,
                        iconData: Icons.arrow_back_ios_new_rounded,

                        // TODO: Implement logic to go to the previous page in the PageView.
                        onClick: () {

                          if (currentPage > 0) {

                            pageController.previousPage(

                              duration: const Duration(
                                milliseconds: 300,
                              ),

                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),

                    /// A button to navigate to the next image in the gallery.
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedIconButton(
                        iconSize: 22.5,
                        foregroundColor: AppPalette.lDisabled,
                        iconData: Icons.arrow_forward_ios_rounded,

                        // TODO: Implement logic to go to the next page in the PageView.
                        onClick: () {

                          if (
                            currentPage <
                            widget.productDetails.picsUrls.length - 1
                          ) {

                            pageController.nextPage(

                              duration: const Duration(
                                milliseconds: 300,
                              ),

                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Image Spacing
              VerticalSpacing.xxl(context),

              /// Displays the product category as a styled tag.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * .05,
                ),
                child: Text(
                  '#${translateCategory(
                      widget.productDetails.category,
                  )}',
                  style: AppTextStyles.playfulTag.copyWith(
                    color: AppPalette.primary,
                    fontSize: 11,
                  ),
                ),
              ),
              // Minor Spacing
              SizedBox(height: VerticalSpacing.sm(context).spacing / 4),

              /// Displays the product name.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  widget.productDetails.name,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppPalette.primaryText(context),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ),

              /// Displays a discount percentage badge if there is a promo price.
              widget.productDetails.promoPrice != null
                  ? Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: VerticalSpacing.sm(context).spacing,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        '-${calcPromoPercentage().toStringAsFixed(0)}%',
                        style: AppTextStyles.playfulTag.copyWith(
                          color: AppPalette.background(context),
                          fontSize: 13,
                        ),
                      ),
                    )
                  : VerticalSpacing.md(context),

              /// Displays the product price, quantity selector, and stock status.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * .05,
                ),
                child: Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  crossAxisAlignment:
                      CrossAxisAlignment.center,

                  children: [

                    FittedBox(

                      fit: BoxFit.scaleDown,

                      child: Text(

                        PriceFormatter.formatGs(

                          widget.productDetails.promoPrice ??

                          widget.productDetails.price,
                        ),

                        style: AppTextStyles.ctaBold.copyWith(

                          fontSize: 24,

                          color: AppPalette.primary,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Sections Spacing
              VerticalSpacing.xl(context),

              /// Displays the product description section.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Descripción:",
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppPalette.disabled(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  widget.productDetails.description ??
                      "This product has no Description",
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// CTA Spacing
              VerticalSpacing.xl(context),
              Center(
                /// The primary call-to-action button to add the product to the cart.
                child: AnimatedElevatedButton(
                  text: '',
                  size: Size(screenSize.width * 0.9, 45),
                  radius: BorderRadius.all(Radius.circular(10)),
                  foregroundColor: AppPalette.background(context),
                  onClick: () {

                    cartController.addToCart(

                      widget.productDetails,

                      1,
                    );

                    Get.snackbar(

                      'Carrito',

                      'Producto agregado correctamente',

                      snackPosition:
                          SnackPosition.BOTTOM,
                    );
                  },

                  // TODO: Implement "Add to Cart" logic, likely by calling a CartController.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.cartShopping, size: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Agregar al carrito",
                          style: AppTextStyles.buttonText.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppPalette.background(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// bottom Spacing
              VerticalSpacing.md(context),
            ],
          ),
        ),
      ),
    );
  }
  String translateCategory(
    String category,
  ) {

    switch (
      category.toLowerCase()
    ) {

      case 'food':
        return 'Alimentos';

      case 'toys':
        return 'Juguetes';

      case 'health':
        return 'Salud';

      case 'grooming':
        return 'Peluquería';

      case 'accessories':
        return 'Accesorios';

      default:
        return category;
    }
  }
  /// Calculates the discount percentage based on the original and promotional prices.
  double calcPromoPercentage() {
    if (widget.productDetails.promoPrice == null ||
        widget.productDetails.price == 0)
      return 0;
    return (1 -
            (widget.productDetails.promoPrice! / widget.productDetails.price)) *
        100;
  }
}
