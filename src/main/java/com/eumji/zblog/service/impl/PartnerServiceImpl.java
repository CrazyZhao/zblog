package com.eumji.zblog.service.impl;

import com.eumji.zblog.mapper.PartnerMapper;
import com.eumji.zblog.service.PartnerService;
import com.eumji.zblog.vo.Pager;
import com.eumji.zblog.vo.Partner;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by GeneratorFx on 2017-04-10.
 */
@Service
@Transactional
public class PartnerServiceImpl implements PartnerService {

    @Resource
    private PartnerMapper partnerMapper;


    @Override
    public List<Partner> findAll() {
        return partnerMapper.findAll();
    }

    @Override
    public void savePartner(Partner partner) {
        partnerMapper.savePartner(partner);
    }

    @Override
    public List<Partner> loadPartner(Pager pager, String param) {
        pager.setStart(pager.getStart());
        return partnerMapper.loadPartner(pager,param);
    }

    @Override
    public Partner getPartnerById(Integer id) {
        return partnerMapper.getPartnerById(id);
    }

    @Override
    public void deletePartner(Integer id) {
        partnerMapper.deletePartner(id);
    }

    @Override
    public void updatePartner(Partner partner) {
        partnerMapper.updatePartner(partner);
    }

    @Override
    public void initPage(Pager pager) {
        int count = partnerMapper.initPage(pager);
        pager.setTotalCount(count);
    }

}
