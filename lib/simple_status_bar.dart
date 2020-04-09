import 'dart:async';

import 'package:flutter/services.dart';

class SimpleStatusBar {
  static const MethodChannel _channel = const MethodChannel('simple_status_bar');

  static Future<bool> toggle({bool hidden, StatusBarAnimation animation}) async {
    return await _channel.invokeMethod('toggleStatusBar', {
      'hidden': hidden ?? false,
      'animation': _getAnimation(animation),
    });
  }
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
