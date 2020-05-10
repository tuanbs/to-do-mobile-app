import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/app_constants.dart';
import 'package:to_do_mobile_app/app_routing.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var _brightness = Brightness.light;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: _brightness,
      ),
      initialRoute: AppConstants.appTabBarPath,
      onGenerateRoute: AppRouting.generateAppRoute,
      // home: Home(title: 'To Do Demo'),
    );
  }
}