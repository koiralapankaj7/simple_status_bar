import 'package:simple_status_bar_platform_interface/simple_status_bar_platform_interface.dart';

/// An implementation of [SimpleStatusBarPlatform] that uses a `MethodChannel`
/// to communicate with the native code.
///

/// This is the instance that runs when the native side talks
/// to your Flutter app through MethodChannels (Android and iOS platforms).
class MethodChannelSimpleStatusBar extends SimpleStatusBarPlatform {}
