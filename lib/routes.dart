import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:moovetrax/authmiddleware.dart';
import 'package:moovetrax/installer_auth_middleware.dart';
import 'package:moovetrax/view/account/screens/account_screen.dart';
import 'package:moovetrax/view/account/screens/account_subscription.dart';
import 'package:moovetrax/view/account/screens/device_subscription.dart';
import 'package:moovetrax/view/auth/screens/installer_login_screen.dart';
import 'package:moovetrax/view/auth/screens/device_signup_screen.dart';
import 'package:moovetrax/view/auth/screens/installer_signup_screen.dart';
import 'package:moovetrax/view/auth/screens/login_screen.dart';
import 'package:moovetrax/view/auth/screens/reset_password_screen.dart';
import 'package:moovetrax/view/commands/screens/commands_screen.dart';
import 'package:moovetrax/view/daily_mileage/screens/daily_mileage_screen.dart';
import 'package:moovetrax/view/device/screens/device_edit_screen.dart';
import 'package:moovetrax/view/device/screens/device_manage_screen.dart';
import 'package:moovetrax/view/device/screens/device_payment.dart';
import 'package:moovetrax/view/device/screens/installer_payment.dart';
import 'package:moovetrax/view/events/screens/events_screen.dart';
import 'package:moovetrax/view/home/home_screen.dart';
import 'package:moovetrax/view/installer/installer_home_screen.dart';
import 'package:moovetrax/view/maintain/screens/maintain_screen.dart';
import 'package:moovetrax/view/notify/screens/notify_setting_screen.dart';
import 'package:moovetrax/view/pl/screens/pl_screen.dart';
import 'package:moovetrax/view/share/screens/share_screen.dart';
import 'package:moovetrax/view/shared_links/screens/shared_links_screen.dart';
import 'package:moovetrax/view/toll/screens/toll_search_screen.dart';
import 'package:moovetrax/view/turo_trip/screens/turo_trip_screen.dart';
import 'package:moovetrax/view/video_pic/video_pic_screen.dart';

final routes = [
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
    transitionDuration: Duration.zero,
  ),
  GetPage(
    name: '/installer-signup',
    page: () => const InstallerSignUpScreen(),
    transitionDuration: Duration.zero,
  ),
  GetPage(
    name: '/reset-password',
    page: () => const ResetPasswordScreen(),
    transitionDuration: Duration.zero,
  ),
  GetPage(
    name: '/installer-login',
    page: () => const InstallerLoginScreen(),
    transitionDuration: Duration.zero,
  ),
  GetPage(
    name: '/device-signup',
    page: () => const DeviceSignupScreen(),
    transitionDuration: Duration.zero,
  ),
  GetPage(
    name: '/home',
    page: () => const HomeScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/installer-home',
    page: () => const InstallerHomeScreen(),
    transitionDuration: Duration.zero,
    middlewares: [InstallerAuthMiddleWare()],
  ),
  GetPage(
    name: '/reports/daily-mileage',
    page: () => const DailyMileAgeScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/notify-setting',
    page: () => const NotifySettingScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/share',
    page: () => const ShareScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/reports/commands',
    page: () => const CommandsScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/reports/events',
    page: () => const EventsScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/settings/account',
    page: () => const AccountScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/settings/turo-trips',
    page: () => const TuroTripScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/settings/shared-links',
    page: () => const SharedLinksScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/device-manage',
    page: () => const DeviceManageScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/device-edit',
    page: () => const DeviceEditScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/toll-search',
    page: () => const TollSearchScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/maintenaunce',
    page: () => const MaintainScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/device-subscription',
    page: () => const DevicePaypalSubscriptionScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/device-payment',
    page: () => const DevicePaymentScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/installer-payment',
    page: () => const InstallerPaymentScreen(),
    transitionDuration: Duration.zero,
    middlewares: [InstallerAuthMiddleWare()],
  ),
  GetPage(
    name: '/account-subscription',
    page: () => const AccountPaypalSubscriptionScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/PL',
    page: () => const PLScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/video-to-image',
    page: () => const VideoToImageScreen(),
    transitionDuration: Duration.zero,
    middlewares: [AuthMiddleware()],
  ),
];
