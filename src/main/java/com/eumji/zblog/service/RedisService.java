package com.eumji.zblog.service;

/**
 * Created by jdd on 2017/11/30.
 */
public interface RedisService {
    void set(String key, Object value);

    Object get(String key);

    void sadd(String key, String... members);

    
}
