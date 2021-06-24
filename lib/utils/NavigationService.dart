import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  // bool? goBack() {
  //   return navigatorKey.currentState!.pop();
  // }
}
