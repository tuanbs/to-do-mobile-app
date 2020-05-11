import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_mobile_app/app_constants.dart';

/// Use the `SharedPreferences` as its `localStorage` and put it into the following class `AppGlobals`. In web app like `Angular` or `React`, the `localStorage` is supported out of the box.
/// NOTE: This class doesn't not exist in web app. I need this here to support `Flutter` app.
class AppGlobals {
  static SharedPreferences _localStorage;
  static SharedPreferences get localStorage {
    return _localStorage;
  }

  //// Global stuffs for the `Settings`.
  static bool isDarkMode = localStorage?.getBool(AppConstants.isDarkModeKey) ?? false;
  static Future<void> setIsDarkModeSettingInLocalStorage(bool isDarkMode) async {
    await localStorage.setBool(AppConstants.isDarkModeKey, isDarkMode);
  }

  static Future init() async {
    try {
      _localStorage = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Exception in AppGlobals.init(). e is: $e');
    }
  }
}