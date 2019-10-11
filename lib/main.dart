import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithome_lite/pages/home.dart';
import 'package:ithome_lite/state/enum_theme.dart';
import 'package:ithome_lite/state/state_container.dart';
import 'package:ithome_lite/util/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  final sp = await SharedPreferences.getInstance();
  bool isLight = sp.getBool('themeIsLight');
  if (isLight == null) {
    isLight = true;
  }
  runApp(StateContainer(
    child: Home(),
    activedTheme: ActivedTheme(isLight ? MyTheme.LIGHT : MyTheme.NIGHT,
        isLight ? ActivedThemeIndex.LIGHT : ActivedThemeIndex.NIGHT),
  ));
}
