import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util {
  static final _now = DateTime.now();

  static String formatDateTime(date) {
    final postDateTime = DateTime.parse(date);
    if (_now.year == postDateTime.year &&
        _now.month == postDateTime.month &&
        _now.day == postDateTime.day) {
      return '${addZero(postDateTime.hour)}:${addZero(postDateTime.minute)}';
    } else if (_now.year == postDateTime.year) {
      return '${postDateTime.month}月${postDateTime.day}日';
    } else {
      return '${postDateTime.year}年${postDateTime.month}月${postDateTime.day}日';
    }
  }

  static String addZero(num) => num >= 10 ? num.toString() : '0$num';

  static Future<String> encryDES(String data) async {
    String result = "";
    final methodChannel = MethodChannel('fun_.zhcode/ithome_lite');
    try {
      result = await methodChannel.invokeMethod('encryDES', data); //分析2
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  static simpleToast(String msg) => Fluttertoast.showToast(
        msg: msg,
        fontSize: 14,
      );
}
