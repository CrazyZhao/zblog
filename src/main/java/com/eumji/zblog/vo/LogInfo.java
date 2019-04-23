package com.eumji.zblog.vo;

import org.apache.ibatis.type.Alias;

import java.io.Serializable;
import java.util.Date;

/**
 * 错误日志实体类
 * @author eumji
 * @package com.eumji.zblog.vo
 * @name LogInfo
 * @date 2017/4/10
 * @time 18:14
 */
@Alias("log")
public class LogInfo implements Serializable {

    private String id;

    private String userId; //用户名

    private String url;  //请求的url

    private String ip;  //请求的ip

    private String method;  //http请求的方法

    private String args;  //请求方法的参数

    private String classMethod;  //对应的类方法

    private String exception;  //异常信息

    private Date operateTime;  //操作时间

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getArgs() {
        return args;
    }

    public void setArgs(String args) {
        this.args = args;
    }

    public String getClassMethod() {
        return classMethod;
    }

    public void setClassMethod(String classMethod) {
        this.classMethod = classMethod;
    }

    public String getException() {
        return exception;
    }

    public void setException(String exception) {
        this.exception = exception;
    }

    public Date getOperateTime() {
        return operateTime;
    }

    public void setOperateTime(Date operateTime) {
        this.operateTime = operateTime;
    }

    @Override
    public String toString() {
        return "LogInfo{" +
                "id='" + id + '\'' +
                ", userId='" + userId + '\'' +
                ", url='" + url + '\'' +
                ", ip='" + ip + '\'' +
                ", method='" + method + '\'' +
                ", args='" + args + '\'' +
                ", classMethod='" + classMethod + '\'' +
                ", exception='" + exception + '\'' +
                ", operateTime=" + operateTime +
                '}';
    }
}
