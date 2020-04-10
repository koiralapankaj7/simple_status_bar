import Flutter
import UIKit

public class SwiftSimpleStatusBarPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_status_bar", binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleStatusBarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
        case "toggleStatusBar":
            do {
                try toggleStatusBar(call, result)
                result(NSNumber(value: true))
            } catch {
                print("Something went wrong while toggling statusbar")
                result(NSNumber(value: false))
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func toggleStatusBar(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
        let hide : Bool = args["hide"] as! Bool
        let animationArgs = args["animation"] as! String
        var animation: UIStatusBarAnimation
        
        if (animationArgs == "slide") {
            animation = .slide
        } else if (animationArgs == "fade") {
            animation = .fade
        } else {
            animation = .none
        }
        UIApplication.shared.setStatusBarHidden(hide, with: animation)
        
        
    }
    
}
