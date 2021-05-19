package com.cirtait.mobile.gestmob;

import java.math.BigInteger;

public class ByteUtil {
    public static String bytes2HexString(byte[] bytes) {
        return new BigInteger(1, bytes).toString(16);
    }
}
