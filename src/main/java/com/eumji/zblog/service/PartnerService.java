package com.eumji.zblog.service;

import com.eumji.zblog.vo.Pager;
import com.eumji.zblog.vo.Partner;
import java.util.List;

/**
* Created by GeneratorFx on 2017-04-10.
*/
public interface PartnerService {

    List<Partner> findAll();

    void savePartner(Partner partner);

    /**
     * 分页查询好友列表
     * @param pager
     * @param param
     * @return
     */
    List<Partner> loadPartner(Pager pager, String param);

    Partner getPartnerById(Integer id);

    void deletePartner(Integer id);

    void updatePartner(Partner partner);

    void initPage(Pager pager);
}
