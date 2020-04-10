#import "SimpleStatusBarPlugin.h"
#if __has_include(<simple_status_bar/simple_status_bar-Swift.h>)
#import <simple_status_bar/simple_status_bar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "simple_status_bar-Swift.h"
#endif

@implementation SimpleStatusBarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleStatusBarPlugin registerWithRegistrar:registrar];
}
@end
