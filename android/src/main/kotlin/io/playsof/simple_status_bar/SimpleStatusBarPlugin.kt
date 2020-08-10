package io.playsof.simple_status_bar

import android.R.color
import android.animation.ArgbEvaluator
import android.animation.ValueAnimator
import android.app.Activity
import android.content.ComponentCallbacks
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.widget.Toast
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
import java.util.logging.StreamHandler

private const val HIDE_STATUS_BAR_METHOD = "hideStatusBar"
private const val CHANGE_STATUS_BAR_COLOR_METHOD: String = "changeStatusBarColor"
private const val GET_STATUS_BAR_BRIGHTNESS_METHOD : String = "getStatusBarBrightness"
private const val CHANGE_STATUS_BAR_BRIGHTNESS_METHOD: String = "changeStatusBarBrightness"
private const val GET_SYSTEM_UI_MODE: String = "getSystemUiMode"

/** SimpleStatusBarPlugin */
class SimpleStatusBarPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, Activity() {
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

        private const val SHOW_STATUS_BAR_METHOD: String = "showStatusBar"
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
        this.activity.isChangingConfigurations
        Log.e("SimpleStatusBar", "========onAttachedToActivity============>  ${this.activity.isChangingConfigurations}")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }


    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            Companion.SHOW_STATUS_BAR_METHOD -> {
                showStatusBar(call, result)
                return
            }
            HIDE_STATUS_BAR_METHOD -> {
                hideStatusBar(call, result)
                return
            }
            CHANGE_STATUS_BAR_COLOR_METHOD -> {
                changeColor(call, result)
                return
            }
            GET_STATUS_BAR_BRIGHTNESS_METHOD -> {
                getStatusBarBrightness(call, result)
                return
            }
            CHANGE_STATUS_BAR_BRIGHTNESS_METHOD -> {
                changeStatusBarBrightness(call, result)
                return
            }
            GET_SYSTEM_UI_MODE -> {
                getSystemUiMode(call, result)
                return
            }
            else -> {
                result.notImplemented()
            }
        }


    }

    /// Show status bar
    private fun showStatusBar(call: MethodCall, result: Result) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
        val showFlag = this.activity.window.decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_FULLSCREEN.inv()
        this.activity.window.decorView.systemUiVisibility = showFlag
        result.success(true)
//        }
    }

    /// Hide status bar color
    private fun hideStatusBar(call: MethodCall, result: Result) {
        val hideFlag = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_FULLSCREEN
        this.activity.window.decorView.systemUiVisibility = hideFlag
    }

//    @RequiresApi(Build.VERSION_CODES.KITKAT)
//    private fun toggleSB(call: MethodCall, hide : Boolean) {
//        try {
//            val hideFlag = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_FULLSCREEN
//            val showFlag = this.activity.window.decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_FULLSCREEN.inv()
////            this.activity.window.decorView.systemUiVisibility = if (hidden) hideFlag else showFlag
//
//            result.success(true)
//
//        } catch (exception: Exception) {
//            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to hide status bar : $exception")
//            result.success(false)
//        }
//
//    }


    private fun changeColor(call: MethodCall, result: Result) {
        try {

//            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
//            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val isDarkColor: Boolean = call.argument<Boolean>("isDarkColor")!!

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val lightStatusBarFlag: Int = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
                    val darkStatusBarFlag: Int = this.activity.window.decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()
                    this.activity.window.decorView.systemUiVisibility = if (isDarkColor) darkStatusBarFlag else lightStatusBarFlag
                }

                val startColor: Int = this.activity.window.statusBarColor
                val endColor: Int = call.argument<Int>("color")!!

                val valueAnimator: ValueAnimator = ValueAnimator.ofObject(ArgbEvaluator(), startColor, endColor)
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

    /// Get status bar brightness
    private fun getStatusBarBrightness(call: MethodCall, result: Result) {
        Log.e("SSB","Settings.System.SCREEN_BRIGHTNESS : ${Settings.System.SCREEN_BRIGHTNESS}")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Log.e("SSB","this.activity.window.attributes.screenBrightness : ${this.activity.window.statusBarColor}")
        }
//        Settings.System.SCREEN_BRIGHTNESS
//        this.activity.window.attributes.screenBrightness
    }

    /// Change status bar brightness
    private fun changeStatusBarBrightness(call: MethodCall, result: Result) {
        val brightness: Int = call.argument<Int>("brightness")!!
        val animate: Boolean = call.argument<Boolean>("animate")!!

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val lightStatusBarFlag: Int = this.activity.window.decorView.systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
            val darkStatusBarFlag: Int = this.activity.window.decorView.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()
            this.activity.window.decorView.systemUiVisibility = if (brightness == 1) darkStatusBarFlag else lightStatusBarFlag
            result.success(true)
        }
    }


    /// Get system ui mode
    private fun getSystemUiMode(call: MethodCall, result: Result) {
        try {
//
//            Set by Battery Saver (the recommended default option) // MODE_NIGHT_AUTO_BATTERY
//            System default (the recommended default option)       // MODE_NIGHT_FOLLOW_SYSTEM
            when (this.activity.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) {
                Configuration.UI_MODE_NIGHT_NO -> {
                    result.success(1)
                }
                Configuration.UI_MODE_NIGHT_YES -> {
                    result.success(2)
                }
                else -> {
                    result.success(3)
                }
            }

        } catch (exception: Exception) {
            Log.e("SimpleStatusBar", "SimpleStatusBar: Failed to get system theme : $exception")
            result.error("500", "Something went wrong", "")
        }

    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        Log.e("SimpleStatusBar", "========onConfigurationChanged============>  ")
        super.onConfigurationChanged(newConfig)
        when (newConfig.uiMode) {
            Configuration.UI_MODE_NIGHT_YES -> {
                Log.e("SimpleStatusBar", "========UI MODE IS============> ${Configuration.UI_MODE_NIGHT_YES} ")
            }
            Configuration.UI_MODE_NIGHT_NO -> {
                Log.e("SimpleStatusBar", "========UI MODE IS============> ${Configuration.UI_MODE_NIGHT_NO} ")
            }
            else -> {
                Log.e("SimpleStatusBar", "========UI MODE IS============> ${newConfig.uiMode} ")
            }
        }
        if (newConfig.uiMode == Configuration.UI_MODE_NIGHT_YES) {
            Log.e("SimpleStatusBar", "====================> UI_MODE_NIGHT_YES ")
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

}
