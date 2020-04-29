import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/my_app.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Fix [issue](https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse) after upgrading Flutter SDK from 1.9 to 1.12.
  
  var myApp = MyApp();
  // await AppGlobals.init(myAppNavigatorKeyParam: myApp.navigatorKey);
  // AppInjections.setupDI();
  
  runApp(myApp);
}
