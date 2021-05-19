package com.cirtait.mobile.gestmob;

import android.annotation.SuppressLint;
import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.annotation.Nullable;


public class ScanIntentService extends IntentService{
    private static final String TAG = "ScanIntentService";
    private BarcodeScanner mBarcodeScanner;


    public static void startScanIntentService(Context context) {
        context.startService(new Intent(context, ScanIntentService.class));
    }

    public ScanIntentService() {
        super(TAG);
    }

    public void onCreate() {
        super.onCreate();
        this.mBarcodeScanner = BarcodeScanner.getInstance(this);
        this.mBarcodeScanner.initScanner();
    }

    public void onStart(Intent intent, int startId) {
        super.onStart(intent, startId);
        this.mBarcodeScanner.setBeepEnabled(true);
        this.mBarcodeScanner.setVibrateEnabled(false);
        this.mBarcodeScanner.setMultipleDecodeEnabled(false);
        this.mBarcodeScanner.setDecodeCallback(new ScanCodeCallback() {
            @Override
            public void scanCodeResult(String str) {
                codeResult(str) ;
            }
        });
        this.mBarcodeScanner.startScan();
    }

    public void onHandleIntent(@Nullable Intent intent) {
    }

    public void onDestroy() {
        super.onDestroy();
    }

    private void codeResult(String s) {
        Log.e(TAG, "scanCodeResult service: " + s);
        Intent intent = new Intent(ScannerConstants.ACTION_SCAN_CODE_RESULT);
        intent.putExtra(ScannerConstants.KEY_EXTRA_SCAN_RESULT, s);
        sendBroadcast(intent);
    }
}

