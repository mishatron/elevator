import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) =>
      navigatorKey.currentState.pushNamed(routeName, arguments: arguments);

  bool goBack({dynamic data}) => navigatorKey.currentState.pop(data);

  Future<dynamic> pushNamedAndPop(String routeName, {dynamic arguments}) {
    navigatorKey.currentState.pop();
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedReplacement(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
      String routeName, RoutePredicate predicate,
      {dynamic arguments}) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, predicate);
  }

  Future<dynamic> pushAndRemoveAnother(String routeName){
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }
}
