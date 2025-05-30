import 'package:flutter/material.dart';
import 'package:frontend_for_admins/pages/ai_assistant_page.dart';
import 'package:frontend_for_admins/pages/details_page.dart';
import 'package:frontend_for_admins/pages/guest_record_page.dart';
import 'package:frontend_for_admins/pages/home_page.dart';
import 'package:frontend_for_admins/pages/login_page.dart';
import 'package:frontend_for_admins/pages/qr_code_scanner_page.dart';
import 'package:frontend_for_admins/pages/register_page.dart';
import 'package:frontend_for_admins/pages/reset_password_page.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.homePage:
        return pageRoute(HomePage(), settings: settings);
      case RoutePath.loginPage:
        return pageRoute(LoginPage(), settings: settings);
      case RoutePath.resetPasswordPage:
        return pageRoute(ResetPasswordPage(), settings: settings);
      case RoutePath.qrCodeScannerPage:
        return pageRoute(QrCodeScannerPage(), settings: settings);
      case RoutePath.detailsPage:
        return pageRoute(DetailsPage(), settings: settings);
      case RoutePath.guestRecordPage:
        return pageRoute(GuestRecordPage(), settings: settings);
      case RoutePath.registerPage:
        return pageRoute(RegisterPage(), settings: settings);
      case RoutePath.aiAssistantPage:
        return pageRoute(AiAssistantPage(), settings: settings);
    }
    return null;
  }

  static MaterialPageRoute pageRoute(Widget page,
      {RouteSettings? settings,
      bool? fullScreenDialog,
      bool? maintainState,
      bool? allowSnapshotting}) {
    return MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: settings,
        fullscreenDialog: fullScreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}

class RoutePath {
  static const String homePage = "/home_page";
  static const String loginPage = "/login_page";
  static const String resetPasswordPage = "/reset_password_page";
  static const String qrCodeScannerPage = "/qr_code_scanner_page";
  static const String detailsPage = "/details_page";
  static const String guestRecordPage = "/guest_record_page";
  static const String registerPage = "/register_page";
  static const String aiAssistantPage = "/ai_assistant_page";
}
