import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/app_globals.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/app_routing.dart';
import 'package:to_do_mobile_app/shared/data/repositories/setting_repo_service.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<dynamic> _isDarkModeSettingObservableSubscriber;
  bool _isDarkMode = AppGlobals.isDarkMode;

  /* DI Services vars. */
  SettingRepoService _settingRepoService;

  _MyAppState() {
    /* DI Services. */
    _settingRepoService = _settingRepoService ?? getIt<SettingRepoService>();
  }

  @override
  void initState() {
    super.initState();
    _isDarkModeSettingObservableSubscriber = _settingRepoService.isDarkModeSettingObservable.listen((_switchBtnValue) {
      setState(() {
        _isDarkMode = _switchBtnValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          // foregroundColor: Colors.yellowAccent,
        ),
      ),
      initialRoute: AppConstants.appTabBarPath,
      onGenerateRoute: AppRouting.generateAppRoute,
      // home: Home(title: 'To Do Demo'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isDarkModeSettingObservableSubscriber.cancel();
  }
}