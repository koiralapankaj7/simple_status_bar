 import Flutter
 import UIKit
 import UIKit.UITraitCollection
 
 public class SwiftSimpleStatusBarPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_status_bar", binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleStatusBarPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    let SHOW_STATUS_BAR_METHOD : String = "showStatusBar";
    let HIDE_STATUS_BAR_METHOD : String = "hideStatusBar";
    let CHANGE_STATUS_BAR_COLOR_METHOD : String = "changeStatusBarColor";
    let CHANGE_STATUS_BAR_BRIGHTNESS_METHOD : String = "changeStatusBarBrightness";
    let GET_SYSTEM_UI_MODE : String = "getSystemUiMode";
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case SHOW_STATUS_BAR_METHOD:
            showStatusBar(call, result)
            
        case HIDE_STATUS_BAR_METHOD:
            hideStatusBar(call, result)
            
        case CHANGE_STATUS_BAR_COLOR_METHOD:
            changeStatusBarColor(call, result)
            
        case CHANGE_STATUS_BAR_BRIGHTNESS_METHOD:
            changeStatusBarBrightness(call, result)
            
        case GET_SYSTEM_UI_MODE:
            getSystemUiMode(call, result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    /// Show status bar
    private func showStatusBar(_ call: FlutterMethodCall, _ result: FlutterResult) {
        do {
            try toggleStatusBar(call, false)
            result(NSNumber(value: true))
        } catch let error {
            result(NSNumber(value: false))
            print("Something went wrong while showing statusbar.......... \(error)")
        }
    }
    
    /// Hide status bar
    private func hideStatusBar(_ call: FlutterMethodCall, _ result: FlutterResult) {
        do {
            try toggleStatusBar(call, true)
            result(NSNumber(value: true))
        } catch let error {
            result(NSNumber(value: false))
            print("Something went wrong while hiding statusbar.......... \(error)")
        }
    }

    /// Toggling status bar on and off
    private func toggleStatusBar(_ call: FlutterMethodCall, _ hide : Bool) throws {
        let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
        let animation: UIStatusBarAnimation = getAnimation(args["animation"] as! String)
        UIApplication.shared.setStatusBarHidden(hide, with: animation)
    }
    
    // GEt animation from string type
    private func getAnimation(_ type : String) -> UIStatusBarAnimation {
        if (type == "slide") {
            return UIStatusBarAnimation.slide
        } else if (type == "fade") {
            return UIStatusBarAnimation.fade
        } else {
            return  UIStatusBarAnimation.none
        }
    }
    
    /// Get system ui mode e.g, Dark or light mode
    private func getSystemUiMode(_ call: FlutterMethodCall, _ result: FlutterResult) {
        do {
            try getUiMode(call, result)
        } catch  {
            result(NSNumber(value: false))
            print("Something went wrong while fetching UI Mode.......... \(error)")
        }
    }
    
    // HElper function for getSystemUiMode
    private func getUiMode(_ call: FlutterMethodCall, _ result: FlutterResult) throws {
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
 
    
    /// Change status bar brightness
    private func changeStatusBarBrightness(_ call: FlutterMethodCall, _ result: FlutterResult){
        let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
        let brightness : Int = args["brightness"] as! Int
        let animate : Bool = args["animate"] as! Bool
        
        do {
            if #available(iOS 13.0, *) {
                try setStatusBarStyle(to: brightness == 1 ? UIStatusBarStyle.lightContent : UIStatusBarStyle.darkContent, animation: animate)
                result(true)
            } else {
                try setStatusBarStyle(to:UIStatusBarStyle.default, animation: animate)
                result(true)
            }
        } catch let error {
            print("Something went wrong while changing status bar color.......... \(error)")
            result(false)
        }
        
    }
    
    // Change status bar brightness helper function
    private func setStatusBarStyle(to style :UIStatusBarStyle, animation animate : Bool) throws {
        UIApplication.shared.setStatusBarStyle(style, animated: animate)
    }
    
    
    
     private func changeStatusBarColor(_ call: FlutterMethodCall, _ result: FlutterResult){
         //        let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
         //        let color : Int = args["color"] as! Int
         //        let isDarkColor : Bool? = args["isDarkColor"] as? Bool
         //        let forIos : Bool? = args["forIos"] as? Bool
         
         
         if #available(iOS 13.0, *) {
             
             
             let rootViewController: UIViewController! = UIApplication.shared.keyWindow?.rootViewController
             
             let app = UIApplication.shared
             let statusBarHeight: CGFloat = app.statusBarFrame.size.height
             
             let statusbarView = UIView()
             statusbarView.backgroundColor = UIColor.red
             rootViewController.view.addSubview(statusbarView)
             
             statusbarView.translatesAutoresizingMaskIntoConstraints = false
             statusbarView.heightAnchor
                 .constraint(equalToConstant: statusBarHeight).isActive = true
             statusbarView.widthAnchor
                 .constraint(equalTo: rootViewController.view.widthAnchor, multiplier: 1.0).isActive = true
             statusbarView.topAnchor
                 .constraint(equalTo: rootViewController.view.topAnchor).isActive = true
             statusbarView.centerXAnchor
                 .constraint(equalTo: rootViewController.view.centerXAnchor).isActive = true
             
         } else {
             let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
             statusBar?.backgroundColor = UIColor.red
         }
         
     }
    
 }
 
 
 class ViewController: UIViewController {
    
    fileprivate var customStatusBarHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.red
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            customStatusBarHeightConstraint = statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight)
            customStatusBarHeightConstraint?.isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let customStatusBarHeightConstraint = customStatusBarHeightConstraint {
            let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            if customStatusBarHeightConstraint.constant != statusBarHeight {
                customStatusBarHeightConstraint.constant = statusBarHeight
            }
        }
    }
    
 }
 


// import Flutter
// import UIKit
// import UIKit.UITraitCollection

// public class SwiftSimpleStatusBarPlugin: NSObject, FlutterPlugin {
    
//     public static func register(with registrar: FlutterPluginRegistrar) {
//         let channel = FlutterMethodChannel(name: "simple_status_bar", binaryMessenger: registrar.messenger())
//         let instance = SwiftSimpleStatusBarPlugin()
        
//         registrar.addMethodCallDelegate(instance, channel: channel)
//     }
    
//     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
//         switch call.method {
//         case "toggleStatusBar":
//             toggleStatusBar(call, result)
//         case "getSystemUiMode":
//             getSystemUiMode(call, result)
//         case "changeStatusBarColor":
//             changeStatusBarColor(call, result)
//         case "changeStatusBarBrightness":
//             changeStatusBarBrightness(call, result)
//         default:
//             result(FlutterMethodNotImplemented)
//         }
//     }
    
//     private func toggleStatusBar(_ call: FlutterMethodCall, _ result: FlutterResult) {
//         do {
//             try toggle(call)
//             result(NSNumber(value: true))
            
//         } catch let error {
//             result(NSNumber(value: false))
//             print("Something went wrong while toggling statusbar.......... \(error)")
//         }
        
//     }
    
//     private func toggle(_ call: FlutterMethodCall) throws {
//         let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
//         let hide : Bool = args["hide"] as! Bool
//         let animationArgs = args["animation"] as! String
//         var animation: UIStatusBarAnimation
        
//         if (animationArgs == "slide") {
//             animation = .slide
//         } else if (animationArgs == "fade") {
//             animation = .fade
//         } else {
//             animation = .none
//         }
//         UIApplication.shared.setStatusBarHidden(hide, with: animation)
//     }
    
    
//     private func getSystemUiMode(_ call: FlutterMethodCall, _ result: FlutterResult) {
//         do {
//             try uiMode(call, result)
//         } catch  {
//             result(NSNumber(value: false))
//             print("Something went wrong while fetching UI Mode.......... \(error)")
//         }
//     }
    
//     private func uiMode(_ call: FlutterMethodCall, _ result: FlutterResult) throws {
//         if #available(iOS 13.0, *) {
//             switch UITraitCollection.current.userInterfaceStyle {
//             case .light:
//                 result(1)
//             case .dark:
//                 result(2)
//             default:
//                 result(3)
//             }
//         } else {
//             result(3)
//         }
//     }
    
//     private func changeStatusBarColor(_ call: FlutterMethodCall, _ result: FlutterResult){
//         //        let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
//         //        let color : Int = args["color"] as! Int
//         //        let isDarkColor : Bool? = args["isDarkColor"] as? Bool
//         //        let forIos : Bool? = args["forIos"] as? Bool
        
        
//         if #available(iOS 13.0, *) {
            
            
//             let rootViewController: UIViewController! = UIApplication.shared.keyWindow?.rootViewController
            
//             let app = UIApplication.shared
//             let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
//             let statusbarView = UIView()
//             statusbarView.backgroundColor = UIColor.red
//             rootViewController.view.addSubview(statusbarView)
            
//             statusbarView.translatesAutoresizingMaskIntoConstraints = false
//             statusbarView.heightAnchor
//                 .constraint(equalToConstant: statusBarHeight).isActive = true
//             statusbarView.widthAnchor
//                 .constraint(equalTo: rootViewController.view.widthAnchor, multiplier: 1.0).isActive = true
//             statusbarView.topAnchor
//                 .constraint(equalTo: rootViewController.view.topAnchor).isActive = true
//             statusbarView.centerXAnchor
//                 .constraint(equalTo: rootViewController.view.centerXAnchor).isActive = true
            
//         } else {
//             let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//             statusBar?.backgroundColor = UIColor.red
//         }
        
//     }
    
    
//     private func changeStatusBarBrightness(_ call: FlutterMethodCall, _ result: FlutterResult){
//         let args : Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>
//         let brightness : Int = args["brightness"] as! Int
//         let animate : Bool = args["animate"] as! Bool
        
//         print("From Swift==================================")
//         debugPrint("I am debug print from ios ==================>")
        
//         do {
//             if #available(iOS 13.0, *) {
//                 try setStatusBarStyle(to: brightness == 1 ? UIStatusBarStyle.lightContent : UIStatusBarStyle.darkContent, animation: animate)
//                 result(true)
//             } else {
//                 try setStatusBarStyle(to:UIStatusBarStyle.default, animation: animate)
//                 result(true)
//             }
//         } catch let error {
//             print("Something went wrong while changing status bar color.......... \(error)")
//             result(false)
//         }
        
//     }
    
//     private func setStatusBarStyle(to style :UIStatusBarStyle, animation animate : Bool) throws {
//         UIApplication.shared.setStatusBarStyle(style, animated: animate)
//     }
    
// }


// class ViewController: UIViewController {
    
//     fileprivate var customStatusBarHeightConstraint: NSLayoutConstraint?
    
//     override func viewDidLoad() {
//         super.viewDidLoad()
//         if #available(iOS 13.0, *) {
//             let app = UIApplication.shared
//             let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
//             let statusbarView = UIView()
//             statusbarView.backgroundColor = UIColor.red
//             view.addSubview(statusbarView)
            
//             statusbarView.translatesAutoresizingMaskIntoConstraints = false
//             customStatusBarHeightConstraint = statusbarView.heightAnchor
//                 .constraint(equalToConstant: statusBarHeight)
//             customStatusBarHeightConstraint?.isActive = true
//             statusbarView.widthAnchor
//                 .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//             statusbarView.topAnchor
//                 .constraint(equalTo: view.topAnchor).isActive = true
//             statusbarView.centerXAnchor
//                 .constraint(equalTo: view.centerXAnchor).isActive = true
            
//         } else {
//             let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//             statusBar?.backgroundColor = UIColor.red
//         }
//     }
    
//     override var preferredStatusBarStyle : UIStatusBarStyle {
//         return UIStatusBarStyle.lightContent
//         //return UIStatusBarStyle.default   // Make dark again
//     }
    
//     override func viewWillLayoutSubviews() {
//         super.viewWillLayoutSubviews()
        
//         if let customStatusBarHeightConstraint = customStatusBarHeightConstraint {
//             let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//             if customStatusBarHeightConstraint.constant != statusBarHeight {
//                 customStatusBarHeightConstraint.constant = statusBarHeight
//             }
//         }
//     }
    
// }

