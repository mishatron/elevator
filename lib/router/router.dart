import 'package:elevator/src/view/create_order/create_order_screen.dart';
import 'package:elevator/src/view/login/login_screen.dart';
import 'package:elevator/src/view/main/history/filter/history_filter_screen.dart';
import 'package:elevator/src/view/main/main_screen.dart';
import 'package:elevator/src/view/order_detail/order_detail_screen.dart';
import 'package:elevator/src/view/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevator/router/route_paths.dart' as routes;
Route<dynamic> generateRoute(RouteSettings settings) {
  CupertinoPageRoute getPageRoute(Widget screen) {
    return CupertinoPageRoute(builder: (context) => screen, settings: settings);
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
    case routes.createOrderRoute:
      return getPageRoute(CreateOrderScreen());
    case routes.filteredHistoryRoute:
      return getPageRoute(HistoryFilterScreen());

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
