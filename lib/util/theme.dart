import 'package:flutter/material.dart';

class MyTheme {
  static const MaterialColor _white = MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );

  static const MaterialColor _night = MaterialColor(
    0xff303030,
    const <int, Color>{
      50: const Color(0xff303030),
      100: const Color(0xff303030),
      200: const Color(0xff303030),
      300: const Color(0xff303030),
      400: const Color(0xff303030),
      500: const Color(0xff303030),
      600: const Color(0xff303030),
      700: const Color(0xff303030),
      800: const Color(0xff303030),
      900: const Color(0xff303030),
    },
  );

  static const Map<String, Color> LIGHT = {
    'background': _white,
    'fontColor': Color(0xff333333),
    'borderBottom': Color(0x60e6e6e6),
  };

  static const Map<String, Color> NIGHT = {
    'background': _night,
    'fontColor': Color(0xffd6d6d6),
    'borderBottom': Color(0x10e6e6e6),
  };
}
