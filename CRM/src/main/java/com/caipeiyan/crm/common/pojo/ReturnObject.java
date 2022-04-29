package com.caipeiyan.crm.common.pojo;

public class ReturnObject {
    private String msg;

    //这是处理获取失败的标记，0表示失败，1表示成功
    private String code;

    //存放任何数据
    private Object retData;

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
