package com.eumji.zblog.service;

import com.eumji.zblog.vo.Article;
import com.eumji.zblog.vo.ArticleCustom;
import com.eumji.zblog.vo.Pager;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
* Created by GeneratorFx on 2017-04-11.
*/
public interface ArticleService {


    List<ArticleCustom> articleList(Pager pager);

    /**
     * 获取分页信息
     * @return
     */
    Pager<Article> InitPager();

    int getArticleCount();

    /**
     * 初始化后台管理的article分页信息
     * @param pager 分页对象
     */
    void InitPager(Pager pager);

    /**
     * 条件查询文章
     * @param param
     * @return
     */
    List<Article> loadArticle(Map<String, Object> param);

    /**
     * 更新文章状态
     * @param id
     * @param status
     */
    void updateStatue(Integer id, int status);

    /**
     * 保存文章
     * @param article 文章信息
     * @param tags  文章的标签数组
     * @throws IOException
     */
    void saveArticle(Article article, int[] tags) throws IOException;

    /**
     * 通过id获取文章
     * @param id 文章id
     * @return
     */
    Article getArticleById(Integer id);

    /**
     * 更新文章
     * 1.更新文章
     * 2.删除旧标签
     * 3.添加新标签
     * @param article 文章信息
     * @param tags 标签信息
     */
    void updateArticle(Article article, int[] tags);

    /**
     * 通过id删除文章
     * @param id 文章id
     */
    void deleteArticle(Integer id);

    /**
     * 通过id获取文章的所以信息 包括标签和分类信息
     * @param articleId
     * @return
     */
    ArticleCustom getArticleCustomById(Integer articleId);

    /**
     * 获取上一篇文章信息
     * @param articleId
     * @return
     */
    Article getLastArticle(Integer articleId);

    /**
     * 获取下一篇文章信息
     * @param articleId
     * @return
     */
    Article getNextArticle(Integer articleId);

    /**
     * 增加文章阅读数量
     * @param articleId
     */
    void addArticleCount(Integer articleId);

    /**
     * 最受欢迎的文章
     * @return
     */
    List<ArticleCustom> popularArticle();

    /**
     * 获取文章id
     * @return
     */
    String[] getArticleId();

    /**
     * 关键字查询文章
     * @param keyword 关键字
     * @return
     */
    List<Article> getArticleListByKeywords(String keyword);

    /**
     * 获取归档列表
     * @return
     */
    List<Map> articleArchiveList();
}
