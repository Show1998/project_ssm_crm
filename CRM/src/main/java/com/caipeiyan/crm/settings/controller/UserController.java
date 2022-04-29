package com.caipeiyan.crm.settings.controller;

import com.caipeiyan.crm.common.pojo.ReturnObject;
import com.caipeiyan.crm.settings.pojo.User;
import com.caipeiyan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @Autowired
    UserService userService;

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String userName, String pwd, int rememberTenDays, HttpServletRequest request){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct", userName);
        map.put("loginPwd",pwd);
        User u = userService.checkUsernameAndPwd(map);
        ReturnObject returnObject  = new ReturnObject();
        if(u == null){
            //返回用户名或密码不正确
            returnObject.setCode("0");
            returnObject.setMsg("用户名或密码不正确");
        }else{
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
            //验证账号是否过期，是否锁定，是否ip受限
            if(u.getExpireTime().compareTo(sf.format(new Date())) < 0){
                returnObject.setCode("0");
                returnObject.setMsg("账号已过期");
            }else if(u.getLockState().equals("0")){
                returnObject.setCode("0");
                returnObject.setMsg("账号已锁定");
            }else if( !u.getAllowIps().contains(request.getRemoteAddr())){
                returnObject.setCode("0");
                returnObject.setMsg("ip地址不正确");
            }else {
                returnObject.setCode("1");
            }
        }
        return returnObject;
    }
}
