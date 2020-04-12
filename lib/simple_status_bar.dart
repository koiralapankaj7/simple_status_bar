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

  static Future<SystemUiMode> getSystemUiMode() async {
    final int type = await _channel.invokeMethod('getSystemUiMode');
    return _getTheme(type);
  }

  static Future changeColor({@required Color color, double value}) async {
    if (color == null)
      throw Exception(["Exception occured while changing color. Reason => Color cannot be null."]);
    final double luminance = color.computeLuminance();
    final bool isDarkColor = luminance < (value ?? 0.4);
    print("Computing Color Luminance :  $luminance ==================> DARK : $isDarkColor");
    await _channel.invokeMethod('changeColor', {'color': color.value, 'isDarkColor': isDarkColor});
  }

  // listen theme state
  // changeColor

  // decorate status bar
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
