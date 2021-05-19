package com.cirtait.mobile.gestmob;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class VolumeSettingReceiver extends BroadcastReceiver {
    private static final String TAG = "VolumeSettingReceiver";
    private static boolean enable = true;

    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "onReceive() with: context = [" + context + "], intent = [" + intent + "]");
        if (!enable) {
            Log.d(TAG, "listener is diabled");
        } else if ("android.settings.SENRAISE_VOLUME_UP".equals(intent.getAction())) {
            ScanIntentService.startScanIntentService(context);
        } else {
            Log.d(TAG, "onReceive: ignored!");
        }
    }

    public static void setEnable(boolean en) {
        enable = en;
    }
}
