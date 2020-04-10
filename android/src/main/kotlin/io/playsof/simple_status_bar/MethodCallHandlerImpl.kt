//package io.playsof.simple_status_bar
//
//import android.app.Activity
//import android.content.Context
//import android.content.Intent
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//
//internal class MethodCallHandlerImpl(private val context: Context, activity:Activity): MethodChannel.MethodCallHandler {
//
//    private var activity:Activity
//
//    init{
//        this.activity = activity
//    }
//
//    fun setActivity(activity: Activity?) {
//        if (activity != null) {
//            this.activity = activity
//        }
//    }
//
//    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
//    }
//
////    fun onMethodCall(call:MethodCall, result:MethodChannel.Result) {
////        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1)
////        {
////            // We already know that this functionality does not work for anything
////            // lower than API 25 so we chose not to return error. Instead we do nothing.
////            result.success(null)
////            return
////        }
////        val shortcutManager = context.getSystemService(Context.SHORTCUT_SERVICE) as ShortcutManager
////        when (call.method) {
////            "setShortcutItems" -> {
////                val serializedShortcuts = call.arguments()
////                val shortcuts = deserializeShortcuts(serializedShortcuts)
////                shortcutManager.setDynamicShortcuts(shortcuts)
////            }
////            "clearShortcutItems" -> shortcutManager.removeAllDynamicShortcuts()
////            "getLaunchAction" -> {
////                if (activity == null)
////                {
////                    result.error(
////                            "quick_action_getlaunchaction_no_activity",
////                            "There is no activity available when launching action", null)
////                    return
////                }
//////                val intent = activity.getIntent()
////                val launchAction = intent.getStringExtra(EXTRA_ACTION)
////                if (launchAction != null && !launchAction.isEmpty())
////                {
////                    shortcutManager.reportShortcutUsed(launchAction)
////                    intent.removeExtra(EXTRA_ACTION)
////                }
////                result.success(launchAction)
////                return
////            }
////            else -> {
////                result.notImplemented()
////                return
////            }
////        }
////        result.success(null)
////    }
//
//
////    @TargetApi(Build.VERSION_CODES.N_MR1)
////    private fun deserializeShortcuts(shortcuts:List<Map<String, String>>):List<ShortcutInfo> {
////        val shortcutInfos = ArrayList<ShortcutInfo>()
////        for (shortcut in shortcuts)
////        {
////            val icon = shortcut["icon"]
////            val type = shortcut["type"]
////            val title = shortcut["localizedTitle"]
////            val shortcutBuilder = ShortcutInfo.Builder(context, type)
////            val resourceId = icon?.let { loadResourceId(context, it) }
////            val intent = type?.let { getIntentToOpenMainActivity(it) }
////            if (resourceId != null) {
////                if (resourceId > 0)
////                {
////                    shortcutBuilder.setIcon(Icon.createWithResource(context, resourceId))
////                }
////            }
////            val shortcutInfo = shortcutBuilder.setLongLabel(title).setShortLabel(title).setIntent(intent).build()
////            shortcutInfos.add(shortcutInfo)
////        }
////        return shortcutInfos
////    }
//
////    private fun loadResourceId(context:Context, icon:String):Int {
////    }
//
//    private fun getIntentToOpenMainActivity(type:String):Intent {
//        val packageName = context.packageName
//        return context
//                .packageManager
//                .getLaunchIntentForPackage(packageName)
//                .setAction(Intent.ACTION_RUN)
//                .putExtra(EXTRA_ACTION, type)
//                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
//    }
//
//    companion object {
//        private val CHANNEL_ID = "plugins.flutter.io/quick_actions"
//        private val EXTRA_ACTION = "some unique action key"
//    }
//
//
//
//}