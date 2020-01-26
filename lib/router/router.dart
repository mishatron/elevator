import 'package:elevator/src/view/login/login_screen.dart';
import 'package:elevator/src/view/main/main_screen.dart';
import 'package:elevator/src/view/order_detail/order_detail_screen.dart';
import 'package:elevator/src/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:elevator/router/route_paths.dart' as routes;
Route<dynamic> generateRoute(RouteSettings settings) {
  MaterialPageRoute getPageRoute(Widget screen) {
    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }

  switch (settings.name) {
    case routes.splashRoute:
      return getPageRoute(SplashScreen());
    case routes.loginRoute:
      return getPageRoute(LoginScreen());
    case routes.mainRoute:
      return getPageRoute(MainScreen());
    case routes.orderDetailRoute:
      return getPageRoute(OrderDetail());

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No screen for ${settings.name} path'),
          ),
        ),
      );
  }
}
