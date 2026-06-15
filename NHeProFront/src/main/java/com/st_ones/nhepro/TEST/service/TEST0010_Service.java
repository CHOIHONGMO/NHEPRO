package com.st_ones.nhepro.TEST.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.TEST.TEST0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SVNR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "TEST0010_Service")
public class TEST0010_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired TEST0010_Mapper TEST0010_Mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private MessageService messageService;
    
    
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> test0010_doSave(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {

        	TEST0010_Mapper.test0010_doSave(formData);
        }
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("test0010", "001")); //메세지 없으면 오류남
		  
	    return rtnMap;
    } 
    
    
    public List<Map<String,Object>> test0020P10_doSearch(Map<String, String> formData) throws Exception{
		/*
		 * Map<String, Object> formObj = new HashMap<String, Object>(formData);
		 * formObj.put("PROGRESS_CD_LIST",
		 * Arrays.asList(formData.get("PROGRESS_CD").split(","))); return
		 * TEST0010_Mapper.test0020P10_doSearch(formObj);
		 */
    	
    	Map<String, Object> formObj = new HashMap<String, Object>(formData);
        return TEST0010_Mapper.test0020P10_doSearch(formObj);
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> test0020P10_doSave(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
    	Map<String, String> rtnMap = new HashMap<>();

        for(Map<String, Object> data : grid) {

        	TEST0010_Mapper.test0020P10_doSave(data);
        }
        
        rtnMap.put("rtnMsg", msg.getMessageByScreenId("TEST0020P10", "001")); //메세지 없으면 오류남
		  
	    return rtnMap;
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void test0020P10_doDelete(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> grid : gridData) {
       // 	TEST0010_Mapper.test0020P10_doDeleteECCF(grid);
        	TEST0010_Mapper.test0020P10_doDeleteECCR(grid);
        }
    }
    
    public List<Map<String, Object>> test0030_doSearch(Map<String, String> param) throws Exception {
		return TEST0010_Mapper.test0030_doSearch(param);
	}
    

}
