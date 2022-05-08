package com.caipeiyan.crm.settings.service.impl;

import com.caipeiyan.crm.settings.mapper.UserMapper;
import com.caipeiyan.crm.settings.pojo.User;
import com.caipeiyan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    UserMapper userMapper;
    @Override
    public User checkUsernameAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByUsernameAndPwd(map);
    }

    @Override
    public List<User> queryAllUser() {
        return userMapper.selectAllUsers();
    }
}
