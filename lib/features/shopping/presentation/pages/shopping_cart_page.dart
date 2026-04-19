import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/dotted_dash_divider.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/shopping/presentation/controller/cart_controller.dart';
import 'package:peticare/features/shopping/presentation/widgets/product_image_builder.dart';

/// A page that displays the contents of the user's shopping cart. 🛒
///
/// This `StatefulWidget` provides a detailed view of the items the user has
/// added to their cart. It interacts with the [CartController] to display
/// products and manage their quantities.
///
/// Key features include:
/// - A list of products in the cart, each with a quantity selector and a remove button.
/// - A dynamic "empty cart" state with a "Shop Now" call-to-action.
/// - A bottom summary sheet showing the total price and a "CHECK OUT" button.
/// - An animation that hides the bottom sheet when the last item is removed from the cart.
class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

/// The state for the [ShoppingCartPage].
///
/// Manages the `AnimationController` for the bottom sheet animation.
class _ShoppingCartPageState extends State<ShoppingCartPage>
    with SingleTickerProviderStateMixin {
  // ===========================================================================
  // 🚀 Animation Controllers
  // ===========================================================================

  /// Controls the animation for hiding the bottom sheet.
  late AnimationController _animationController;

  /// Defines the position animation for the bottom sheet, moving it off-screen.
  late Animation<double> _positionAnimation;

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  /// Builds the main UI for the shopping cart page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (cartController) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 4,
          automaticallyImplyLeading: true,
          title: Text(
            'My Cart',
            style: AppTextStyles.playfulTag.copyWith(
              color: AppPalette.primaryText(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            /// Conditionally displays either the empty cart widget or the list of products.
            cartController.cartContent.isEmpty
                ? _emptyCartStateWidgetBuilder(screenSize)
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartController.cartContent.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          /// Builds the widget for a single product in the cart.
                          _cartProduct(cartController, index),

                          /// A visual separator between cart items.
                          DottedLineDivider(
                            color: AppPalette.disabled(
                              context,
                            ).withValues(alpha: .4),
                            dashWidth: 15,
                            spaceWidth: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

            /// The bottom sheet that shows the total and checkout button.
            _bottomSheetWidgetBuilder(screenSize, cartController),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom summary sheet for the shopping cart.
  ///
  /// This widget is aligned to the bottom of the screen and displays the
  /// order total and a "CHECK OUT" button. It uses an [AnimatedBuilder]
  /// to slide off-screen when the cart becomes empty.
  Widget _bottomSheetWidgetBuilder(
    Size screenSize,
    CartController cartController,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            /// The container for the bottom sheet, which is animated.
            return Container(
              transform: Matrix4.translationValues(
                0,
                110 * _positionAnimation.value,
                0,
              ),
              height: 110,
              padding: EdgeInsetsGeometry.fromLTRB(
                screenSize.width * 0.055,
                12,
                screenSize.width * 0.055,
                6,
              ),
              decoration: BoxDecoration(
                color: AppPalette.background(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primary.withValues(
                      alpha: Theme.brightnessOf(context) == Brightness.dark
                          ? 0.1
                          : 0.1,
                    ),
                    offset: Offset(0, -1.5),
                    blurRadius: 1.5,
                  ),
                  BoxShadow(
                    color: AppPalette.primaryText(
                      context,
                    ).withValues(alpha: 0.05),
                    offset: Offset(0, -3),
                    blurRadius: 3,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Displays the total price of the items in the cart.
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppPalette.primaryText(context),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        // TODO: Replace hardcoded tax/fee with dynamic data from the controller.
                        '\$${(cartController.cartTotal + 2.0).toStringAsFixed(2)}',
                        style: AppTextStyles.ctaBold.copyWith(
                          fontSize: 17,
                          color: AppPalette.primaryText(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  /// The primary call-to-action button, which navigates to the checkout page.
                  /// It is disabled if the cart is empty.
                  AnimatedElevatedButton(
                    text: 'CHECK OUT',
                    textStyle: AppTextStyles.buttonText.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    size: Size(screenSize.width * 0.8, 40),
                    radius: BorderRadius.all(Radius.circular(15)),
                    onClick: cartController.cartContent.isEmpty
                        ? null
                        : () => Get.toNamed('/Checkout'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the widget for a single product item in the cart list.
  ///
  /// This widget displays the product's image, name, category, price, and
  /// provides controls to increase/decrease the quantity or remove the item
  /// from the cart, all by interacting with the [cartController].
  Widget _cartProduct(CartController cartController, int index) {
    return Container(
      height: 130,
      padding: const EdgeInsets.fromLTRB(8.0, 16, 16, 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
            child: productImageBuilder(
              cartController.cartContent[index].keys.first.picsUrls[0],
              height: 80,
              applyPadding: false,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  /// Product name.
                  cartController.cartContent[index].keys.first.name,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyRegular.copyWith(
                    fontSize: 16,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  /// Product category.
                  cartController.cartContent[index].keys.first.category,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.playfulTag.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.disabled(context),
                  ),
                ),

                const Spacer(),

                /// Quantity selector with "+" and "-" buttons.
                Container(
                  width: 90,
                  height: 25,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPalette.primary, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppPalette.primary.withValues(
                              alpha:
                                  Theme.brightnessOf(context) == Brightness.dark
                                  ? 0.2
                                  : 0.05,
                            ),
                            foregroundColor: AppPalette.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          iconSize: 11,
                          padding: EdgeInsets.zero,
                          icon: const Icon(FontAwesomeIcons.minus),
                          onPressed: () =>
                              cartController.decreaseProductQTE(index),
                        ),
                      ),
                      VerticalDivider(
                        color: AppPalette.primary,
                        width: 0.5,
                        thickness: 0.5,
                      ),

                      /// Minor spacing
                      const SizedBox(width: 4.0),

                      Expanded(
                        child: Text(
                          cartController.cartContent[index].values.first
                              .toString(),
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: AppPalette.primaryText(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      /// Minor spacing
                      const SizedBox(width: 4.0),
                      VerticalDivider(
                        color: AppPalette.primary,
                        width: 0.5,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppPalette.primary.withValues(
                              alpha:
                                  Theme.brightnessOf(context) == Brightness.dark
                                  ? 0.2
                                  : 0.05,
                            ),
                            foregroundColor: AppPalette.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          iconSize: 11,
                          icon: const Icon(FontAwesomeIcons.plus),
                          onPressed: () =>
                              cartController.increaseProductQTE(index),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              /// Displays the product price, handling promotional prices with a strikethrough.
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "\$",
                      style: AppTextStyles.ctaBold.copyWith(
                        fontSize:
                            cartController
                                    .cartContent[index]
                                    .keys
                                    .first
                                    .promoPrice ==
                                null
                            ? 15
                            : 9,
                        color:
                            cartController
                                    .cartContent[index]
                                    .keys
                                    .first
                                    .promoPrice ==
                                null
                            ? AppPalette.primary
                            : AppPalette.textOnSecondaryBg(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: cartController.cartContent[index].keys.first.price
                          .toStringAsFixed(2),
                      style: AppTextStyles.ctaBold.copyWith(
                        decoration:
                            cartController
                                    .cartContent[index]
                                    .keys
                                    .first
                                    .promoPrice ==
                                null
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                        fontSize:
                            cartController
                                    .cartContent[index]
                                    .keys
                                    .first
                                    .promoPrice ==
                                null
                            ? 17
                            : 12,
                        color: AppPalette.textOnSecondaryBg(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (cartController
                            .cartContent[index]
                            .keys
                            .first
                            .promoPrice !=
                        null)
                      TextSpan(
                        text: "\n\$",
                        style: AppTextStyles.ctaBold.copyWith(
                          fontSize: 15,
                          color: AppPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    TextSpan(
                      text: cartController
                          .cartContent[index]
                          .keys
                          .first
                          .promoPrice
                          ?.toStringAsFixed(2),
                      style: AppTextStyles.ctaBold.copyWith(
                        fontSize: 17,
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              /// The "remove from cart" button.
              AnimatedIconButton(
                iconData: FontAwesomeIcons.trashCan,
                iconSize: 16,
                foregroundColor: AppPalette.secondaryText(context),
                onClick: () {
                  cartController.removeProductFromCart(index);
                  if (cartController.cartContent.isEmpty) {
                    // Trigger the animation to hide the bottom sheet.
                    _animationController.forward();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the widget to display when the shopping cart is empty.
  ///
  /// This widget shows a playful illustration, a title, a descriptive message,
  // and a "SHOP NOW" button that navigates the user back to the previous screen
  // (presumably the main shopping page).
  Widget _emptyCartStateWidgetBuilder(Size screenSize) {
    return SizedBox(
      width: screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/illustrations/background_shape.svg',
                height: screenSize.height < 675 ? 300 : 325,
                colorFilter: ColorFilter.mode(
                  AppPalette.surfaces(context),
                  BlendMode.srcATop,
                ),
              ),
              FloatingAnimation(
                type: FloatingType.wave,
                duration: Duration(seconds: 9),
                floatStrength: 3,
                curve: Curves.linear,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/illustrations/background_shape.svg',
                      height: screenSize.height < 675 ? 225 : 250,
                      colorFilter: ColorFilter.mode(
                        AppPalette.primary.withValues(alpha: 0.5),
                        BlendMode.srcATop,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/illustrations/empty_cart.svg',
                      height: screenSize.height < 675 ? 175 : 200,
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// Illustration Spacing
          VerticalSpacing.lg(context),

          /// Texts
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.075),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Your cart is empty",
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppPalette.textOnSecondaryBg(context),
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: "\nLooks like you haven't made your choice yet.",
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.secondaryText(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              textAlign: TextAlign.center,
            ),
          ),

          /// CTA Spacing
          VerticalSpacing.md(context),
          AnimatedElevatedButton(
            size: Size(screenSize.width * .8, 45),
            text: 'SHOP NOW',
            onClick: Get.back,
          ),

          /// Bottom Spacing
          VerticalSpacing.xl(context),
        ],
      ),
    );
  }
}
