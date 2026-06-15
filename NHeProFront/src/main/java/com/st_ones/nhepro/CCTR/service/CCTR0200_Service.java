package com.st_ones.nhepro.CCTR.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCTR.CCTR0200_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0200_Service.java
 * @date 2022.08.29
 * @version 1.0
 * @see
 */
@Service(value = "CCTR0200_Service")
public class CCTR0200_Service extends BaseService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired CCTR0200_Mapper cctr0200_Mapper;
    
    public List<Map<String, Object>> cctr0200_doSearch(Map<String, String> formData) {
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        
        formObj.put("PROGRESS_CD_LIST", Arrays.asList(formData.get("PROGRESS_CD").split(",")));
        
        return cctr0200_Mapper.cctr0200_doSearch(formObj);
    }

}

