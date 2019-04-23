package com.eumji.zblog.vo;

import org.apache.ibatis.type.Alias;

import java.io.Serializable;

/**
 * 分类实体
 * @author eumji
 * @package com.eumji.zblog.vo
 * @name Category.java
 * @date 2017/4/12
 * @time 12:34
 */
@Alias("category")
public class Category implements Serializable {

private Integer id;

private String categoryName; //分类名称

private String aliasName;  //分类别名

private Integer sort;

public Integer getId() {
return id;
}

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getAliasName() {
        return aliasName;
    }

    public void setAliasName(String aliasName) {
        this.aliasName = aliasName;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", categoryName='" + categoryName + '\'' +
                ", aliasName='" + aliasName + '\'' +
                ", sort=" + sort +
                '}';
    }
}
