import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  Future<dynamic> navigateTo(Widget page) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<dynamic> pushAndRemoveUntil(Widget page, RoutePredicate predicate) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
