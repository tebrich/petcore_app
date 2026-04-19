import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_elevated_button.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_text_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/features/onboarding/presentation/widgets/first_onboarding_page.dart';
import 'package:peticare/features/onboarding/presentation/widgets/fourth_onboarding_page.dart';
import 'package:peticare/features/onboarding/presentation/widgets/second_onboarding_page.dart';
import 'package:peticare/features/onboarding/presentation/widgets/third_onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';


/// A stateful widget that displays the onboarding screen with a `PageView`.
///
/// This page guides the user through a series of onboarding screens, each
/// presenting a key feature of the application. It uses a `PageView` to
/// enable swiping between the screens and a `SmoothPageIndicator` to show the
/// current page.
///
/// The onboarding screens are:
/// 1.  `firstOnBoardingPage`:  Introduces pet health tracking.
/// 2.  `secondOnBoardingPage`: Highlights expert grooming services.
/// 3.  `thirdOnBoardingPage`:  Showcases expert vet care and hygiene monitoring.
/// 4.  `fourthOnBoardingPage`: Emphasizes the smart alerts feature.
///
/// The bottom navigation bar includes:
/// - A `SmoothPageIndicator` to visualize the current page.
/// - A "Skip" button to navigate directly to the sign-in page, except on the
///   last page.
/// - A "Get Started" button on the last page, or a navigation icon on other
///   pages, to proceed to the next page or the sign-in screen.
///
/// The `isOnLastPage` boolean state variable tracks whether the user is
/// currently viewing the last onboarding screen to update UI.
///
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  /// Variables
  final PageController _pageController = PageController();
  late bool isOnLastPage;

  @override
  void initState() {
    isOnLastPage = false;
    _pageController.addListener(() {
      if (_pageController.page != null) {
        if (_pageController.page == 3.0) {
          if (!isOnLastPage) {
            setState(() {
              isOnLastPage = true;
            });
          }
        } else {
          if (isOnLastPage) {
            setState(() {
              isOnLastPage = false;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            firstOnBoardingPage(context, screenSize),
            secondOnBoardingPage(context, screenSize),
            thirdOnBoardingPage(context, screenSize),
            fourthOnBoardingPage(context, screenSize),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppPalette.background(context),
        child: Column(
          children: [
            SmoothPageIndicator(
              controller: _pageController,
              count: 4,
              effect: WormEffect(
                activeDotColor: AppPalette.primary,
                dotColor: AppPalette.secondaryText(
                  context,
                ).withValues(alpha: 0.3),
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextButton(
                  text: 'onboarding_skip'.tr,
                  onClick: isOnLastPage
                      ? null
                      : () {
                          Get.toNamed('/Signin');
                        },
                ),
                AnimatedElevatedButton(
                  text: isOnLastPage ? 'onboarding_get_started'.tr : '',
                  onClick: () {
                    if (isOnLastPage) {
                      Get.toNamed('/Signin');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      );
                    }
                  },
                  size: Size(isOnLastPage ? 110 : 35, 35),
                  radius: BorderRadius.all(Radius.circular(10)),
                  textStyle: isOnLastPage
                      ? AppTextStyles.buttonText.copyWith(fontSize: 14)
                      : null,
                  child: isOnLastPage
                      ? null
                      : Center(child: FaIcon(FontAwesomeIcons.chevronRight)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
