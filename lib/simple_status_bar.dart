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

  static Future<SystemTheme> getSystemTheme() async {
    final int type = await _channel.invokeMethod('getSystemTheme');
    return type == 1 ? SystemTheme.LIGHT : SystemTheme.DARK;
  }

  static Future changeColor({@required Color color, double value}) async {
    if (color == null)
      throw Exception(["Exception occured while changing color. Reason => Color cannot be null."]);
    final double luminance = color.computeLuminance();
    final bool isDarkColor = luminance < (value ?? 0.4);

    print(
        "Computing Color Luminance : Luminance is $luminance ==================> DARK : $isDarkColor");

    await _channel.invokeMethod('changeColor', {'color': color.value, 'isDarkColor': isDarkColor});
  }

  // listen theme state
  // changeColor

  // decorate status bar
}

enum SystemTheme { LIGHT, DARK, SYSTEM_DEFAULT, BATTERY_SAVER }

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
