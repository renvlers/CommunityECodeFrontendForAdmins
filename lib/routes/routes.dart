import 'package:flutter/material.dart';
import 'package:frontend_for_admins/pages/home_page.dart';
import 'package:frontend_for_admins/pages/login_page.dart';
import 'package:frontend_for_admins/pages/reset_password_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.homePage:
        return pageRoute(HomePage(), settings: settings);
      case RoutePath.loginPage:
        return pageRoute(LoginPage(), settings: settings);
      case RoutePath.resetPasswordPage:
        return pageRoute(ResetPasswordPage(), settings: settings);
    }
    return pageRoute(Scaffold(
      body: SafeArea(child: Center(child: Text("页面${settings.name}不存在"))),
    ));
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
}
