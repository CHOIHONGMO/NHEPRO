package com.st_ones.nhepro.CCTR.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCTR.CCTR0150_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0150_Service.java
 * @date 2021.06.23
 * @version 1.0
 * @see
 */
@Service(value = "CCTR0150_Service")
public class CCTR0150_Service extends BaseService {
	
    @Autowired
    CCTR0150_Mapper cctr0150_Mapper;
    
    @Autowired
    MessageService msg;

    public List<Map<String,Object>> cctr0150_doSearch(Map<String, String> param) throws Exception {
    	
        return cctr0150_Mapper.cctr0150_doSearch(param);
    }
    
    public List<Map<String, Object>> cctr0150_doSearchECMT(Map<String, String> formData) throws Exception {
        
    	return cctr0150_Mapper.cctr0150_doSearchECMT(formData);
    }
    
    public String cctr0150_doSave(List<Map<String, Object>> gridData) throws Exception {
    	
	    for (Map<String, Object> grid : gridData) {
	    	cctr0150_Mapper.cctr0150_doSave(grid);
	    }
	    return msg.getMessage("0001");
    }
    
}

