package com.eumji.zblog.util;

import com.eumji.zblog.vo.UserInfo;

/**
 * 获取错误信息的工具类
 * FILE: com.eumji.zblog.util.UserInfoUtil.java
 * MOTTO:  不积跬步无以至千里,不积小流无以至千里
 * AUTHOR: EumJi
 * DATE: 2017/4/9
 * TIME: 15:39
 */
public class ResultInfoFactory {
    public static ResultInfo ERROR_RESULT ;
    public static ResultInfo SUCCESS_RESULT;

    /**
     * 带错误信息错误信息相应体
     * @param errorInfo
     * @return
     */
    public static ResultInfo getErrorResultInfo(String errorInfo){
        if (ERROR_RESULT == null){
            ERROR_RESULT = new ResultInfo("fail",errorInfo);
        }else{
            ERROR_RESULT.setErrorInfo(errorInfo);
        }
        return ERROR_RESULT;
    }

    /**
     * 不带参数错误信息相应体
     * 默认为错误信息为操作失败
     * @return
     */
    public static ResultInfo getErrorResultInfo(){
        return getErrorResultInfo("操作失败！！！");
    }

    /**
     * 带参数正确的实体相应题
     * @param errorInfo
     * @return
     */
    public static ResultInfo getSuccessResultInfo(String errorInfo){
        if (SUCCESS_RESULT == null){
            SUCCESS_RESULT = new ResultInfo("success",errorInfo);
        }else{
            SUCCESS_RESULT.setErrorInfo(errorInfo);
        }
        return SUCCESS_RESULT;
    }

    /**
     * 不带参数正确的信息相应体
     * 默认为错误信息为操作成功
     * @return
     */
    public static ResultInfo getSuccessResultInfo(){
        return getSuccessResultInfo("操作成功！！！");
    }


    public static ResultInfo getSuccessData(UserInfo userInfo) {
        ResultInfo successResultInfo = getSuccessResultInfo();
        successResultInfo.setObject(userInfo);
        return successResultInfo;
    }


}
