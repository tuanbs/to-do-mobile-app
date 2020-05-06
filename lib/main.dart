import 'package:flutter/material.dart';

import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter app initializes properly before initializing other configurations.
  
  var myApp = MyApp();
  // await AppGlobals.init(myAppNavigatorKeyParam: myApp.navigatorKey);
  await AppInjections.setupDI();
  
  runApp(myApp);
}
