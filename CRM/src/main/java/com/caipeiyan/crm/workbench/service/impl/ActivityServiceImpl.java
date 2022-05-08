package com.caipeiyan.crm.workbench.service.impl;

import com.caipeiyan.crm.workbench.mapper.ActivityMapper;
import com.caipeiyan.crm.workbench.pojo.Activity;
import com.caipeiyan.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int createActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }
}
