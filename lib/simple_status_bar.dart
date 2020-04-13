import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class SimpleStatusBar {
  static const MethodChannel _channel = const MethodChannel('simple_status_bar');

  static Future<bool> toggle({bool hide, StatusBarAnimation animation}) async {
    return await _channel.invokeMethod('toggleStatusBar', {
      'hide': hide ?? false,
      'animation': _getAnimation(animation),
    });
  }

  static Future changeStatusBarColor(
      {@required Color color,
      bool adaptiveBrightness,
      double luminaceValue,
      bool animate,
      bool forIos,
      bool forAndroid}) async {
    if (color == null)
      throw Exception(["Exception occured while changing color. Reason => Color cannot be null."]);
    bool isDarkColor;
    if (adaptiveBrightness ?? true) {
      final double luminance = color.computeLuminance();
      isDarkColor = luminance < (luminaceValue ?? 0.4);
      print("Computing Color Luminance :  $luminance ==================> DARK : $isDarkColor");
    }
    await _channel.invokeMethod('changeStatusBarColor', {
      'color': color,
      'isDarkColor': isDarkColor,
      'animate': animate ?? true,
      'forIos': forIos ?? true,
      'forAndroid': forAndroid ?? true,
    });
  }

  static Future changeStatusBarBrightness({
    @required Brightness brightness,
    bool animate,
  }) async {
    // TODO Check null brightness
    await _channel.invokeMethod('changeStatusBarBrightness', {
      'brightness': brightness == Brightness.light ? 1 : 2,
      'animate': animate ?? true,
    });
  }

  static Future<SystemUiMode> getSystemUiMode() async {
    final int type = await _channel.invokeMethod('getSystemUiMode');
    return _getTheme(type);
  }

  @deprecated
  static Future changeColor({@required Color color, double value}) async {
    if (color == null)
      throw Exception(["Exception occured while changing color. Reason => Color cannot be null."]);
    final double luminance = color.computeLuminance();
    final bool isDarkColor = luminance < (value ?? 0.4);
    print("Computing Color Luminance :  $luminance ==================> DARK : $isDarkColor");
    await _channel.invokeMethod('changeColor', {'color': color.value, 'isDarkColor': isDarkColor});
  }

  // listen theme state
}

enum SystemUiMode { LIGHT, DARK, SYSTEM_DEFAULT, UNKNOWN }
enum StatusBarAnimation { SLIDE, FADE, NONE }

String _getAnimation(StatusBarAnimation animation) {
  switch (animation) {
    case StatusBarAnimation.NONE:
      return 'none';
    case StatusBarAnimation.FADE:
      return 'fade';
    default:
      return 'slide';
  }
}

SystemUiMode _getTheme(int type) {
  switch (type) {
    case 1:
      return SystemUiMode.LIGHT;
    case 2:
      return SystemUiMode.DARK;
    case 3:
      return SystemUiMode.SYSTEM_DEFAULT;
      break;
    default:
      return SystemUiMode.UNKNOWN;
      break;
  }
}
