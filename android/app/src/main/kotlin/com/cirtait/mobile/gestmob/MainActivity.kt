package com.cirtait.mobile.gestmob


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.internal.view.SupportMenu
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.util.*
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val STREAM = "pda.flutter.dev/scanEvent"
    companion object {
        const val TAG = "Gestmob"
    }
    private val CUSTOMIZED_REQUEST_CODE = SupportMenu.USER_MASK
    var mBarcodeScanner: BarcodeScanner? = null
    private lateinit var eventChannel: EventChannel


    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.MODEL.equals("POS-OS01")) {
            initializeScanner()
        }
    }


    fun initializeScanner() {
        mBarcodeScanner = BarcodeScanner.getInstance(this)
        with(mBarcodeScanner) { this?.initScanner() }
    }

    public override fun onResume() {
        super.onResume()
    }

    public override fun onPause() {
        mBarcodeScanner!!.stopScan()
        super.onPause()
    }

    public override fun onDestroy() {
        mBarcodeScanner!!.destroyScanner()
        super.onDestroy()
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        Log.e(TAG, "onKeyUp: start scan")
        return super.onKeyUp(keyCode, event)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM)
        eventChannel.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, eventSink:EventSink) {
                        val receiver = MyBroadcastReceiver()

                        receiver.setListener(object : CodeChangeListner() {

                            override fun onCodeChange(code: String?) {
                                val code: String ? = code
                                eventSink.success(code)
                            }
                        })

                        val intentFilter: IntentFilter = IntentFilter()
                        intentFilter.addAction(ScannerConstants.ACTION_SCAN_CODE_RESULT)
                        registerReceiver(receiver, intentFilter)

                    }

                    override fun onCancel(p0: Any) {
                    }
                }
        )

    }


}
