package io.playsof.simple_status_bar

import android.R.color
import android.animation.ArgbEvaluator
import android.animation.ValueAnimator
import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.util.Log
import android.view.View
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** SimpleStatusBarPlugin */
class SimpleStatusBarPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    //

    private lateinit var activity: Activity
    private lateinit var context: Context


    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = SimpleStatusBarPlugin()
            instance.activity = registrar.activity()
            instance.onAttachedToEngine(registrar.context(), registrar.messenger())
        }
    }

    fun onAttachedToEngine(context: Context, binaryMessenger: BinaryMessenger) {
        this.context = context
        val channel = MethodChannel(binaryMessenger, "simple_status_bar")
        channel.setMethodCallHandler(this)
    }


    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }


    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {


        if (call.method == "toggleStatusBar") {
            toggleStatusBar(call, result)
            return
        }

        if (call.method == "getSystemTheme") {
            getSystemTheme(call, result)
            return
        }

        if (call.method == "changeColor") {
            changeColor(call, result)
            return
        }


        result.notImplemented()
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun toggleStatusBar(call: MethodCall, result: Result) {
        try {
            val hidden: Boolean = call.argument<Boolean>("hide")!!

            val hideFlag = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_FULLSCREEN
            val showFlag = this.activity.window.decorView.systemUiVisibility and  View.SYSTEM_UI_FLAG_FULLSCREEN.inv()
            this.activity.window.decorView.systemUiVisibility = if (hidden)  hideFlag else showFlag

            result.success(true)

        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to hide status bar : $exception")
            result.success(false)
        }

    }

    private fun getSystemTheme(call: MethodCall, result: Result) {
        try {
//            MODE_NIGHT_AUTO_BATTERY
            when (this.activity.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) {
                Configuration.UI_MODE_NIGHT_NO -> {
                    result.success(1)
                    return
                } // Night mode is not active, we're using the light theme
                Configuration.UI_MODE_NIGHT_YES -> {
                    result.success(2)
                    return
                }
                else -> {
                    result.error("404", "Not found", "")
                }
            }

        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to get system theme : $exception")
            result.error("500", "Something went wrong", "")
        }


    }

    private fun changeColor(call: MethodCall, result: Result) {
        try {

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val isDarkColor: Boolean = call.argument<Boolean>("isDarkColor")!!

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ) {
                    val lightStatusBarFlag : Int = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
                    val darkStatusBarFlag: Int = this.activity.window.decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()
                    this.activity.window.decorView.systemUiVisibility = if (isDarkColor)  darkStatusBarFlag else lightStatusBarFlag
                }

                val startColor: Int = this.activity.window.statusBarColor
                val endColor: Int = call.argument<Int>("color")!!

                val valueAnimator : ValueAnimator = ValueAnimator.ofObject(ArgbEvaluator(), startColor, endColor)
                valueAnimator.addUpdateListener {
                    this.activity.window.statusBarColor = valueAnimator.animatedValue as Int
                }
                valueAnimator.setDuration(300).startDelay = 0
                valueAnimator.start()

            } else {
                result.error("500", "Device not supported", "")
            }
//
        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to get system theme : $exception")
            result.error("500", "Something went wrong", "")
        }
    }

    private fun styleWith(call: MethodCall, result: Result) {
        try {


        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar Exception : $exception")
            result.error("500", "Something went wrong", "")
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
