import 'package:flutter/cupertino.dart';
import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/components/app_tab_bar/app_tab_bar.dart';

class AppRouting {
    static Route<dynamic> generateAppRoute(RouteSettings settings) {
        switch (settings.name) {
          case AppConstants.homePath:
            return CupertinoPageRoute(
              builder: (_) => AppTabBar(),
            );
          default:
            assert(false, 'No route defined for ${settings.name}');
            return null;
        }
    }
}