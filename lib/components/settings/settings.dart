import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_mobile_app/app_globals.dart';
import 'package:to_do_mobile_app/app_injections.dart';
import 'package:to_do_mobile_app/shared/data/repositories/setting_repo_service.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);
  
  static const String title = 'Settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchBtnValue = AppGlobals.isDarkMode;

  /* DI Services vars. */
  SettingRepoService _settingRepoService;

  _SettingsState() {
    /* DI Services. */
    _settingRepoService = _settingRepoService ?? getIt<SettingRepoService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Settings.title),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Dark mode'),
              trailing: Switch(
                value: _switchBtnValue,
                onChanged: (value) async {
                  _switchBtnValue = value;
                  await _settingRepoService.toggleIsDarkMode(isDarkMode: _switchBtnValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}