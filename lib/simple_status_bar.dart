import 'dart:async';

import 'package:flutter/services.dart';

class SimpleStatusBar {
  static const MethodChannel _channel = const MethodChannel('simple_status_bar');

  static Future<bool> toggle({bool hide, StatusBarAnimation animation}) async {
    return await _channel.invokeMethod('toggleStatusBar', {
      'hide': hide ?? false,
      'animation': _getAnimation(animation),
    });
  }

  static Future isDarkModeOn() async {
    _channel.invokeMethod('isDarkModeOn');
  }

  // listen theme state

  // decorate status bar
}

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
