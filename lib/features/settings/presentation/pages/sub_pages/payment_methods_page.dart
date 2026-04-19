import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:get/get.dart';


/// A page for managing the user's saved payment methods. 💳
///
/// This [StatelessWidget] displays a list of currently linked payment options,
/// such as credit cards and PayPal accounts. It allows users to view their
/// methods, identify the default option, and initiate the process of adding
/// a new one.
///
class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  /// Builds the UI for the Payment Methods page.
  /// It includes a standard `AppBar`, a `SingleChildScrollView` containing the
  /// list of payment tiles, and a `BottomAppBar` with a primary action button.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'payment_methods_title'.tr,
          style: AppTextStyles.headingMedium.copyWith(
            color: AppPalette.textOnSecondaryBg(context),
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top spacing for visual balance.
              VerticalSpacing.md(context),

              Text(
                'payment_methods_choose'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppPalette.primaryText(context),
                  fontSize: 17,
                ),
                textAlign: TextAlign.start,
              ),

              VerticalSpacing.xl(context),
              _ccTile(context, true, 'XXXX XXXX XXXX 1234', '09/29', true),

              /// Space between Payment Methods
              VerticalSpacing.lg(context),
              _ccTile(context, false, 'XXXX XXXX XXXX 4321', '07/28', false),

              /// Space between Payment Methods
              VerticalSpacing.lg(context),
              _ppTile(context, DummyData.userProfileDetails['email'], false),

              /// Space between Payment Methods
              VerticalSpacing.lg(context),
              _addNewPMTile(context),
            ],
          ),
        ),
      ),

      /// The bottom navigation bar containing the primary call-to-action button.
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppPalette.background(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                offset: const Offset(0, -1),
                blurRadius: 1,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AnimatedElevatedButton(
            size: Size(screenSize.width * .8, 40),
            text: 'payment_methods_select'.tr,
            onClick: () {},
          ),
        ),
      ),
    );
  }

  /// A private helper method to build a consistent [ListTile] for a credit card.
  ///
  /// This widget factory displays the card type (Visa or Mastercard), a masked
  /// card number, and the expiration date. It also visually highlights the tile
  /// with a border and a checkmark if it is the default payment method.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `isVisa`: A boolean to determine whether to show the Visa or Mastercard icon.
  ///   - `number`: The masked credit card number to display.
  ///   - `expDate`: The card's expiration date.
  ///   - `isDefault`: A boolean that controls the styling to indicate if this is the default payment method.
  Widget _ccTile(
    BuildContext context,
    bool isVisa,
    String number,
    String expDate,
    bool isDefault,
  ) {
    return ListTile(
      onTap: () {},
      splashColor: AppPalette.primary.withValues(alpha: .1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        side: BorderSide(
          color: isDefault
              ? AppPalette.primary
              : AppPalette.disabled(context).withValues(alpha: .5),
          width: isDefault ? 2 : 1,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      leading: SizedBox(
        width: 35,
        child: Icon(
          isVisa ? FontAwesomeIcons.ccVisa : FontAwesomeIcons.ccMastercard,
          color: AppPalette.textOnSecondaryBg(context),
          size: 30,
        ),
      ),
      title: Text(
        number,
        style: AppTextStyles.playfulTag.copyWith(
          fontSize: 16,
          color: AppPalette.primaryText(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          children: [
            Text(
              'payment_methods_expires'.tr,
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 10,
                color: AppPalette.primaryText(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4.0),
            Text(
              expDate,
              style: AppTextStyles.bodyRegular.copyWith(
                fontSize: 12,
                color: AppPalette.primaryText(context),
                fontWeight: FontWeight.w500,
              ),
            ),

            /// Spacing
            if (isDefault) const Spacer(),
            if (isDefault)
              Text(
                'payment_methods_default'.tr,
                style: AppTextStyles.playfulTag.copyWith(
                  fontSize: 11,
                  color: AppPalette.primaryText(context),
                  fontWeight: FontWeight.w900,
                ),
              ),

            /// Spacing
            if (isDefault) const SizedBox(width: 16),
          ],
        ),
      ),

      trailing: isDefault
          ? Icon(
              FontAwesomeIcons.circleCheck,
              size: 25,
              color: AppPalette.primary,
            )
          : null,
    );
  }

  /// A private helper method to build a `ListTile` for a PayPal account.
  ///
  /// This widget factory displays the PayPal icon and the associated user email.
  /// It also applies special styling, including a border and a checkmark, if
  /// it is the default payment method.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `email`: The user's PayPal email address to display.
  ///   - `isDefault`: A boolean to control the styling for the default method.
  Widget _ppTile(BuildContext context, String email, bool isDefault) {
    return ListTile(
      onTap: () {},
      splashColor: AppPalette.primary.withValues(alpha: .1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        side: BorderSide(
          color: isDefault ? AppPalette.primary : AppPalette.disabled(context),
          width: isDefault ? 2 : 1,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),

      leading: SizedBox(
        width: 35,
        child: Icon(
          FontAwesomeIcons.paypal,
          color: AppPalette.textOnSecondaryBg(context),
          size: 35,
        ),
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          email,
          style: AppTextStyles.playfulTag.copyWith(
            fontSize: 16,
            color: AppPalette.primaryText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      trailing: isDefault
          ? Icon(
              FontAwesomeIcons.circleCheck,
              size: 25,
              color: AppPalette.primary,
            )
          : null,
    );
  }

  /// A private helper method that builds a `ListTile` to act as an 'Add New' button.
  ///
  /// This tile provides a clear, tappable entry point for users to add a new
  /// credit card, PayPal, or other payment method to their account.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  Widget _addNewPMTile(BuildContext context) {
    return ListTile(
      onTap: () {},
      splashColor: AppPalette.primary.withValues(alpha: .1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        side: BorderSide(color: AppPalette.disabled(context), width: .5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),

      leading: SizedBox(
        width: 35,
        child: Icon(
          Icons.payment_rounded,
          color: AppPalette.textOnSecondaryBg(context).withValues(alpha: .75),
          size: 30,
        ),
      ),
      title: Text(
        'payment_methods_add'.tr,
        style: AppTextStyles.bodyRegular.copyWith(
          color: AppPalette.textOnSecondaryBg(context).withValues(alpha: .75),
          fontSize: 14,
        ),
      ),
    );
  }
}
