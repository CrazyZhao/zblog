package com.eumji.zblog.controller;

import com.eumji.zblog.service.CategoryService;
import com.eumji.zblog.service.PartnerService;
import com.eumji.zblog.vo.ArticleCustom;
import com.eumji.zblog.vo.Pager;
import com.eumji.zblog.vo.Partner;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import java.util.List;

/**
 * 展示的分类controller
 * FILE: com.eumji.zblog.controller.ArchiveController.java
 * MOTTO:  不积跬步无以至千里,不积小流无以至千里
 * AUTHOR: EumJi
 * DATE: 2017/5/8
 * TIME: 15:15
 */
@Controller
@RequestMapping("/categories")
public class CategoryController {

    @Resource
    CategoryService categoryService;
    @Resource
    PartnerService  partnerService;

    /**
     * 获取某个标签的分页文章
     * @param model
     * @param pager
     * @param categoryId
     * @return
     */
    @RequestMapping("/load/{categoryId}")
    public String loadArticleByCategory(Model model, Pager pager, @PathVariable Integer categoryId){
        List<ArticleCustom> articleList = categoryService.loadArticleByCategory(pager,categoryId);
        if (!articleList.isEmpty()){
            model.addAttribute("articleList",articleList);
            model.addAttribute("pager",pager);
            model.addAttribute("categoryName",articleList.get(0).getCategoryName());
        }
        return "blog/part/categorySummary";
    }

    /**
     * 跳转到分类的页面 暂时停用
     * @param model
     * @param categoryId
     * @return
     */
    @Deprecated
    @RequestMapping("/details/{categoryId}")
    public String categoryPage(Model model,@PathVariable Integer categoryId){
        List<Partner> partnerList = partnerService.findAll();
        model.addAttribute("partnerList",partnerList);
        model.addAttribute("categoryId",categoryId);
        return "category";
    }



}
