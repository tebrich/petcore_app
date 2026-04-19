import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:get/get.dart';


/// A page that displays a list of devices the user has marked as trusted. 📱
///
/// This [StatelessWidget] provides users with a clear overview of all devices
/// that have been granted trusted status, allowing them to bypass certain
/// security checks like 2FA on subsequent logins.
///
/// The page features a list of these devices, showing their name, location, and
/// the date they were last used. Each device entry includes an action button
/// to "revoke" its trusted status, giving the user full control over their
/// account security.
class TrustedDevicesPage extends StatelessWidget {
  const TrustedDevicesPage({super.key});

  @override
  /// Builds the UI for the Trusted Devices page.
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'trusted_devices_title'.tr,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppPalette.textOnSecondaryBg(context),
              fontSize: 22,
            ),
          ),
        ),
        actions: [SizedBox(width: 24.0)],
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Decorative background illustration, subtly placed for visual texture.
            Positioned(
              top: -5,
              left: -50,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: .04,
                  child: SvgPicture.asset(
                    'assets/illustrations/trusted_devices.svg',
                    height: 300,
                  ),
                ),
              ),
            ),

            /// Another decorative background illustration, creating a layered effect.
            Positioned(
              top: 250,
              right: -75,
              child: Transform.rotate(
                angle: -0.3,
                child: Opacity(
                  opacity: .1,
                  child: SvgPicture.asset(
                    'assets/illustrations/privacy_security.svg',
                    height: 300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top spacing for visual balance.
                  VerticalSpacing.md(context),

                  /// A descriptive subtitle explaining the page's purpose.
                  Text(
                    'trusted_devices_description'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppPalette.disabled(context),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  VerticalSpacing.xl(context),

                  /// Body
                  _bodyWidgetBuilder(context, screenSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method that constructs the primary content of the page.
  ///
  /// This widget factory combines the sorting menu and the `ListView` of
  /// trusted devices into a single column.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  Widget _bodyWidgetBuilder(BuildContext context, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /// Menu
        _sortingMenuWidgetBuilder(context),
        VerticalSpacing.sm(context),

        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,

          /// The itemCount is hardcoded to 3 to show only 'Connected' devices
          /// from the dummy data for demonstration purposes.
          itemCount: 3,
          itemBuilder: (context, index) => _loginActivityWidgetBuilder(
            context,
            screenSize,
            DummyData.loginHistory[index]["id"],
            DummyData.loginHistory[index]["device"],
            DummyData.loginHistory[index]["location"],
            DummyData.loginHistory[index]["timestamp"],
            DummyData.loginHistory[index]["status"],
          ),
        ),
      ],
    );
  }

  /// A helper method to build a consistent tile for each trusted device item.
  ///
  /// This widget factory creates a styled [Container] that displays details
  /// for a single trusted device. It includes an icon, device name, location,
  /// and the last login timestamp. It also features a "revoke" button to
  /// remove the device's trusted status.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  ///   - `screenSize`: The dimensions of the screen.
  ///   - `id`: A unique identifier for the list item, used for the widget's [Key].
  ///   - `deviceName`: The name of the device.
  ///   - `address`: The geographical location of the last login.
  ///   - `dateTime`: The timestamp of the last login event.
  ///   - `status`: The current status of the session (not visually used here but passed for consistency).
  Widget _loginActivityWidgetBuilder(
    BuildContext context,
    Size screenSize,
    id,
    String deviceName,
    String address,
    DateTime dateTime,
    String status,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: VerticalSpacing.lg(context).spacing),
      decoration: BoxDecoration(
        color: AppPalette.background(context),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        border: Border.all(color: AppPalette.primary.withValues(alpha: .5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      child: Container(
        key: Key(id),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        decoration: BoxDecoration(
          color: AppPalette.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/illustrations/trusted_devices.svg',
              height: 45,
            ),

            /// Spacing
            const SizedBox(width: 8.0),

            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$deviceName\n',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppPalette.textOnSecondaryBg(context),
                        fontSize: 16,
                      ),
                    ),
                    WidgetSpan(
                      child: SvgPicture.asset(
                        'assets/illustrations/location_pin.svg',
                        height: 15,
                      ),
                    ),
                    TextSpan(
                      text: "$address\n",
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                    WidgetSpan(
                      alignment: ui.PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.0, right: 2.0),
                        child: SvgPicture.asset(
                          'assets/illustrations/clock.svg',
                          height: 13,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: DateFormat("yyyy-MM-dd • HH:mm").format(dateTime),
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppPalette.secondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Spacing
            const SizedBox(width: 24.0),
            AnimatedIconButton(
              iconData: FontAwesomeIcons.trashCan,
              foregroundColor: AppPalette.danger(
                context,
              ).withValues(alpha: .75),
              iconSize: 20,
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// A helper method that builds the sorting menu UI.
  ///
  /// This widget contains a text label and a [DropdownButton] that allows users
  /// to select a sorting criterion. The functionality is currently a placeholder.
  ///
  /// [Args]:
  ///   - `context`: The build context.
  Widget _sortingMenuWidgetBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'trusted_devices_order_by'.tr,
          style: AppTextStyles.playfulTag.copyWith(
            color: AppPalette.disabled(context),
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: 30,
          child: DropdownButton(
            value: "Name",
            style: AppTextStyles.buttonText.copyWith(
              color: AppPalette.disabled(context),
              fontSize: 12,
            ),
            iconSize: 20,
            iconEnabledColor: AppPalette.disabled(context),
            elevation: 2,
            underline: const SizedBox(),
            padding: EdgeInsets.zero,
            dropdownColor: AppPalette.surfaces(context),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            items: [
              DropdownMenuItem(value: "Name", child: Text('trusted_devices_sort_name'.tr)),
              DropdownMenuItem(value: "Date", child: Text('trusted_devices_sort_name'.tr)),
              DropdownMenuItem(value: "Location", child: Text('trusted_devices_sort_name'.tr)),
            ],
            onChanged: (newValue) {},
          ),
        ),
      ],
    );
  }
}
