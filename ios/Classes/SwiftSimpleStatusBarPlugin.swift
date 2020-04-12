import Flutter
import UIKit
import UIKit.UITraitCollection

public class SwiftSimpleStatusBarPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_status_bar", binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleStatusBarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "toggleStatusBar":
            toggleStatusBar(call, result)
        case "getSystemUiMode":
            getSystemUiMode(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func toggleStatusBar(_ call: FlutterMethodCall, _ result: FlutterResult) {
        do {
            try toggle(call)
            result(NSNumber(value: true))
            
        } catch let error {
            result(NSNumber(value: false))
            print("Something went wrong while toggling statusbar.......... \(error)")
            
        }
        
    }
    
    private func toggle(_ call: FlutterMethodCall) throws {
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
    
    private func getSystemUiMode(_ call: FlutterMethodCall, _ result: FlutterResult) {
        do {
            try uiMode(call, result)
        } catch  {
            result(NSNumber(value: false))
            print("Something went wrong while fetching UI Mode.......... \(error)")
        }
    }
    
    private func uiMode(_ call: FlutterMethodCall, _ result: FlutterResult) throws {
        if #available(iOS 13.0, *) {
            switch UITraitCollection.current.userInterfaceStyle {
            case .light:
                result(1)
            case .dark:
                result(2)
            default:
                result(3)
            }
        } else {
            result(3)
        }
    }
    
}
