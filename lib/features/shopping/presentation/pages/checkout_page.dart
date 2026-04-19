import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/shopping/presentation/pages/order_placed_page.dart';

/// The checkout page where users finalize their order. 💳
///
/// This `StatefulWidget` serves as the final step in the shopping process.
/// It allows users to:
/// 1.  Review and confirm their shipping address.
/// 2.  Enter a promotional code.
/// 3.  Select a payment method from a list of options.
/// 4.  View a detailed cost breakdown (subtotal, fees, discounts).
/// 5.  Confirm and place the order.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

/// The state for the [CheckoutPage].
///
/// Manages the state for the promo code input and the selected payment method.
class _CheckoutPageState extends State<CheckoutPage> {
  // ===========================================================================
  // 🚀 State Variables & Controllers
  // ===========================================================================

  /// Controller for the promotional code text field.
  TextEditingController promoTextEditingController = TextEditingController();

  /// The identifier for the currently selected payment method.
  /// Defaults to 'credit_card'.
  String paymentMethod = 'credit_card';

  /// Updates the state of the selected [paymentMethod].
  void setPaymentMethod(String? newValue) {
    if (paymentMethod != newValue && newValue != null) {
      setState(() {
        paymentMethod = newValue;
      });
    }
  }

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================

  @override
  void dispose() {
    super.dispose();
    promoTextEditingController.dispose();
  }

  @override
  /// Builds the main UI for the checkout page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 4,
        automaticallyImplyLeading: true,
        title: Text(
          'Checkout',
          style: AppTextStyles.playfulTag.copyWith(
            color: AppPalette.primaryText(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Heading Spacing
            VerticalSpacing.md(context),

            /// Shipping Address Section
            _addressSection(context, screenSize),

            /// Section Spacing
            VerticalSpacing.xl(context),

            /// Promo Code Section
            _promoCodeSection(context, screenSize),

            /// Section Spacing
            VerticalSpacing.xl(context),

            /// Payment Method Section
            _paymentSection(context, screenSize),

            /// Bottom Spacing
            VerticalSpacing.lg(context),
          ],
        ),
      ),
      bottomNavigationBar: _bottomSheetWidgetBuilder(
        // TODO: Replace hardcoded values with dynamic data from a cart controller.
        screenSize,
        subTotal: 13.27,
        deliveryFee: 4.6,
        promoPercentage: 10,
      ),
    );
  }

  /// Builds the section that displays the user's shipping address.
  ///
  /// It shows the address, zip code, and phone number, with an "edit" button
  /// that navigates to the account details page.
  Widget _addressSection(BuildContext context, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Envío a',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.primaryText(context),
              fontSize: 14,
              //fontWeight: FontWeight.bold,
            ),
          ),

          /// Title Spacing
          VerticalSpacing.md(context),

          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0.0, 12, 12, 12),
            decoration: BoxDecoration(
              color: AppPalette.primary.withValues(alpha: .15),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: AppPalette.primary.withValues(alpha: .5),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/shipping_address.svg',
                  width: 60,
                ),

                /// Minor Spacing
                SizedBox(width: 8.0),

                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        /// address
                        TextSpan(
                          text: '138 Birch Street, El PasoTX, Texas.',
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.primaryText(context),
                          ),
                        ),

                        /// Zip code
                        TextSpan(
                          text: '\n Código code: ',
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 12,
                            color: AppPalette.secondaryText(context),
                          ),
                        ),
                        TextSpan(
                          text: '79915',
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.secondaryText(context),
                          ),
                        ),

                        /// Phone number
                        TextSpan(
                          text: '\n fono: ',
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 12,
                            color: AppPalette.secondaryText(context),
                          ),
                        ),
                        TextSpan(
                          text: DummyData.userProfileDetails['phone'],
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.secondaryText(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Minor Spacing
                SizedBox(width: 8.0),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: AnimatedIconButton(
                    iconData: FontAwesomeIcons.penToSquare,
                    size: Size(35, 35),
                    foregroundColor: AppPalette.textOnSecondaryBg(context),
                    iconSize: 16,
                    onClick: () => Get.toNamed('AccountDetails'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the section for entering a promotional code.
  ///
  /// It consists of a `TextField` with a decorative prefix icon and a suffix
  /// "Apply" button.
  Widget _promoCodeSection(BuildContext context, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
      child: SizedBox(
        height: 47.5,
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppPalette.secondary(context),
              selectionColor: AppPalette.secondary(
                context,
              ).withValues(alpha: .5),
              selectionHandleColor: AppPalette.secondary(context),
            ),
            inputDecorationTheme: Theme.of(context).inputDecorationTheme
                .copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: AppPalette.secondary(context),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      width: 1,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppPalette.disabled(context).withValues(alpha: .5),
                      width: 1,
                    ),
                  ),
                ),
          ),
          child: TextField(
            decoration: InputDecoration(
              fillColor: AppPalette.secondary(context).withValues(alpha: .25),
              filled: true,
              hintText: 'Ingrese código promo',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: SvgPicture.asset(
                  "assets/illustrations/discount_tag.svg",
                  height: 27.5,
                  colorFilter: ColorFilter.mode(
                    AppPalette.secondary(context).withValues(alpha: .75),
                    BlendMode.modulate,
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: 7.5,
                  horizontal: 5,
                ),
                child: AnimatedElevatedButton(
                  text: '',
                  size: Size(90, 30),
                  radius: BorderRadius.all(Radius.circular(7.5)),
                  backgroundcolor: AppPalette.secondary(context),
                  textStyle: AppTextStyles.buttonText.copyWith(fontSize: 13),
                  onClick: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.paw,
                        size: 13,
                        color: AppPalette.lBackground,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Aplicar',
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: 13,
                            color: AppPalette.lBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the section for selecting a payment method.
  ///
  /// It uses a custom `RadioGroup` and `RadioListTile` widgets to present
  /// options like Credit Card, PayPal, Google Pay, and Apple Pay. The selected
  /// method is managed by the `paymentMethod` state variable.
  Widget _paymentSection(BuildContext context, Size screenSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
          child: Text(
            'Método de Pago',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.primaryText(context),
              fontSize: 14,
            ),
          ),
        ),

        /// Title Spacing
        VerticalSpacing.md(context),

        RadioGroup<String>(
          groupValue: paymentMethod,
          onChanged: (value) => setPaymentMethod(value),
          child: Column(
            children: [
              /// Credit Card
              RadioListTile(
                value: 'credit_card',
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: AppPalette.secondary(
                          context,
                        ).withValues(alpha: .6),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/illustrations/credit_card.svg',
                        height: 30,
                      ),
                    ),
                    Text(
                      "tarjeta de Crédito",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppPalette.primaryText(context),
                      ),
                    ),
                  ],
                ),
              ),

              /// Fields Spacing
              VerticalSpacing.sm(context),

              /// Paypal
              RadioListTile(
                value: 'paypal',
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: AppPalette.softBlue.withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/250_Paypal_logo-512.png',
                        height: 25,
                        width: 25,
                        errorBuilder: (context, error, stackTrace) => FaIcon(
                          FontAwesomeIcons.paypal,
                          color: AppPalette.lTextOnSecondaryBg,
                          size: 22.5,
                        ),
                      ),
                    ),
                    Text(
                      "Paypal",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppPalette.primaryText(context),
                      ),
                    ),
                  ],
                ),
              ),

              /// Fields Spacing
              VerticalSpacing.sm(context),

              /// Google Pay
              RadioListTile(
                value: 'google',
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: AppPalette.surfaces(context),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://www.mastercard.com.au/content/dam/public/mastercardcom/au/en/consumers/icons/google-pay-logo_1280x531.png',
                        width: 32,
                        errorBuilder: (context, error, stackTrace) => FaIcon(
                          FontAwesomeIcons.googlePay,
                          color:
                              Theme.maybeBrightnessOf(context) ==
                                  Brightness.dark
                              ? AppPalette.lBackground
                              : AppPalette.lTextOnSecondaryBg,
                          size: 22.5,
                        ),
                      ),
                    ),
                    Text(
                      "Google Pay",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppPalette.primaryText(context),
                      ),
                    ),
                  ],
                ),
              ),

              /// Fields Spacing
              VerticalSpacing.sm(context),

              /// Apple Pay
              RadioListTile(
                value: 'apple',
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                dense: true,
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: AppPalette.surfaces(context),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://cdn4.iconfinder.com/data/icons/vector-brand-logos/40/Apple_Pay-512.png",
                        width: 32,
                        color:
                            Theme.maybeBrightnessOf(context) == Brightness.dark
                            ? AppPalette.lBackground
                            : null,

                        errorBuilder: (context, error, stackTrace) => FaIcon(
                          FontAwesomeIcons.applePay,
                          color:
                              Theme.maybeBrightnessOf(context) ==
                                  Brightness.dark
                              ? AppPalette.lBackground
                              : AppPalette.lTextOnSecondaryBg,
                          size: 22.5,
                        ),
                      ),
                    ),
                    Text(
                      "Apple Pay",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppPalette.primaryText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Credit Card
        /*   Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: AppPalette.secondary(context).withValues(alpha: .6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/illustrations/credit_card.svg',
                height: 30,
              ),
            ),
            Text(
              "Credit Card",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppPalette.primaryText(context),
              ),
            ),
            const Spacer(),
            Radio(
              value: 'credit_card',
              groupValue: paymentMethod,
              
              
              onChanged: (value) => setPaymentMethod(value),
            ),
          ],
        ),
 /// Fields Spacing
        VerticalSpacing.sm(context),

        /// Paypal
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: AppPalette.softBlue.withValues(alpha: .5),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.network(
                'https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/250_Paypal_logo-512.png',
                height: 25,
                width: 25,
                errorBuilder: (context, error, stackTrace) => FaIcon(
                  FontAwesomeIcons.paypal,
                  color: AppPalette.lTextOnSecondaryBg,
                  size: 22.5,
                ),
              ),
            ),
            Text(
              "Paypal",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppPalette.primaryText(context),
              ),
            ),
            const Spacer(),
            Radio(
              value: 'paypal',
              groupValue: paymentMethod,
              onChanged: (value) => setPaymentMethod(value),
            ),
          ],
        ),

        /// Fields Spacing
        VerticalSpacing.sm(context),

        /// Google Pay
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: AppPalette.surfaces(context),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.network(
                'https://www.mastercard.com.au/content/dam/public/mastercardcom/au/en/consumers/icons/google-pay-logo_1280x531.png',
                width: 32,
                errorBuilder: (context, error, stackTrace) => FaIcon(
                  FontAwesomeIcons.googlePay,
                  color: Theme.maybeBrightnessOf(context) == Brightness.dark
                      ? AppPalette.lBackground
                      : AppPalette.lTextOnSecondaryBg,
                  size: 22.5,
                ),
              ),
            ),
            Text(
              "Google Pay",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppPalette.primaryText(context),
              ),
            ),
            const Spacer(),
            Radio(
              value: 'google',
              groupValue: paymentMethod,
              onChanged: (value) => setPaymentMethod(value),
            ),
          ],
        ),

        /// Fields Spacing
        VerticalSpacing.sm(context),

        /// Apple Pay
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: AppPalette.surfaces(context),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.network(
                "https://cdn4.iconfinder.com/data/icons/vector-brand-logos/40/Apple_Pay-512.png",
                width: 32,
                color: Theme.maybeBrightnessOf(context) == Brightness.dark
                    ? AppPalette.lBackground
                    : null,

                errorBuilder: (context, error, stackTrace) => FaIcon(
                  FontAwesomeIcons.applePay,
                  color: Theme.maybeBrightnessOf(context) == Brightness.dark
                      ? AppPalette.lBackground
                      : AppPalette.lTextOnSecondaryBg,
                  size: 22.5,
                ),
              ),
            ),
            Text(
              "Apple Pay",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: AppPalette.primaryText(context),
              ),
            ),
            const Spacer(),
            Radio(
              value: 'apple',
              groupValue: paymentMethod,
              onChanged: (value) => setPaymentMethod(value),
            ),
          ],
        ),
      
      */
      ],
    );
  }

  /// Builds the bottom summary sheet for the checkout page.
  ///
  /// This widget displays a breakdown of the order total, including subtotal,
  /// delivery fees, and discounts. It also contains the final "CONFIRM" button
  /// to place the order, which navigates to the [OrderPlacedPage] on success.
  Widget _bottomSheetWidgetBuilder(
    Size screenSize, {
    required double subTotal,
    required double deliveryFee,
    required double promoPercentage,
  }) {
    double total = subTotal + deliveryFee - (subTotal * promoPercentage / 100);
    return SafeArea(
      child: Container(
        height: 170,
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
              color: AppPalette.primaryText(context).withValues(alpha: 0.05),
              offset: Offset(0, -3),
              blurRadius: 3,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Subtotal
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
              ),
              child: Row(
                children: [
                  Text(
                    'Subtotal',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${subTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.ctaBold.copyWith(
                      fontSize: 12,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            /// Minor Spacing
            SizedBox(height: VerticalSpacing.sm(context).spacing * 0.4),

            /// Delivery Fee
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
              ),
              child: Row(
                children: [
                  Text(
                    'Delivery Fee',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${deliveryFee.toStringAsFixed(2)}',
                    style: AppTextStyles.ctaBold.copyWith(
                      fontSize: 12,
                      color: AppPalette.textOnSecondaryBg(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            /// Minor Spacing
            SizedBox(height: VerticalSpacing.sm(context).spacing * 0.4),

            /// Discount
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
              ),
              child: Row(
                children: [
                  Text(
                    'Discount',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppPalette.primaryText(context),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '-${promoPercentage.toStringAsFixed(2)}%',
                          style: AppTextStyles.ctaBold.copyWith(
                            fontSize: 10,
                            color: AppPalette.disabled(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        TextSpan(
                          text: ' \$${subTotal * promoPercentage / 100}',
                          style: AppTextStyles.ctaBold.copyWith(
                            fontSize: 12,
                            color: AppPalette.textOnSecondaryBg(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Test Spacing
            VerticalSpacing.md(context),

            ///Total
            Row(
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.primaryText(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppTextStyles.ctaBold.copyWith(
                    fontSize: 16,
                    color: AppPalette.primaryText(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            AnimatedElevatedButton(
              text: 'CONFIRM',
              textStyle: AppTextStyles.buttonText.copyWith(
                color: AppPalette.primaryText(context),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              size: Size(screenSize.width * 0.8, 40),
              radius: BorderRadius.all(Radius.circular(15)),
              onClick: () => Get.to(
                () => OrderPlacedPage(),
                transition: Transition.rightToLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
