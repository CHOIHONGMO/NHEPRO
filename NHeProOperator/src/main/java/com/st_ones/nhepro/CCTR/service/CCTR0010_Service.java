package com.st_ones.nhepro.CCTR.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0010_Service.java
 * @date 2020.04.13
 * @version 1.0
 * @see
 */
@Service(value = "CCTR0010_Service")
public class CCTR0010_Service {
    /**
     * The CCTR0010_Mapper.
     */
    @Autowired
    CCTR0010_Mapper cctr0010_Mapper;
    /**
     * The Msg.
     */
    @Autowired MessageService msg;
    /**
     * The Doc num service.
     */
    @Autowired DocNumService docNumService;

    @Autowired LargeTextService largeTextService;

    @Autowired BAPM_Service eApprovalService;

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  >  >
	 */
    public List<Map<String,Object>> cctr0010_doSearch(Map<String, String> param) throws Exception{
    	
    	String relatYN = cctr0010_Mapper.ccti0011_getRelatYN(param);
    	param.put("relatYN", relatYN);
        return cctr0010_Mapper.cctr0010_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0010_doCopy(List<Map<String, Object>> gridData) throws Exception {
        UserInfo userInfo = UserInfoManager.getUserInfo();

        for (Map<String, Object> grid : gridData) {
            String textNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
            grid.put("NEW_FORM_TEXT_NUM", textNo);

            String formNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "FORMNO");
            grid.put("NEW_FORM_NUM", formNum);

            cctr0010_Mapper.cctr0010_doCopyECCF(grid);
            cctr0010_Mapper.cctr0010_doCopyECCR(grid);
        }
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0010_doUpdate(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> grid : gridData) {
            cctr0010_Mapper.cctr0010_doUpdateECCF(grid);
        }
    }
    
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void cctr0010_doDelete(List<Map<String, Object>> gridData) throws Exception {
        for (Map<String, Object> grid : gridData) {
            cctr0010_Mapper.cctr0010_doDeleteECCF(grid);
            cctr0010_Mapper.cctr0010_doDeleteECCR(grid);
        }
    }

    public Map<String, String> ccti0011_doSearch(Map<String, String> param) {
        Map<String, String> searchInfo = cctr0010_Mapper.ccti0011_doSearch(param);

        //String formText = cctr0010_Mapper.ccti0011_doSearchFormText(param);
        //searchInfo.put("FORM_TEXT", formText.replaceAll("&#37;", "%").replaceAll("&#39;", "\'"));

        return searchInfo;
    }

    public List<Map<String, Object>> ccti0011_doSearchECCR(Map<String, String> param) {
    	
    
    	String relatYN = cctr0010_Mapper.ccti0011_getRelatYN(param);
    	param.put("relatYN", relatYN);
        return cctr0010_Mapper.ccti0011_doSearchECCR(param);
    }

    // 서식 저장 및 결재상신
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccti0011_doSave(Map<String, String> formData, List<Map<String, Object>> grid) throws Exception {
        UserInfo userInfo = UserInfoManager.getUserInfo();

        // CLOB 처리
        String textNo = formData.get("FORM_TEXT_NUM");
        if (EverString.isEmpty(textNo)) {
            textNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
            formData.put("FORM_TEXT_NUM", textNo);
        }

        String formNum = formData.get("FORM_NUM");
        if (StringUtils.isEmpty(formNum)) {
            formNum = docNumService.getDocNumber("1000", "FORMNO");
            formData.put("FORM_NUM", formNum);
            cctr0010_Mapper.ccti0011_doInsertForm(formData);
        } else {
            cctr0010_Mapper.ccti0011_doUpdateForm(formData);
        }

        for (Map<String, Object> gridData : grid) {
            boolean isSelected = false;
            if (String.valueOf(gridData.get("SELECTED")).equals("1")) {
                isSelected = true;
            }

            if (gridData.get("FORM_NUM") == null) {
                gridData.put("FORM_NUM", "");
            }

            boolean hasFormNo = EverString.isNotEmpty(String.valueOf(gridData.get("FORM_NUM")));
            
            
            if (hasFormNo && isSelected) {
                cctr0010_Mapper.newFormRegistrationDoUpdateGridData(gridData);
            } else if (hasFormNo && !isSelected) {
                cctr0010_Mapper.newFormRegistrationDoDeleteGridData(gridData);
            } else if (!hasFormNo && isSelected) {
                gridData.put("FORM_NUM", formNum);
                int existCount = cctr0010_Mapper.newFormRegistrationGetExistCount(gridData);
                if (existCount == 0) {
                    cctr0010_Mapper.newFormRegistrationDoInsertGridData(gridData);
                } else if (existCount == 1) {
                    gridData.put("updateRelFormSeq", "true");
                    cctr0010_Mapper.newFormRegistrationDoUpdateGridData(gridData);
                } else {
                    throw new NoResultException("Unexpected Case");
                }
            } else if (!hasFormNo && !isSelected) {
                continue;
            } else {
                throw new NoResultException("Unexpected Case");
            }
        }

        // 결재상신하기
        if( "1".equals(formData.get("APP_USE_FLAG")) ){
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
            }
            String appDocCnt = formData.get("APP_DOC_CNT");
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            } else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }

            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("DOC_TYPE", "FORMNO"); // 서식관리
            formData.put("SUBJECT", formData.get("FORM_NM"));
            formData.put("SIGN_STATUS", "P");

            String strApprovalFormData = formData.get("approvalFormData");
            String strApprovalGridData = formData.get("approvalGridData");

            eApprovalService.doApprovalProcess(formData, strApprovalFormData, strApprovalGridData);
            cctr0010_Mapper.doUpdateSignInfo(formData);
            // approvalService.sendDoApprovalNotice(formData, strApprovalGridData);
        }
        
        // 확정저장처리
        if( "1".equals(formData.get("SAVE_END_FLAG")) ){
        	formData.put("APP_DOC_NUM", ""); 
        	formData.put("APP_DOC_CNT", "");
            formData.put("SIGN_STATUS", "E");        	
            
            cctr0010_Mapper.doUpdateSignInfo(formData);        	
        }
        
        

        return formNum;
    }
    
    public String ccti0011_getRelatYN(Map<String, String> param) {
    	        
        return cctr0010_Mapper.ccti0011_getRelatYN(param);
    }    
}
