package io.playsof.simple_status_bar

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception

/** SimpleStatusBarPlugin */
public class SimpleStatusBarPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    //

    private var activity: Activity? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_status_bar")
        channel.setMethodCallHandler(SimpleStatusBarPlugin());
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "simple_status_bar")
            channel.setMethodCallHandler(SimpleStatusBarPlugin())
        }
    }



    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        if(call.method == "toggleStatusBar") {
            toggleStatusBar(call, result);
            return
        }

        result.notImplemented()
    }

    private fun toggleStatusBar(call: MethodCall, result: Result) {
        if (this.activity == null) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Activity is null cannot hide status bar.")
            result.success(false)
            return
        }

        try {
            val hidden : Boolean? = call.argument<Boolean>("hidden")

            if (hidden!!) {
                this.activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                this.activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
            } else {
                this.activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
                this.activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }

            result.success(true)

        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to hide status bar : $exception")
            result.success(false)
        }




    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}


//package io.playsof.simple_status_bar
//
//import android.app.Activity
//import android.content.Context
//import androidx.annotation.NonNull;
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.embedding.engine.plugins.activity.ActivityAware
//import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
//import io.flutter.plugin.common.BinaryMessenger
//import io.flutter.plugin.common.MethodChannel
//
///** SimpleStatusBarPlugin */
//public class SimpleStatusBarPlugin : FlutterPlugin, ActivityAware {
//    //
//
//    private var channel: MethodChannel? = null
//    private var handler: MethodCallHandlerImpl? = null
//
//    private val CHANNELID : String = "simple_status_bar"
//
//    private var activity: Activity? = null
//
//
//    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
////        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_status_bar")
////        channel.setMethodCallHandler(this)
////        setupChannel(binding.binaryMessenger, binding.applicationContext, null!!)
//    }
//
//    override fun onDetachedFromActivity() {
//        handler?.setActivity(null)
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        onAttachedToActivity(binding)
//    }
//
//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
////        this.activity = binding.activity
//        handler?.setActivity(binding.activity)
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        onDetachedFromActivity()
//    }
//
//
////    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
////
////
////
////        if(call.method == "toggleStatusBar") {
////            toggleStatusBar(call, result);
////            return
////        }
////
////        if (call.method == "onDarkMode") {
////            when (this.activity?.resources?.configuration?.uiMode?.and(Configuration.UI_MODE_NIGHT_MASK)) {
////                Configuration.UI_MODE_NIGHT_NO -> {}
////                Configuration.UI_MODE_NIGHT_YES -> {}
////            }
////            return
////        }
////
////        result.notImplemented()
////    }
//
////    private fun toggleStatusBar(call: MethodCall, result: Result) {
////        if (this.activity == null) {
////            Log.e("SimpleStatusBar", "SimpleStatusBar: Activity is null cannot hide status bar.")
////            result.success(false)
////            return
////        }
////
////        try {
////            val hidden : Boolean? = call.argument<Boolean>("hide")
////
////            if (hidden!!) {
////                this.activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
////                this.activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
////            } else {
////                this.activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
////                this.activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
////            }
////
////            result.success(true)
////
////        } catch (exception: Exception) {
////            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to hide status bar : $exception")
////            result.success(false)
////        }
////
////
////
////
////    }
//
//
//    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//        teardownChannel()
//    }
//
//    private fun setupChannel(messenger: BinaryMessenger, context:Context, activity:Activity) {
//        channel = MethodChannel(messenger, CHANNELID)
//        handler = MethodCallHandlerImpl(context, activity)
//        channel!!.setMethodCallHandler(handler)
//    }
//
//
//    private fun teardownChannel() {
//        channel?.setMethodCallHandler(null)
//        channel = null
//        handler = null
//    }
//
//    companion object {
//        private val CHANNEL_ID = "plugins.flutter.io/quick_actions"
////        fun registerWith(registrar: PluginRegistry.Registrar) {
////            val plugin = QuickActionsPlugin()
////            plugin.setupChannel(registrar.messenger(), registrar.context(), registrar.activity())
////        }
//    }
//
//}
//
//
//
////package io.flutter.plugins.quickactions
////import android.app.Activity
////import android.content.Context
////import io.flutter.embedding.engine.plugins.FlutterPlugin
////import io.flutter.embedding.engine.plugins.activity.ActivityAware
////import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
////import io.flutter.plugin.common.BinaryMessenger
////import io.flutter.plugin.common.MethodChannel
////import io.flutter.plugin.common.PluginRegistry.Registrar
/////** QuickActionsPlugin */
////class QuickActionsPlugin:FlutterPlugin, ActivityAware {
////    private val channel:MethodChannel
////    private val handler:MethodCallHandlerImpl
//
////    fun onAttachedToEngine(binding:FlutterPluginBinding) {
////        setupChannel(binding.getBinaryMessenger(), binding.getApplicationContext(), null!!)
////    }
////    fun onDetachedFromEngine(binding:FlutterPluginBinding) {
////        teardownChannel()
////    }
////    fun onAttachedToActivity(binding:ActivityPluginBinding) {
////        handler.setActivity(binding.getActivity())
////    }
////    fun onDetachedFromActivity() {
////        handler.setActivity(null)
////    }
////    fun onReattachedToActivityForConfigChanges(binding:ActivityPluginBinding) {
////        onAttachedToActivity(binding)
////    }
////    fun onDetachedFromActivityForConfigChanges() {
////        onDetachedFromActivity()
////    }
////    private fun setupChannel(messenger:BinaryMessenger, context:Context, activity:Activity) {
////        channel = MethodChannel(messenger, CHANNEL_ID)
////        handler = MethodCallHandlerImpl(context, activity)
////        channel.setMethodCallHandler(handler)
////    }
////    private fun teardownChannel() {
////        channel.setMethodCallHandler(null)
////        channel = null
////        handler = null
////    }
////    companion object {
////        private val CHANNEL_ID = "plugins.flutter.io/quick_actions"
////        fun registerWith(registrar:Registrar) {
////            val plugin = QuickActionsPlugin()
////            plugin.setupChannel(registrar.messenger(), registrar.context(), registrar.activity())
////        }
////    }
////}
