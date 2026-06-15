package com.st_ones.nhepro.OVNR.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.OVNR.OVNR0030_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OVNR0030_Service.java
 * @date 2020. 09. 16.
 * @version 1.0
 */

@Service(value = "OVNR0030_Service")
public class OVNR0030_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired OVNR0030_Mapper ovnr0030_mapper;

    /**
     * 화면명 : 신규업체대기현황
     */
    public List<Map<String, Object>> ovnr0030_doSearch(Map<String, String> param) {
    	
        return ovnr0030_mapper.ovnr0030_doSearch(param);
    }

    // 반려
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ovnr0030_doReject(List<Map<String, Object>> gridDatas) throws Exception {
    	
    	for(Map<String, Object> gridData : gridDatas) {
            ovnr0030_mapper.ovnr0030_doReject(gridData);
    	}
        return msg.getMessage("0058");
    }

}
