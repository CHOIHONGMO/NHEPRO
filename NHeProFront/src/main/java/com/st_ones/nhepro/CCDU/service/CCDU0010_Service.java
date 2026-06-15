package com.st_ones.nhepro.CCDU.service;

import com.st_ones.nhepro.CCDU.CCDU0010_Mapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCDU0010_Service.java
 * @date 2020.07.05
 * @version 1.0
 * @see
 */
@Service(value = "CCDU0010_Service")
public class CCDU0010_Service {
    /**
     * The CCDU0010_Mapper.
     */
    @Autowired
    CCDU0010_Mapper ccdu0010_Mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;

    public List<Map<String, Object>> ccdu0010_doSearch(Map<String, String> formData) {
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        return ccdu0010_Mapper.ccdu0010_doSearch(formObj);
    }
    
    public List<Map<String, Object>> ccdu0010_getCust(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = ccdu0010_Mapper.ccdu0010_getCust(param);
		return rtnList;
	}
    
    public List<Map<String, Object>> ccdu0020_doSearch(Map<String, String> formData) {
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        formObj.put("CTRL_CD_LIST", Arrays.asList(formData.get("CTRL_CD").split(",")));
        return ccdu0010_Mapper.ccdu0020_doSearch(formObj);
    }

    public List<Map<String, Object>> ccdu0030_doSearch(Map<String, String> formData) {
        Map<String, Object> formObj = new HashMap<String, Object>(formData);
        return ccdu0010_Mapper.ccdu0030_doSearch(formObj);
    }
}
