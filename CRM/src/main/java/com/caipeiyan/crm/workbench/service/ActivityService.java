package com.caipeiyan.crm.workbench.service;

import com.caipeiyan.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int createActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryAmountOfActivity(Map<String,Object> map);

    int deleteActivityById(String[] ids);
}
