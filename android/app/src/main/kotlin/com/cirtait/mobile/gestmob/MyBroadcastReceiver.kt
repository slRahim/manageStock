package com.cirtait.mobile.gestmob

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast

class MyBroadcastReceiver() : BroadcastReceiver() {

    private lateinit var callback: CodeChangeListner

    fun setListener(callback: CodeChangeListner) {
        this.callback = callback;
    }

    override fun onReceive(context: Context, intent: Intent) {
//        Log.e(MainActivity.TAG, "onReceive intent " + intent.action)
//        Log.e(MainActivity.TAG, "onReceive scan " + intent.getStringExtra(ScannerConstants.KEY_EXTRA_SCAN_RESULT))

        if (intent != null && intent.action == ScannerConstants.ACTION_SCAN_CODE_RESULT) {
            val info = intent.getStringExtra(ScannerConstants.KEY_EXTRA_SCAN_RESULT)
            callback.onCodeChange(info)
        }
    }

}