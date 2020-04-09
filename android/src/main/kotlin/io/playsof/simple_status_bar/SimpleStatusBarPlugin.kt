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
        channel.setMethodCallHandler(this);
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