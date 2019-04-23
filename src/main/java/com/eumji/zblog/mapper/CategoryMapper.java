package com.eumji.zblog.mapper;


import com.eumji.zblog.vo.Category;
import com.eumji.zblog.vo.CategoryCustom;
import com.eumji.zblog.vo.Pager;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 分类的mapper接口
* Created by GeneratorFx on 2017-04-11.
*/
@Mapper
public interface CategoryMapper {

    /**
     * 初始化分类信息
     *
     * @return
     */
    List<CategoryCustom> initCategoryList();

    /**
     * 通过id获取分类
     * @param id
     * @return
     */
    Category getCategoryById(Integer id);

    /**
     * 分页获取文章列表
     * @param pager
     * @param categoryName
     * @return
     */
    List<Category> loadCategory(@Param("pager") Pager pager, @Param("categoryName") String categoryName);

    /**
     * 检查是否存在
     * @param category
     * @return
     */
    int checkExist(Category category);

    /**
     * 保存分类
     * @param category
     */
    void saveCategory(Category category);

    /**
     * 更新分类
     * @param category
     */
    void updateCategory(Category category);

    /**
     * 初始化分页信息
     * @param pager
     * @return
     */
    int initPage(Pager pager);

    /**
     *获取分类集合
     * @return
     */
    List<Category> getCategoryList();

    /**
     * 获取当前id的文章数量
     *
     * @param categoryId
     * @return
     */
    int ArticleCatePage(int categoryId);

    /**
     * 删除分类
     * @param categoryId 分类id
     */
    void deleteCategoryById(Integer categoryId);
}
