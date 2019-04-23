package com.eumji.zblog.mapper;


import com.eumji.zblog.vo.Article;
import com.eumji.zblog.vo.ArticleCustom;
import com.eumji.zblog.vo.Pager;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
* Created by GeneratorFx on 2017-04-11.
*/
@Mapper
public interface ArticleMapper {

    int getArticleCount();

    List<ArticleCustom> getArticleList(Pager pager);

    List<ArticleCustom> loadArticleByCategory(@Param("pager") Pager pager, @Param("categoryId") Integer categoryId);

    /**
     * 通过tagid分页获取当前tag下的文章列表
     * @param pager
     * @param tagId
     * @return
     */
    List<ArticleCustom> loadArticleByTag(@Param("pager")Pager pager, @Param("tagId") Integer tagId);


    int initPage(Pager pager);

    List<Article> loadArticle(Map<String, Object> param);

    void updateStatue(@Param("id") Integer id, @Param("status") int status);

    void saveArticle(Article article);

    void saveArticleTag(@Param("articleId") Integer articleId,@Param("tags") int[] tags);

    int checkExist(Integer id);

    Article getArticleById(Integer id);

    void updateArticle(Article article);

    void deleteArticleTag(Integer articleId);

    void deleteArticle(Integer id);

    ArticleCustom getArticleCustomById(Integer id);

    /**
     * 获取上一篇文章
     * @param id
     * @return
     */
    Article getLastArticle(Integer id);

    /**
     * 获取下一篇文章
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
     * 十篇受欢迎的文章
     * @return
     */
    List<ArticleCustom> popularArticle();

    /**
     * 获取文章id数组
     * @return
     */
    String[] getArticleId();

    /**
     * 通过关键字获取文章
     * @param keyword
     * @return
     */
    List<Article> getArticleListByKeywords(@Param("keyword") String keyword);

    /**
     * 获取时间归档信息
     * @return
     */
    List<Map> articleArchiveList();

    /**
     * 通过时间归档查询文章
     * @param pager
     * @param createTime
     * @return
     */
    List<ArticleCustom> loadArticleByArchive(@Param("pager") Pager pager, @Param("createTime") String createTime);

    /**
     * 更新分类id
     * 设置为9999
     * 用于删除分类并且存在文章的时候
     * @param categoryId
     */
    void updateCategoryId(Integer categoryId);

}
