package com.caipeiyan.crm.settings.controller;

import com.caipeiyan.crm.common.Constant.Constant;
import com.caipeiyan.crm.common.Utils.DateUtils;
import com.caipeiyan.crm.common.pojo.ReturnObject;
import com.caipeiyan.crm.settings.pojo.User;
import com.caipeiyan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
    public @ResponseBody Object login(String userName, String pwd, String rememberTenDays, HttpServletRequest request, HttpSession session, HttpServletResponse response){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct", userName);
        map.put("loginPwd",pwd);
        User u = userService.checkUsernameAndPwd(map);
        ReturnObject returnObject  = new ReturnObject();
        if(u == null){
            //返回用户名或密码不正确
            returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
            returnObject.setMsg("用户名或密码不正确");
        }else{
            String dateStr = DateUtils.formatDate(new Date());
            //验证账号是否过期，是否锁定，是否ip受限
            if(u.getExpireTime().compareTo(dateStr) < 0){
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
                returnObject.setMsg("账号已过期");
            }else if(u.getLockState().equals("0")){
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
                returnObject.setMsg("账号已锁定");
            }else if( !u.getAllowIps().contains(request.getRemoteAddr())){
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
                returnObject.setMsg("ip地址不正确");
            }else {
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_SUCCESS);
                session.setAttribute(Constant.USER_INFO, u);
                if (rememberTenDays.equals("true")){
                    Cookie c1 = new Cookie("userName", userName);
                    Cookie c2 = new Cookie("pwd", pwd);
                    c1.setMaxAge(10*24*60*60);
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c1);
                    response.addCookie(c2);
                }else {
                    Cookie c1 = new Cookie("userName", userName);
                    Cookie c2 = new Cookie("pwd", pwd);
                    c1.setMaxAge(0);
                    c2.setMaxAge(0);
                    response.addCookie(c1);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;
    }
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        Cookie c1 = new Cookie("userName","1");
        Cookie c2 = new Cookie("pwd", "2");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        session.invalidate();
        return "redirect:/";
    }
}
