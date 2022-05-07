package com.caipeiyan.crm.settings.interceptor;

import com.caipeiyan.crm.common.Constant.Constant;
import com.caipeiyan.crm.settings.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user = (User) request.getSession().getAttribute(Constant.USER_INFO);
        if (user == null){
            //没有登陆，需要跳转到登陆页面
            response.sendRedirect(request.getContextPath());
            return false;
        }else return true;
    }
}
