package com.eumji.zblog.task;

import com.eumji.zblog.service.ArticleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 百度推送的工具类
 * 2017年5月22日 将百度推送硬编码改为读配置文件
 * FILE: com.eumji.zblog.task.BaiduTask.java
 * MOTTO:  不积跬步无以至千里,不积小流无以至千里
 * AUTHOR: EumJi
 * DATE: 2017/4/28
 * TIME: 20:23
 */
@Component
public class BaiduTask {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Value("${baidu.task.postUrl}")
    public String POST_URL;

    @Value("${baidu.task.baseUrl}")
    public String BASE_URL;
    @Autowired
    private ArticleService articleService;

    /**
     * 初始化HttpURLConnection
     * @return
     * @throws IOException
     */
    private HttpURLConnection initConnect() throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(POST_URL).openConnection();
        conn.setRequestProperty("Host","data.zz.baidu.com");
        conn.setRequestProperty("User-Agent", "curl/7.12.1");
        conn.setRequestProperty("Content-Length", "83");
        conn.setRequestProperty("Content-Type", "text/plain");
        conn.setDoInput(true);
        conn.setDoOutput(true);
        return conn;
    }

    /**
     * 自动推送任务
     * @throws IOException
     */
    @Scheduled(fixedDelay = 200000)
    public void postArticleUrl() throws IOException {
        String [] ids = articleService.getArticleId();
       writerUrl(initConnect(),ids);

    }

    /**
     * 重构推送文章的write方法
     * @param conn
     * @param ids
     * @throws IOException
     */
    private void writerUrl(HttpURLConnection conn,String... ids) throws IOException {
        PrintWriter out=null;
        BufferedReader bf = null;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ids.length; i++){
            sb.append(BASE_URL+"/article/details/"+ids[i]+"\n");
        }
        logger.info("推送的url为:"+sb.toString());
        conn.connect();
        out=new PrintWriter(conn.getOutputStream());
        out.print(sb.toString().trim());
        out.flush();
        int code = conn.getResponseCode();
        if (code == 200){
            logger.info("the article url push success");
        }

    }

    /**
     * 新增添加文章推送功能
     * @param articleId 文章id
     */
    public void pushOneArticle(String articleId) throws IOException {
        writerUrl(initConnect(),articleId);

    }
}
