package com.eumji.zblog.aop;

import com.eumji.zblog.mapper.LogMapper;
import com.eumji.zblog.vo.LogInfo;
import com.eumji.zblog.vo.User;
import org.apache.logging.log4j.core.config.Order;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Date;

/**
 * 日志切入类
 * @author EumJi
 * @package com.eumji.zblog.config
 * @name LoggerAspect
 * @date 2017/4/10
 * @time 18:08
 */
@Aspect
@Component
@Order(5)
public class LoggerAspect {
    @Autowired
    private LogMapper logMapper;
    private Logger logger = LoggerFactory.getLogger(LoggerAspect.class);
    @Pointcut("execution(* com.eumji.zblog.controller.*.*(..))")
    public void exceptionLog(){}


    /**
     * 异常切入方法
     * 记录异常到数据库
     * @param joinPoint
     * @param e
     */
    @AfterThrowing(pointcut = "exceptionLog()",throwing = "e")
    public void afterThrowing(JoinPoint joinPoint,Throwable e){
        LogInfo log = new LogInfo();
        ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        if (requestAttributes != null) {
            HttpServletRequest request = requestAttributes.getRequest();
            User user = (User) request.getSession().getAttribute("user");
            if (user!=null) {
                log.setUserId(user.getUsername());
            }
        }
        HttpServletRequest request = requestAttributes.getRequest();
        log.setIp(request.getRemoteAddr());
        log.setMethod(request.getMethod());
        log.setUrl(request.getRequestURL().toString());
        log.setArgs(Arrays.toString(joinPoint.getArgs()));
        log.setClassMethod(joinPoint.getSignature().getDeclaringTypeName()+"."+joinPoint.getSignature().getName());
        log.setException(e.getMessage());
        log.setOperateTime(new Date());
        logger.info(log.toString());
        logMapper.save(log);
    }
}
