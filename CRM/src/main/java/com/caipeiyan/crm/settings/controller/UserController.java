package com.caipeiyan.crm.settings.controller;

import com.caipeiyan.crm.settings.pojo.User;
import com.caipeiyan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    public @ResponseBody Object login(String userName, String pwd, int rememberTenDays){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct", userName);
        map.put("loginPwd",pwd);
        User u = userService.checkUsernameAndPwd(map);
        if(u == null){

        }
        return null;
    }
}
