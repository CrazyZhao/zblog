package com.eumji.zblog.mapper;

import com.eumji.zblog.vo.Pager;
import com.eumji.zblog.vo.Partner;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
* Created by GeneratorFx on 2017-04-10.
*/
@Mapper
public interface PartnerMapper {

    /**
     * 查询所以的友情链接
     * @return
     */
    List<Partner> findAll();

    /**
     * 添加一个友情链接
     * @param partner
     */
    void savePartner(Partner partner);

    /**
     * 分页查询好友列表
     * @param pager 分页条件
     * @param param
     * @return
     */
    List<Partner> loadPartner(@Param("pager")Pager pager, @Param("param") String param);

    /**
     * 通过id获取友情链接
     * @param id
     * @return
     */
    Partner getPartnerById(Integer id);

    /**
     * 删除一条友链
     * @param id
     */
    void deletePartner(Integer id);

    /**
     * 更新友链
     * @param partner
     */
    void updatePartner(Partner partner);

    /**
     * 获取友链数量
     * @param pager
     * @return
     */
    int initPage(Pager pager);
}
