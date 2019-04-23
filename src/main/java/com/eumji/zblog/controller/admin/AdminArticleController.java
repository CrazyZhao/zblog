package com.eumji.zblog.controller.admin;

import com.eumji.zblog.service.ArticleService;
import com.eumji.zblog.service.CategoryService;
import com.eumji.zblog.service.TagService;
import com.eumji.zblog.service.UserService;
import com.eumji.zblog.util.ResultInfo;
import com.eumji.zblog.util.ResultInfoFactory;
import com.eumji.zblog.vo.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理 文章controller
 * FILE: com.eumji.zblog.controller.admin.AdminArticleController.java
 * MOTTO:  不积跬步无以至千里,不积小流无以至千里
 * AUTHOR: EumJi
 * DATE: 2017/4/15
 * TIME: 22:00
 */
@Controller
@RequestMapping("/admin/article")
public class AdminArticleController {
    private Logger log = LoggerFactory.getLogger(AdminArticleController.class);
    //文章service
    @Resource
    private ArticleService articleService;

    //标签service
    @Resource
    private TagService tagService;

    //分类service
    @Resource
    private CategoryService categoryService;

    @Resource
    private UserService userService;
    /**
     * 初始化文章分页信息
     * @param pager
     * @return
     */
    @RequestMapping("/initPage")
    @ResponseBody
    public Pager initPage(Pager pager) {
        articleService.InitPager(pager);
        return pager;
    }

    /**
     * 跳转到添加页面
     * @return
     */
    @RequestMapping("/addPage")
    public String addPage() {
        return "admin/article/articleAdd";
    }

    /**
     * 初始化文章列表
     * @param pager 分页对象
     * @param categoryId 搜索条件 分类id
     * @param tagIds 搜索条件 tag集合
     * @param title 搜索条件 文章标题
     * @param model
     * @return
     */
    @RequestMapping("/load")
    public String loadArticle(Pager pager, Integer categoryId, String tagIds, String title, Model model) {
        /**
         * 设置start位置
         */
        pager.setStart(pager.getStart());
        //封装查询条件
        Map<String, Object> param = new HashMap<>();
        if (tagIds != null && !"".equals(tagIds)) {
            param.put("tags", tagIds.split(","));
        }else {
            param.put("tags", null);
        }
        param.put("categoryId", categoryId);
        param.put("title",title);
        param.put("pager", pager);
        //获取文章列表
        List<Article> articleList = articleService.loadArticle(param);
        model.addAttribute("articleList", articleList);
        return "admin/article/articleTable";
    }

    /**
     * 更新文章可用状态
     * @param id
     * @param status
     * @return
     */
    @RequestMapping("/updateStatue")
    @ResponseBody
    public ResultInfo updateStatue(Integer id, int status) {
        try {

            articleService.updateStatue(id, status);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResultInfoFactory.getErrorResultInfo("更新状态失败,请稍后再尝试");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }

    /**
     * 获取条件,所有tag和category
     * @param model
     * @return
     */
    @RequestMapping("/term")
    public String articleTerm(Model model) {
        List<Tag> tagList = tagService.getTagList();
        List<Category> categoryList = categoryService.getCategoryList();
        model.addAttribute("tagList", tagList);
        model.addAttribute("categoryList", categoryList);
        return "admin/article/articleInfo";
    }

    /**
     * 保存文章
     * @param article
     * @param tags
     * @return
     */
    @RequestMapping("/save")
    @ResponseBody
    public ResultInfo saveArticle(Article article, int[] tags){
        try {
            //解码文章内容防止出现部分特殊字符串被转义
            article.setDescription(URLDecoder.decode(article.getDescription(),"UTF-8"));
            article.setTitle(URLDecoder.decode(article.getTitle(),"UTF-8"));
            article.setContent(URLDecoder.decode(article.getContent(),"UTF-8"));
            User user = userService.getCurrentUser();
            article.setAuthor(user.getUsername());
            articleService.saveArticle(article, tags);
        }catch (Exception e){
            log.error(e.getMessage());
            return ResultInfoFactory.getErrorResultInfo("添加失败,请稍后再尝试");
        }
        return ResultInfoFactory.getSuccessResultInfo();

    }

    /**
     * 跳转到编辑页面
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/editJump")
    public String updatePage(Integer id,Model model){
        Article article = articleService.getArticleById(id);
        model.addAttribute("article",article);
        return"admin/article/articleEdit";
    }

    /**
     * 获取更新文章信息
     * @param articleId 文章标题 用于获取文章信息
     * @param model
     * @return
     */
    @RequestMapping("/updateInfo")
    public String updateInfo(Integer articleId,Model model){
        Article article = articleService.getArticleById(articleId);
        List<Category> categoryList = categoryService.getCategoryList();
        List<Tag> tagList = tagService.getTagList();
        model.addAttribute("article",article);
        model.addAttribute("categoryList",categoryList);
        model.addAttribute("tagList",tagList);
        return "admin/article/articleEditInfo";
    }

    /**
     * 更新文章
     * @param article
     * @param tags
     * @return
     */
    @RequestMapping("/update")
    @ResponseBody
    public ResultInfo updateArticle(Article article,int[] tags){
        try {
            //解码文章内容防止出现部分特殊字符串被转义
            article.setDescription(URLDecoder.decode(article.getDescription(),"UTF-8"));
            article.setTitle(URLDecoder.decode(article.getTitle(),"UTF-8"));
            article.setContent(URLDecoder.decode(article.getContent(),"UTF-8"));
            articleService.updateArticle(article,tags);
        }catch (Exception e){
            log.error(e.getMessage());
            ResultInfoFactory.getErrorResultInfo("修改失败,请稍后再试!");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }

    @RequestMapping("/delete/{id}")
    @ResponseBody
    public ResultInfo deleteArticle(@PathVariable Integer id){
        try {

            articleService.deleteArticle(id);
        }catch (Exception e){
            log.error(e.getMessage());
            return ResultInfoFactory.getErrorResultInfo("删除失败!");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }


}