import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SPSettings {
  static late SPSettings _instance;
  final String fontSizeKey = 'font_size';
  final String colorKey = 'color';
  static late SharedPreferences _sp;

  Future init() async {
    _sp = await SharedPreferences.getInstance();
  }

  SPSettings._internal();

  SPSettings() {
    _instance = this;
  }

  Future setColor(int color) {
    return _sp.setInt(colorKey, color);
  }

  int getColor() {
    int? color = _sp.getInt(colorKey);
    if (color == null) {
      return 0xff1976D2; //blue
    } else {
      return color;
    }
  }

  double getFontSize() {
    return _sp.getDouble(fontSizeKey) as double;
  }

  Future setFontSize(double? size) {
    return _sp.setDouble(fontSizeKey, size as double);
  }
}
