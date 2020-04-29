# Code flow of `to-do` app.

This is the step-by-step instructions on how to create this app from scratch.

## Table of contents.
  
1. [Prerequisites.](#Prerequisites)
1. [Creating and installing dependencies.](#Creating-and-installing-dependencies.)

## Prerequisites.

- Basic understanding of `Flutter` and `Dart`.
- Install the latest version of `Flutter` properly on your system.

## Creating and installing dependencies.

Run cmd `flutter create my_notes_flutter_mobile` to create this app.

Open `pubspec.yaml` file to include 3rd-party packages:
```yaml
...
dependencies:
  flutter:
    sdk: flutter
  provider: ^3.1.0 # The provider package for managing the state of the app.
...
```

Then run `flutter pub get` to update packages.

Open the app in `VS Code` and press `Ctrl + F5` -> Make sure you see the initial screen of flutter app with no error before moving to next step.

## Create the app's structure:

I make this app's structure similar to the `Angular` app version:
```
project
│   README.md
│   CODE_FLOW.md
│   pubspec.yaml
│
└───assets
│   
└───docs
│   │   user_manual.md
│   │
│   └───images
│       │   home_screen.png
│       │   ...
│
└───lib
│   │   app_constants.dart
│   │   app_routing.dart
│   │   main.dart
│   │   my_app.dart
│   │
│   └───components
│   │   └───login
│   │   │   │   login.dart
│   │   │   │   ...
│   │   └───home
│   │       │   home.dart
│   │       │   ...
│   │
│   └───shared
│       └───components
│       └───data
│       │   └───repositories
│       └───models
│       └───services
│   
└───test
    │   widget_test.dart
    │   widget_test2.dart
```

## Create `/assets/images` folder.

Put necessary images inside this folder and import them by editing `pubspec.yaml` file as following:
```yaml
...
flutter:
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/images/facebook-logo.png
    - assets/images/google-logo.png
...
```

## Create `AppConstants`:

Create `/lib/app_constants.dart`:
```dart
import 'package:flutter/widgets.dart';

class AppConstants {
  // Login Screens.
  static const String loginScreenTitle = 'My Notes';

  // Home Screens.
  static const String homeScreenTitle = 'Home';

  //#region assets paths.
  static const String googleLogoPath = 'assets/images/google-logo.png';
  static const String facebookLogoPath = 'assets/images/facebook-logo.png';
  //#end-region.
}
```

## Create `Home` component.

Open `main.dart` file and refactor `MyHonePage` into `Home`.

Move this `Home` component into `lib/components/home`. -> Import necessary packages as required.

## Create `MyApp` component.

Open `main.dart` and move `MyApp` class into `my_app.dart` file.

Edit `MyHomePage` into `Home` and import the `Home` component.

**NOTE:** To avoid potential issue, you should import with the prefix `package:<path_to_component>`. For example: `import 'package:to_do_mobile_app/components/home/home.dart';`

## Modify `main.app` file.

Open `main.app` file and mark its main() function as `async`. We need this as `async` because we need have some configurations before running the app:
```dart
void main() async {
  var myApp = MyApp();
  runApp(myApp);
}
```

Now we're able to run the app using the new structure.

## C




## Create `Home`, `Settings` and other components with basic UI:

Create `/lib/components/home/home.dart`:
```dart
class Home extends StatefulWidget {
  Home() : super(key: AppConstants.homeScreenKey);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.homeScreenTitle),
      ),
      body: Center(
        child: Text('This is home screen.'),
      ),
    );
  }
}
```

Do the same for `Settings` and other component.

## Create `AppTabBar` component:

Create `/lib/components/app_tab_bar/app_tab_bar.dart`:
```dart
```

## Create `AppRouting`:

Create `/lib/app_routing.dart`:
```dart
```





## Create shared components `CustomRaisedButton`, `FormSubmitButton`:

In `/lib/shared/components`, create `custom_raised_button/custom_raised_button.dart` and `form_submit_button/form_submit_button.dart`:

```dart
```

```dart
```

## Create `Login` screen:

In folder `/lib/components/login/`, create `login_button.dart`, `social_login_button.dart` and `login.dart` respectively:
```dart
```

## Create `Email Login` dialog:

In `/lib/components/login/email_login_dialog`, create `email_login_form.dart` and `email_login_dialog.dart`:
```dart
```





Then run it to see the result.