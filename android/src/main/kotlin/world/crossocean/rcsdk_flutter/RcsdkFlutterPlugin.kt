package world.crossocean.rcsdk_flutter

import android.content.Context
import android.util.Log
import com.skydroid.rcsdk.KeyManager
import com.skydroid.rcsdk.RCSDKManager
import com.skydroid.rcsdk.SDKManagerCallBack
import com.skydroid.rcsdk.common.callback.CompletionCallbackWith
import com.skydroid.rcsdk.common.error.SkyException
import com.skydroid.rcsdk.common.remotecontroller.ControlMode
import com.skydroid.rcsdk.key.RemoteControllerKey
import com.skydroid.rcsdk.key.info.KeyInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Runnable
import kotlinx.coroutines.launch
import java.util.Timer
import java.util.TimerTask

/** RcsdkFlutterPlugin */
class RcsdkFlutterPlugin : FlutterPlugin, MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private val LOGTAG = "RcsdkFlutterPlugin"
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    private var keyChannelsTimer: Timer? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "rcsdk_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

        context?.let {
            RCSDKManager.initSDK(it,object : SDKManagerCallBack {
                override fun onRcConnectFail(e: SkyException?) {
                    Log.d(LOGTAG,"onRcConnectFail")
                }

                override fun onRcConnected() {
                    Log.d(LOGTAG,"onRcConnected")
                }

                override fun onRcDisconnect() {
                    Log.d(LOGTAG,"onRcDisconnect")
                }
            })
        }
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "connectToRC" -> {
                try {
                    RCSDKManager.connectToRC()
                    result.success(null)
                } catch (e: Exception){
                    result.error(LOGTAG,"connectToRC() failed",e)
                }

            }
            "disconnectRC" -> {
                try {
                    RCSDKManager.disconnectRC()
                    result.success(null)
                } catch (e: Exception) {
                    result.error(LOGTAG,"disconnectRC() failed",e)
                }

            }
            "getKeyChannels" -> {
                KeyManager.get(RemoteControllerKey.KeyChannels,object : CompletionCallbackWith<IntArray> {
                    override fun onSuccess(keyResult: IntArray?) {
                        Log.d(LOGTAG,"result: ${keyResult?.contentToString()}")
                        result.success(keyResult)
                    }

                    override fun onFailure(p0: SkyException?) {
                        Log.d(LOGTAG,"获取遥感数值失败")
                        result.error("","获取遥感数值失败","")
                    }
                })
            }
            "startKeyChannelsListen" -> {
                try {
                    startGetKeyChannelsTimer()
                    result.success(null)
                } catch (e: Exception){
                   result.error(LOGTAG,"startKeyChannelsListen failed",e)
                }

            }
            "stopKeyChannelsListen" -> {
                try {
                    keyChannelsTimer?.cancel()
                    keyChannelsTimer = null
                    result.success(null)
                } catch (e: Exception){
                    result.error(LOGTAG,"stopKeyChannelsListen failed",e)
                }

            }
        }
    }


    private var lastKeyChannels: IntArray = intArrayOf()

    private fun startGetKeyChannelsTimer() {
        keyChannelsTimer?.cancel()
        keyChannelsTimer = Timer()
        keyChannelsTimer?.schedule(object : TimerTask(){
            override fun run() {
                KeyManager.get(RemoteControllerKey.KeyChannels,object : CompletionCallbackWith<IntArray> {
                    override fun onSuccess(keyResult: IntArray?) {
                        keyResult?.let {
                            if (!lastKeyChannels.contentEquals(it)) {
                                onKeyChannels(it)
                                lastKeyChannels = it.copyOf()
//                                Log.d(LOGTAG,it.contentToString())
                            }

                        }
                    }

                    override fun onFailure(p0: SkyException?) {
                        Log.d(LOGTAG,"获取遥感数值失败")
                    }
                })
            }

        },0,100)
    }

    private val messageScope: CoroutineScope = CoroutineScope(Dispatchers.Main)

    private fun onKeyChannels(result: IntArray) {
        messageScope.launch {
            channel.invokeMethod("onKeyChannels",result)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        keyChannelsTimer?.cancel()
        keyChannelsTimer = null
    }
}
