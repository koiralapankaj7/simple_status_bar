import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleStatusBar {
  static const MethodChannel _channel = const MethodChannel('simple_status_bar');

  static const String _SHOW_STATUS_BAR_METHOD = "showStatusBar";
  static const String _HIDE_STATUS_BAR_METHOD = "hideStatusBar";
  static const String _CHANGE_STATUS_BAR_COLOR_METHOD = "changeStatusBarColor";
  static const String _GET_STATUS_BAR_BRIGHTNESS_METHOD = "getStatusBarBrightness";
  static const String _CHANGE_STATUS_BAR_BRIGHTNESS_METHOD = "changeStatusBarBrightness";
  static const String _GET_SYSTEM_UI_MODE = "getSystemUiMode";

  // 1. Show status bar
  static Future showStatusBar({StatusBarAnimation animation}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _channel
          .invokeMethod(_SHOW_STATUS_BAR_METHOD, {'animation': _getAnimation(animation)});
    }
  }

  // 2. Hide status bar
  static Future hideStatusBar({StatusBarAnimation animation}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _channel
          .invokeMethod(_HIDE_STATUS_BAR_METHOD, {'animation': _getAnimation(animation)});
    }
  }

  // 3. Change status bar color
  static Future changeStatusBarColor(
      {@required Color color,
      bool adaptiveBrightness,
      double luminaceValue,
      bool animate,
      bool forIos,
      bool forAndroid}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (color == null)
        throw Exception(
            ["Exception occured while changing color. Reason => Color cannot be null."]);
      bool isDarkColor;
      if (adaptiveBrightness ?? true) {
        final double luminance = color.computeLuminance();
        isDarkColor = luminance < (luminaceValue ?? 0.4);
        print("Computing Color Luminance :  $luminance ==================> DARK : $isDarkColor");
      }
      print("Color value as string : ${color.toString()}");
      await _channel.invokeMethod(_CHANGE_STATUS_BAR_COLOR_METHOD, {
        'color': color.value,
        'isDarkColor': isDarkColor,
        'animate': animate ?? true,
        'forIos': forIos ?? true,
        'forAndroid': forAndroid ?? true,
      });
    }
  }

  static Future<Brightness> getStatusBarBrightness() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final int type = await _channel.invokeMethod(_GET_STATUS_BAR_BRIGHTNESS_METHOD);
      return type == 1 ? Brightness.light : Brightness.dark;
    }
    return null;
  }

  // 4. Change status bar brightness
  static Future changeStatusBarBrightness({
    @required Brightness brightness,
    bool animate,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (brightness == null)
        throw Exception(
            ["Exception occured while changing brightness. Reason => Brightness cannot be null."]);
      await _channel.invokeMethod(_CHANGE_STATUS_BAR_BRIGHTNESS_METHOD, {
        'brightness': brightness == Brightness.light ? 1 : 2,
        'animate': animate ?? true,
      });
    }
  }

  // 5. Get system UI-Mode
  static Future<SystemUiMode> getSystemUiMode() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final int type = await _channel.invokeMethod(_GET_SYSTEM_UI_MODE);
      return _getTheme(type);
    }
    return SystemUiMode.UNKNOWN;
  }

  @deprecated
  static Future changeColor({@required Color color, double value}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (color == null)
        throw Exception(
            ["Exception occured while changing color. Reason => Color cannot be null."]);
      final double luminance = color.computeLuminance();
      final bool isDarkColor = luminance < (value ?? 0.4);
      print("Computing Color Luminance :  $luminance ==================> DARK : $isDarkColor");
      await _channel
          .invokeMethod('changeColor', {'color': color.value, 'isDarkColor': isDarkColor});
    }
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
