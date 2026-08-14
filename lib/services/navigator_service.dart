import 'package:flutter/material.dart';

class NavigationService {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final tabBarKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<dynamic>? pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? pushReplacementNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  Future<dynamic>? popAllAndPushNamed(String routeName, {Object? arguments,}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments,
    );
  }

  Future<dynamic>? popUntilAndPushNamed(
      String routeName, String popRouteUntil, {
        Object? arguments,
      }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(popRouteUntil),
      arguments: arguments,
    );
  }

  void pop({returnValue}) {
    navigatorKey.currentState?.pop(returnValue);
  }

  void changeTab(int index) {
    final BottomNavigationBar navigationBar = (tabBarKey.currentWidget as BottomNavigationBar);
    if (navigationBar.currentIndex != index) {
      navigationBar.onTap!(index);
    }
  }

}

