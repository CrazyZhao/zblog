package com.eumji.zblog.service.impl;

import com.eumji.zblog.mapper.UserMapper;
import com.eumji.zblog.vo.User;
import com.eumji.zblog.service.UserService;
import com.eumji.zblog.vo.UserInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by GeneratorFx on 2017-04-11.
 */
@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public User loadUserByUsername(String username) {
        return userMapper.getUser(username);
    }

    @Override
    public UserInfo getUserInfo() {
        return userMapper.getUserInfo();
    }

    @Override
    public void updateAvatar(String url, String username) {
        userMapper.updateAvatar(url,username);
    }

    @Override
    public void updatePassword(User user) {
        userMapper.updatePassword(user);
    }

    @Override
    public void updateUserInfo(UserInfo userInfo) {
        userMapper.updateUserInfo(userInfo);
    }

    @Override
    public User getCurrentUser() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpSession session = request.getSession();
        return (User) session.getAttribute("user");
    }
}


