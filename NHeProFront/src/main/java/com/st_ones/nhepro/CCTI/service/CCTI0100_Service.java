package com.st_ones.nhepro.CCTI.service;

import com.st_ones.nhepro.CCTI.CCTI0100_Mapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.info.UserInfoManager;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : CCTI0100_Service.java
 * @date 2020.07.05
 * @version 1.0
 * @see
 */
@Service(value = "CCTI0100_Service")
public class CCTI0100_Service {
	
    @Autowired CCTI0100_Mapper ccti0100_Mapper;
    @Autowired MessageService msg;
    @Autowired DocNumService docNumService;

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    public List<Map<String,Object>> ccti0100_doSearch(Map<String, String> param) throws Exception {
    	
        return ccti0100_Mapper.ccti0100_doSearch(param);
    }
    
    public List<Map<String,Object>> ccti0100_doSearchMTGL(Map<String, String> param) throws Exception {
    	
        return ccti0100_Mapper.ccti0100_doSearchMTGL(param);
    }

	/**
	 * 화면명 : 수기계약서 등록 (CCTI0100)
	 * 처리내용 : 수기 계약서를 등록하고, 발주서를 작성중 상태로 만듬
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccti0100_doSave(Map<String, String> param, List<Map<String, Object>> gridData) throws Exception {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
    	String progressCd = param.get("PROGRESS_CD");
    	if( StringUtils.isEmpty(progressCd) ) {
        	progressCd = "4200";
        }
    	
        for (Map<String, Object> grid : gridData) {
        	
        	if( grid.get("CONT_NUM") == null || "".equals(grid.get("CONT_NUM")) ) {
	        	grid.put("CONT_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "EC"));
	        	grid.put("CONT_CNT", "1");
        	}
            grid.put("PROGRESS_CD", progressCd);
            
            // 1. STOCECCT 등록
        	ccti0100_Mapper.ccti0100_doSaveECCT(grid);
        	
            // 2. STOCECCM 등록
            ccti0100_Mapper.ccti0100_doDeleteECCM(grid);
            ccti0100_Mapper.ccti0100_doInsertECCM(grid);
        	
            // 3. STOCECMT는 계약대기현황에서 수기계약작성시 자동으로 등록되므로 별도로 등록하지 않음
            
            // 4. 진행상태(계약완료 : 4300), 발주서 등록(작성중 : 100)
            String poCreateFlag = String.valueOf(grid.get("PO_CREATE_FLAG"));
            if( StringUtils.isNotEmpty(progressCd) && "4300".equals(progressCd) ) {
            	// 2021.01.25 계약완료 후 구매진행상태=4300(계약완료)
            	ccti0100_Mapper.setPrProgressCd(grid);
            	
            	if( StringUtils.isNotEmpty(poCreateFlag) && "1".equals(poCreateFlag) ) {
	            	grid.put("PO_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "PO"));
	            	
	            	ccti0100_Mapper.ccti0100_doInsertPohd(grid);
	                ccti0100_Mapper.ccti0100_doInsertPodt(grid);
            	}
            }
        }
    }
    
    /**
	 * 화면명 : 수기계약서 삭제 (CCTI0100)
	 * 처리내용 : 임시저장중인 수기계약서 삭제
	 * 경로 : 계약관리 > 전자계약 > 수기계약서등록
	 */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccti0100_doDelete(List<Map<String, Object>> gridData) throws Exception {
    	
        for (Map<String, Object> grid : gridData) {
            // 1. STOCECHB 복원
            ccti0100_Mapper.ccti0100_doChangeECHB(grid);
            // 2. STOCECMT 삭제
        	ccti0100_Mapper.ccti0100_doDeleteECMT(grid);
            // 3. STOCECCM 삭제
            ccti0100_Mapper.ccti0100_doDeleteECCM(grid);
            // 4. STOCECCT 삭제
            ccti0100_Mapper.ccti0100_doDeleteECCT(grid);
        }
    }

}
