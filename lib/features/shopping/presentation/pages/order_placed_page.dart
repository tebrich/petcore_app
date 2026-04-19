import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// A confirmation page displayed after a user successfully places an order. 🎉
///
/// This `StatelessWidget` provides visual feedback to the user that their
/// purchase was successful. It features a large, playful illustration, a clear
/// "Order Placed" title, and a confirmation message.
///
/// The layout is responsive and adapts to different screen heights using a
/// `LayoutBuilder`. A "GO HOME" button in the `BottomAppBar` allows the user
/// to navigate back to the main application screen, closing the checkout-related
/// pages in the navigation stack.
class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  /// Builds the main UI for the order confirmation page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          /// The main column containing all the page elements.
          return SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Heading Spacer
                VerticalSpacing.lg(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),

                  /// The main title of the page.
                  child: Text(
                    "Orden Realizada",
                    style: AppTextStyles.headingLarge.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: constraints.maxHeight > 580 ? 35 : 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                /// Space after Title
                VerticalSpacing.lg(context),

                /// A stack of widgets creating a layered, animated illustration.
                Stack(
                  alignment: Alignment.center,
                  children: [
                    /// The background shape for the illustration.
                    SvgPicture.asset(
                      'assets/illustrations/background_shape.svg',
                      height: constraints.maxHeight <= 580
                          ? constraints.maxHeight * 0.65
                          : 350,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).brightness == Brightness.dark
                            ? AppPalette.primary.withValues(alpha: 1)
                            : AppPalette.lSurfaces.withValues(alpha: 0.75),
                        BlendMode.srcATop,
                      ),
                    ),

                    /// A floating animation that adds a subtle wave-like motion to the illustration.
                    FloatingAnimation(
                      type: FloatingType.wave,
                      duration: Duration(seconds: 8),
                      floatStrength: 2.5,
                      curve: Curves.linear,
                      child: Stack(
                        /// The inner stack containing the colored shape and the main SVG.
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            'assets/illustrations/background_shape.svg',
                            height: constraints.maxHeight <= 580
                                ? constraints.maxHeight * 0.5
                                : 275,
                            colorFilter: ColorFilter.mode(
                              AppPalette.primary.withValues(
                                alpha:
                                    Theme.brightnessOf(context) ==
                                        Brightness.dark
                                    ? 0.8
                                    : 0.5,
                              ),
                              BlendMode.srcATop,
                            ),
                          ),

                          /// The primary illustration indicating a confirmed order.
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SvgPicture.asset(
                              'assets/illustrations/order_confirmed.svg',
                              height: constraints.maxHeight <= 580
                                  ? constraints.maxHeight * .45
                                  : 250,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Space after illustration
                VerticalSpacing.xl(context),

                /// The confirmation message text.
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
                  child: Text(
                    "Su compra se ha realizado con éxito",
                    style: AppTextStyles.bodyRegular.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppPalette.secondaryText(context),
                      fontSize: constraints.maxHeight <= 580 ? 16 : 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),

      /// The bottom navigation bar containing the primary action button.
      ///
      /// The `AnimatedElevatedButton` navigates the user back to the home screen.
      /// `Get.close(3)` is used to pop the last three pages off the stack (e.g., OrderPlacedPage, CheckoutPage, ShoppingCartPage).
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: screenSize.width * 0.1,
        ),
        child: AnimatedElevatedButton(
          text: 'Inicio',
          textStyle: AppTextStyles.buttonText.copyWith(
            color: AppPalette.primaryText(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          size: Size(screenSize.width * 0.8, 40),
          radius: BorderRadius.all(Radius.circular(15)),
          onClick: () => Get.close(3),
        ),
      ),
    );
  }
}
