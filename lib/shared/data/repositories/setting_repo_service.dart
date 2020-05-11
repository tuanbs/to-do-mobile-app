import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_mobile_app/app_globals.dart';

class SettingRepoService {
  BehaviorSubject _isDarkModeSettingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get isDarkModeSettingObservable => _isDarkModeSettingBehaviorSubject.asBroadcastStream();

  Future toggleIsDarkMode({bool isDarkMode = false}) async {
    dynamic error;

    try {
      // Save isDarkMode setting to local storage.
      await AppGlobals.setIsDarkModeSettingInLocalStorage(isDarkMode);
      _isDarkModeSettingBehaviorSubject.add(isDarkMode);
      return Future.value();
    } catch (e) {
      error = e;
      debugPrint('SettingRepoService SettingRepoService failed. error is: $error');
    }
    return Future.error(error);
  }
}