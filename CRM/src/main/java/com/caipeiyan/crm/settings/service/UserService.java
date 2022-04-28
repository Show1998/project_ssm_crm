package com.caipeiyan.crm.settings.service;

import com.caipeiyan.crm.settings.pojo.User;
import org.springframework.stereotype.Service;

import java.util.Map;

public interface UserService {

    User checkUsernameAndPwd(Map<String,Object> map);
}
