package com.caipeiyan.crm.workbench.controller;

import com.caipeiyan.crm.common.Constant.Constant;
import com.caipeiyan.crm.common.Utils.DateUtils;
import com.caipeiyan.crm.common.Utils.UUidUtil;
import com.caipeiyan.crm.common.pojo.ReturnObject;
import com.caipeiyan.crm.settings.pojo.User;
import com.caipeiyan.crm.settings.service.UserService;
import com.caipeiyan.crm.workbench.pojo.Activity;
import com.caipeiyan.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUser();
        request.setAttribute("userList", userList);
        return "workbench/activity/index";
    }
    @RequestMapping("/workbench/activity/createActivity.do")
    public @ResponseBody Object createActivity(Activity activity, HttpSession session){
        //形参可以自动接收并填充请求中的数据，只要前端的属性名和形参中的属性名一致。
        activity.setId(UUidUtil.getUUid());
        User user =(User) session.getAttribute(Constant.USER_INFO);
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateUtils.formatDate(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityService.createActivity(activity);
            if (i>0){
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_SUCCESS);
            }else{
                returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
                returnObject.setMsg("系统繁忙，请稍后再试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constant.RETURN_OBJECT_FLAG_FAIL);
            returnObject.setMsg("系统繁忙，请稍后再试！");
        }
        return returnObject;
    }
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize){
        Map<String,Object> paraMap = new HashMap<>();
        Map<String,Object> resultMap = new HashMap<>();
        paraMap.put("acName", name);
        paraMap.put("acOwner", owner);
        paraMap.put("startDate", startDate);
        paraMap.put("endDate", endDate);
        paraMap.put("startNo", (pageNo-1)*pageSize);
        paraMap.put("pageSize", pageSize);
        List<Activity> resultList = activityService.queryActivityByConditionForPage(paraMap);
        int amount = activityService.queryAmountOfActivity(paraMap);
        resultMap.put("resultList",resultList);
        resultMap.put("amount",amount);
        return resultMap;
    }
}
