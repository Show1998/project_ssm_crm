package com.caipeiyan.crm.common.Utils;

import java.util.UUID;

public class UUidUtil {
    public static String getUUid(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
