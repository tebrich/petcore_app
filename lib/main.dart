import 'package:peticare/core/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:peticare/core/commn/presentation/controllers/global_controller.dart';
import 'package:peticare/core/commn/presentation/controllers/theme_controller.dart';
import 'package:peticare/core/commn/presentation/pages/home_page.dart';
import 'package:peticare/core/theme/app_theme.dart';

import 'package:peticare/features/authentication/presentation/pages/calendar_reminders_setting_page.dart';
import 'package:peticare/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:peticare/features/authentication/presentation/pages/reminders_setting_page.dart';
import 'package:peticare/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:peticare/features/authentication/presentation/pages/sign_up_page.dart';

import 'package:peticare/features/groom_appointments/presentation/pages/add_new_groom_appoitnment_page.dart';
import 'package:peticare/features/notifications/pages/notifications_page.dart';
import 'package:peticare/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:peticare/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:peticare/features/post_signup/presentation/pages/post_signup_welcome_page.dart';

import 'package:peticare/features/settings/presentation/pages/sub_pages/account_details_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/appearance_seetings_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/help_support_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/language_settings_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/login_history_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/payment_methods_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/privacy_security_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/trusted_devices_page.dart';
import 'package:peticare/features/settings/presentation/pages/sub_pages/two_factor_authentication_page.dart';

import 'package:peticare/features/shopping/presentation/pages/checkout_page.dart';
import 'package:peticare/features/shopping/presentation/pages/product_search_page.dart';
import 'package:peticare/features/shopping/presentation/pages/shopping_cart_page.dart';
import 'package:peticare/features/vet_appointments/presentation/pages/add_new_vet_appoitnment_page.dart';

import 'package:peticare/services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:peticare/features/post_signup/presentation/controllers/post_signup_page_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:peticare/features/notifications/controllers/notifications_controller.dart';
import 'package:peticare/features/vet/presentation/pages/vet_appointments_page.dart';
import 'package:peticare/features/vet_appointments/presentation/pages/review_page_wrapper.dart';

// 👇 importar la página de citas grooming para vet
import 'package:peticare/features/vet/presentation/pages/groom_vet_appointments_page.dart';
import 'package:peticare/features/vet/presentation/pages/vet_panel_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put(PostSignupPageController());
  Get.put(NotificationsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _initialRoute() async {
    print("🚨 INITIAL ROUTE RUNNING");

    final box = GetStorage();

    final loggedIn = await AuthService.hasValidSession();

    final user = box.read("user");

    print("USER >>> $user");
    print("LOGGED IN >>> $loggedIn");

    if (!loggedIn) {
      print("➡️ GO TO /");
      return '/';
    }

    if (user == null) {
      print("➡️ GO TO /Signin");
      return '/Signin';
    }

    if (user["role"] == "vet") {
      print("➡️ GO TO /VetPanel");
      return '/VetPanel';
    }

    print("➡️ GO TO /HomePage");
    return '/HomePage';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) {
        return FutureBuilder<String>(
          future: _initialRoute(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            return GetMaterialApp(
              title: 'Petcore',
              debugShowCheckedModeBanner: false,

              translations: AppTranslations(),
              locale: const Locale('es', 'ES'),
              fallbackLocale: const Locale('en', 'US'),

              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              supportedLocales: const [
                Locale('es', 'ES'),
                Locale('en', 'US'),
              ],

              theme: AppTheme.lightTheme(themeController.primaryColor),
              darkTheme: AppTheme.darkTheme(themeController.primaryColor),
              themeMode: Get.find<ThemeController>().themeMode,

              initialRoute: snapshot.data,

              getPages: [
                GetPage(name: '/', page: () => WelcomePage()),

                GetPage(
                  name: '/onBoarding',
                  page: () => OnboardingPage(),
                  transition: Transition.rightToLeftWithFade,
                ),

                GetPage(
                  name: '/Signup',
                  page: () => SignUpPage(),
                  transition: Transition.downToUp,
                ),

                GetPage(
                  name: '/Signin',
                  page: () => SignInPage(),
                  transition: Transition.circularReveal,
                ),

                GetPage(
                  name: '/ForgotPassword',
                  page: () => ForgotPasswordPage(),
                  transition: Transition.rightToLeftWithFade,
                ),

                GetPage(
                  name: '/PostSignup',
                  page: () => PostSignupWelcomePage(isPostSigning: true),
                ),

                GetPage(
                  name: '/HomePage',
                  page: () => HomePage(),
                  binding: GlobalControllerBinding(),
                ),

                GetPage(
                  name: '/VetAppointments',
                  page: () => VetAppointmentsPage(),
                ),

                // 👇 nueva ruta para citas grooming del vet
                GetPage(
                  name: '/GroomVetAppointments',
                  page: () => const GroomVetAppointmentsPage(),
                ),

                GetPage(
                  name: '/NewVetAppointment',
                  page: () => AddNewVetAppoitnmentPage(),
                ),

                GetPage(
                  name: '/NewGroomAppointment',
                  page: () => AddNewGroomAppoitnmentPage(),
                ),

                GetPage(
                  name: '/ProductSearch',
                  page: () => ProductSearchPage(),
                ),

                GetPage(
                  name: '/ShoppingCart',
                  page: () => ShoppingCartPage(),
                ),

                GetPage(
                  name: '/Checkout',
                  page: () => CheckoutPage(),
                ),

                GetPage(
                  name: '/Notifications',
                  page: () => NotificationsPage(),
                ),

                GetPage(
                    name: '/AccountDetails',
                    page: () => AccountDetailsPage()),
                GetPage(
                    name: '/PaymentMethods',
                    page: () => PaymentMethodsPage()),
                GetPage(
                    name: '/TwoFactorAuthentication',
                    page: () => TwoFactorAuthenticationPage()),
                GetPage(
                    name: '/LoginHistory',
                    page: () => LoginHistoryPage()),
                GetPage(
                    name: '/TrustedDevices',
                    page: () => TrustedDevicesPage()),
                GetPage(
                    name: '/RemindersSetting',
                    page: () => RemindersSettingPage()),
                GetPage(
                    name: '/CalendarRemindersSetting',
                    page: () => CalendarRemindersSettingPage()),
                GetPage(
                    name: '/AppearanceSeetings',
                    page: () => AppearanceSeetingsPage()),
                GetPage(
                    name: '/LanguageSettings',
                    page: () => LanguageSettingsPage()),
                GetPage(
                    name: '/PrivacySecurity',
                    page: () => PrivacySecurityPage()),
                GetPage(
                    name: '/HelpSupport', page: () => HelpSupportPage()),
                GetPage(
                  name: "/vet-review",
                  page: () => const ReviewPageWrapper(),
                ),

                GetPage(
                  name: '/VetPanel',
                  page: () => const VetPanelPage(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
