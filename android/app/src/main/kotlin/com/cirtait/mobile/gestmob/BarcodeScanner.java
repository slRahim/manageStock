package com.cirtait.mobile.gestmob;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import com.cirtait.mobile.gestmob.serialport.SerialPort;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class BarcodeScanner {
    private static final String TAG = "BarcodeScanner";
    private static final int TYPE_KEY_ON = 4;
    private static final int TYPE_KEY_RESET = 3;
    private static final int TYPE_POWER_DOWN = 2;
    private static final int TYPE_POWER_UP = 1;
    private static Context mContext;
    private boolean isBeep;
    private boolean isMultipleDecode;
    private boolean isScanDecode;
    private boolean isStart;
    private boolean isVibrate;
    @SuppressLint({"HandlerLeak"})
    private Handler mHandler;
    private InputStream mInputStream;
    private OutputStream mOutputStream;
    private ScanCodeCallback mScanCodeCallback;
    private SerialPort mSerialPort;


    public class ReceiverThread extends Thread {
        private ReceiverThread() {
        }

        public void run() {
            boolean isValid = true;
            while (BarcodeScanner.this.isStart && BarcodeScanner.this.mInputStream != null) {
                byte[] buffer = new byte[1024];
                try {
                    int size = BarcodeScanner.this.mInputStream.read(buffer);
                    if (size > 0) {
                        boolean isValid2 = false;
                        int i = 0;
                        while (true) {
                            if (i >= size) {
                                break;
                            } else if (buffer[i] != 0) {
                                isValid2 = true;
                                break;
                            } else {
                                i++;
                            }
                        }
                        if (isValid2) {
                            if (size <= 2) {
                                isValid = false;
                            }
                            if (isValid) {
                                byte[] data = new byte[size];
                                System.arraycopy(buffer, 0, data, 0, size);
                                String result = new String(data);
                                String hexStr = ByteUtil.bytes2HexString(data);
                                int index = result.lastIndexOf("\r\n");
                                if (index != -1) {
                                    result = result.substring(0, index);
                                }
//                                Log.e(BarcodeScanner.TAG, "result: " + result);
//                                Log.e(BarcodeScanner.TAG, "data hexStr: " + hexStr);
                                if (BarcodeScanner.this.mScanCodeCallback != null) {
                                    BarcodeScanner.this.mScanCodeCallback.scanCodeResult(result);
                                }
                            }
                            if (BarcodeScanner.this.isScanDecode && BarcodeScanner.this.isMultipleDecode && BarcodeScanner.this.mSerialPort != null) {
                                BarcodeScanner.this.startScan();
                            }else{
                                BarcodeScanner.this.stopScan();
                            }
                        }
                        isValid = true;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }


    public static class BarcodeScannerHolder {
        private static final BarcodeScanner INSTANCE = new BarcodeScanner();

        private BarcodeScannerHolder() {
        }
    }

    private BarcodeScanner() {
        this.isBeep = true;
        this.isVibrate = false;
        this.isMultipleDecode = false;
        this.mHandler = new Handler() {
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case 1:
                        BarcodeScanner.this.scannerPowerUp();
                        BarcodeScanner.this.mHandler.sendEmptyMessage(4);
                        return;
                    case 2:
                        BarcodeScanner.this.scannerPowerDown();
                        return;
                    case 3:
                        BarcodeScanner.this.scannerKeyReset();
                        return;
                    case 4:
                        BarcodeScanner.this.scannerKeyOn();
                        BarcodeScanner.this.mHandler.sendEmptyMessageDelayed(3, 200);
                        return;
                    default:
                        return;
                }
            }
        };
    }

    public static BarcodeScanner getInstance(Context context) {
        mContext = context.getApplicationContext();
        return BarcodeScannerHolder.INSTANCE;
    }

    public void setDecodeCallback(ScanCodeCallback callback) {
        this.mScanCodeCallback = callback;
    }

    public void setBeepEnabled(boolean beep) {
        this.isBeep = beep;
    }

    public void setVibrateEnabled(boolean vibrate) {
        this.isVibrate = vibrate;
    }

    public void setMultipleDecodeEnabled(boolean multiple) {
        this.isMultipleDecode = multiple;
    }

    public void startScan() {
        this.isScanDecode = true;
        this.mHandler.sendEmptyMessage(1);
    }

    public void stopScan() {
        this.isScanDecode = false;
        scannerPowerDown();
    }

    public void initScanner() {
        openSerialPort();
        if (this.mSerialPort != null) {
            this.isStart = true;
            new ReceiverThread().start();
        }
    }

    public void destroyScanner() {
        this.isStart = false;
        if (this.mHandler != null) {
            this.mHandler.removeCallbacksAndMessages(null);
        }
        try {
            if (this.mInputStream != null) {
                this.mInputStream.close();
                this.mInputStream = null;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            if (this.mOutputStream != null) {
                this.mOutputStream.close();
                this.mOutputStream = null;
            }
        } catch (IOException e2) {
            e2.printStackTrace();
        }
        if (this.mSerialPort != null) {
            this.mSerialPort.close();
            this.mSerialPort = null;
        }
        scannerPowerDown();
    }

    private void openSerialPort() {
        try {
            this.mSerialPort = new SerialPort(new File("/dev/ttyHSL1"), 9600, 0);
            this.mInputStream = this.mSerialPort.getInputStream();
            this.mOutputStream = this.mSerialPort.getOutputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void scannerPowerDown() {
//        Log.e(TAG, "扫码头下电");
        save("/sys/scan/scanner_pwr", "0");
    }

    private void scannerPowerUp() {
//        Log.e(TAG, "扫码头上电");
        save("/sys/scan/scanner_pwr", "1");
    }

    private void scannerKeyReset() {
//        Log.e(TAG, "扫码头归位");
        save("/sys/scan/scanner_key", "0");
    }

    private void scannerKeyOn() {
//        Log.e(TAG, "触发扫码头");
        save("/sys/scan/scanner_key", "1");
    }

    private void save(String fileName, String data) {
        FileOutputStream fileOutputStream = null;
        BufferedOutputStream bufferedOutputStream = null;
        try {
            fileOutputStream = new FileOutputStream(new File(fileName), true);
            bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
            bufferedOutputStream.write(data.getBytes());
            bufferedOutputStream.flush();

            if (fileOutputStream != null) {
                fileOutputStream.close();
            }

            if (bufferedOutputStream != null) {
                fileOutputStream.close();
            }

        }
        catch (IOException e3) {
            e3.printStackTrace();
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
                } catch (IOException e4) {
                    e4.printStackTrace();
                }
            }
            if (bufferedOutputStream != null) {
                try {
                    bufferedOutputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        catch (Throwable th) {
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
                } catch (IOException e5) {
                    e5.printStackTrace();
                }
            }
            if (bufferedOutputStream != null) {
                try {
                    bufferedOutputStream.close();
                } catch (IOException e6) {
                    e6.printStackTrace();
                }
            }
            throw th;
        }
    }
}
