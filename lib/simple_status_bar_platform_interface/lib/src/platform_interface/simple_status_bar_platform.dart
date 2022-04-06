import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:simple_status_bar_platform_interface/src/entities/enums.dart';
import 'package:simple_status_bar_platform_interface/src/method_channel/method_channel_simple_status_bar.dart';

/// The interface that implementations of simple_status_bar must implement.
///
/// Platform implementations should extend this class rather than implement it as `simple_status_bar`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [SimpleStatusBarPlatform] methods.
abstract class SimpleStatusBarPlatform extends PlatformInterface {
  /// Constructs a SimpleStatusBarPlatform.
  SimpleStatusBarPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleStatusBarPlatform _instance = MethodChannelSimpleStatusBar();

  /// The default instance of [SimpleStatusBarPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleStatusBar].
  static SimpleStatusBarPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SimpleStatusBarPlatform] when they register themselves.
  static set instance(SimpleStatusBarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///
  Future<void> showStatusBar({StatusBarAnimation? animation}) {
    throw UnimplementedError('showStatusBar() has not been implemented.');
  }

  ///
  Future<void> hideStatusBar({StatusBarAnimation? animation}) {
    throw UnimplementedError('hideStatusBar() has not been implemented.');
  }

  ///
  Future<void> tooggleStatusBar({StatusBarAnimation? animation}) {
    throw UnimplementedError('tooggleStatusBar() has not been implemented.');
  }
}
