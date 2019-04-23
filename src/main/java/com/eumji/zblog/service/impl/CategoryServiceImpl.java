package com.eumji.zblog.service.impl;

import com.eumji.zblog.mapper.ArticleMapper;
import com.eumji.zblog.mapper.CategoryMapper;
import com.eumji.zblog.service.CategoryService;
import com.eumji.zblog.vo.ArticleCustom;
import com.eumji.zblog.vo.Category;
import com.eumji.zblog.vo.CategoryCustom;
import com.eumji.zblog.vo.Pager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
* Created by GeneratorFx on 2017-04-11.
*/
@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {
    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private ArticleMapper articleMapper;



    @Override
    public List<ArticleCustom> loadArticleByCategory(Pager pager, Integer categoryId) {
        pager.getStart();
        return articleMapper.loadArticleByCategory(pager,categoryId);
    }

    @Override
    public List<CategoryCustom> initCategoryList() {
        return categoryMapper.initCategoryList();
    }

    @Override
    public Category getCategoryById(Integer id) {
        return categoryMapper.getCategoryById(id);
    }

    @Override
    public List<Category> loadCategory(Pager pager, String categoryName) {
        pager.setStart(pager.getStart());
        return categoryMapper.loadCategory(pager,categoryName);
    }

    @Override
    public boolean checkExist(Category category) {
        int count = categoryMapper.checkExist(category);
        if (count > 0){
            return true;
        }
        return false;
    }

    @Override
    public void saveCategory(Category category) {
        categoryMapper.saveCategory(category);
    }

    @Override
    public void updateCategory(Category category) {
        categoryMapper.updateCategory(category);
    }

    @Override
    public void initPage(Pager pager) {
        int count = categoryMapper.initPage(pager);
        pager.setTotalCount(count);
    }

    @Override
    public List<Category> getCategoryList() {
        return categoryMapper.getCategoryList();
    }


    @Override
    public List<ArticleCustom> loadArticleByArchive(String createTime, Pager pager) {
        pager.getStart();
        return articleMapper.loadArticleByArchive(pager,createTime);
    }

    @Override
    public int getArticleCountByCategoryId(Integer categoryId) {
        return categoryMapper.ArticleCatePage(categoryId);
    }

    @Override
    public boolean deleteCategoryById(Integer categoryId) {
        categoryMapper.deleteCategoryById(categoryId);
        articleMapper.updateCategoryId(categoryId);
        return true;
    }

}
