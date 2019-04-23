package com.eumji.zblog.mapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * 分页的mapper
 * @author EumJi
 * @package com.eumji.zblog.mapper
 * @name PagerMapper.java
 * @date 2017/4/13
 * @time 9:07
 */
@Mapper
public interface PagerMapper {
    /**
     * 找到目标分类下的分页条件
     * @param categoryId
     * @return
     */
    int loadCategoryPager(Integer categoryId);

    /**
     * 通过tagId获取文章总数量
     * @param tagId
     * @return
     */
    int loadTagPager(Integer tagId);
}
