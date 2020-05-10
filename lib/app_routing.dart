import 'package:flutter/cupertino.dart';
import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/components/add_to_do/add_to_do.dart';
import 'package:to_do_mobile_app/components/app_tab_bar/app_tab_bar.dart';

class AppRouting {
  /// Routing outside the `AppTabBar`.
  static Route<dynamic> generateAppRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.appTabBarPath:
        return CupertinoPageRoute(
          builder: (_) => AppTabBar(),
        );
      default:
        assert(false, 'No route defined for ${settings.name}');
        return null;
    }
  }

  /// Routing inside the `AppTabBar`.
  static Route<dynamic> generateAppTabBarRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.addToDoPath:
        return CupertinoPageRoute(
          builder: (_) => AddToDo(),
        );
      default:
        assert(false, 'No route defined for ${settings.name}');
        return null;
    }
  }
}