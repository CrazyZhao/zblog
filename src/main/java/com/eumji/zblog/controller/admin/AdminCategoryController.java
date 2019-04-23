package com.eumji.zblog.controller.admin;

import com.eumji.zblog.service.CategoryService;
import com.eumji.zblog.util.ResultInfo;
import com.eumji.zblog.util.ResultInfoFactory;
import com.eumji.zblog.vo.Category;
import com.eumji.zblog.vo.Pager;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;

/**
 * 后台管理的分类controller
 * FILE: com.eumji.zblog.controller.admin.AdminCategoryController.java
 * MOTTO:  不积跬步无以至千里,不积小流无以至千里
 * AUTHOR: EumJi
 * DATE: 2017/4/15
 * TIME: 14:43
 */
@Controller
@RequestMapping("/admin/category")
public class AdminCategoryController {

    @Resource
    private CategoryService categoryService;


    /**
     * 初始化分页信息 获取totalcount
     * @param pager 分页对象
     * @return
     */
    @RequestMapping("/initPage")
    @ResponseBody
    public Pager initPage(Pager pager){
        categoryService.initPage(pager);
        return pager;
    }

    /**
     * 跳转到添加页面
     * @return
     */
    @RequestMapping("/addJump")
    public String addPage(){
        return "admin/category/categoryAdd";
    }

    /**
     * 跳转修改页面
     * @param categoryId 分类id
     * @param model
     * @return
     */
    @RequestMapping("/editJump/{categoryId}")
    public String editPage(@PathVariable Integer categoryId,Model model){
        Category category = categoryService.getCategoryById(categoryId);
        model.addAttribute("category",category);
        return "admin/category/categoryEdit";
    }

    /**
     * 加载分类信息列表
     * @param pager 分页对象
     * @param categoryName  搜索条件
     * @param model
     * @return
     */
    @RequestMapping("/load")
    public String loadCategory(Pager pager ,String categoryName,Model model){
        List<Category> categoryList = categoryService.loadCategory(pager,categoryName);
        model.addAttribute("categoryList",categoryList);
        return "admin/category/categoryTable";
    }


    /**
     * 添加分类信息
     * @param category 分类信息对象
     * @return
     */
    @RequestMapping("/save")
    @ResponseBody
    public ResultInfo saveCateogry(Category category){
        try {
            //解码
            category.setCategoryName(URLDecoder.decode(category.getCategoryName(),"UTF-8"));
            category.setAliasName(URLDecoder.decode(category.getAliasName(),"UTF-8"));
            if (category.getSort()==null){
                category.setSort(0);
            }
            //检查是否已存在
            if (categoryService.checkExist(category)){
                return ResultInfoFactory.getErrorResultInfo("分类名称或别名已存在");
            }else {
                categoryService.saveCategory(category);
            }
        } catch (UnsupportedEncodingException e) {
            return ResultInfoFactory.getErrorResultInfo("文本解析错误,稍后再尝试");
        }catch (Exception e){
            return ResultInfoFactory.getErrorResultInfo("添加失败,请通知管理员");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }

    /**
     * 更新分类信息
     * @param category
     * @return
     */
    @RequestMapping("/update")
    @ResponseBody
    public ResultInfo updateCategory(Category category){

        try {
            //解码
            category.setCategoryName(URLDecoder.decode(category.getCategoryName(),"UTF-8"));
            category.setAliasName(URLDecoder.decode(category.getAliasName(),"UTF-8"));
            if (category.getSort()==null){
                category.setSort(0);
            }
            //检查是否存在
            if (categoryService.checkExist(category)){
                return ResultInfoFactory.getErrorResultInfo("分类的名称或别名已存在");
            }else {
                categoryService.updateCategory(category);
            }
        } catch (UnsupportedEncodingException e) {
            ResultInfoFactory.getErrorResultInfo("字符串解析错误,请稍后在尝试");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }

    /**
     * 删除之前查询是否存在文章
     * @param categoryId
     * @return
     */
    @RequestMapping("/query/{categoryId}")
    @ResponseBody
    public ResultInfo checkExist(@PathVariable Integer categoryId){
        int count = categoryService.getArticleCountByCategoryId(categoryId);
        if (count > 0){
            return ResultInfoFactory.getErrorResultInfo("当前分类已存在文章");
        }
        return ResultInfoFactory.getSuccessResultInfo();
    }

    /**
     * 删除制定id的分类
     * 如果存在文章会将其移动到未分类
     * @param categoryId
     * @return
     */
    @RequestMapping("/delete/{categoryId}")
    @ResponseBody
    public ResultInfo deleteCategory(@PathVariable Integer categoryId){
        boolean flag = categoryService.deleteCategoryById(categoryId);
        if (flag){
            return ResultInfoFactory.getErrorResultInfo("删除分类成功！！！");
        }
        return ResultInfoFactory.getErrorResultInfo();
    }

}
