package fun_.zhcode.ithome_lite

import android.os.Bundle
import fun_.zhcode.ithome_lite.FlutterMethod.encryDES
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "fun_.zhcode/ithome_lite"

    @ExperimentalUnsignedTypes
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "encryDES") {
                result.success(encryDES(call.arguments as String))
            } else {
                result.notImplemented()
            }
        }
    }
}
