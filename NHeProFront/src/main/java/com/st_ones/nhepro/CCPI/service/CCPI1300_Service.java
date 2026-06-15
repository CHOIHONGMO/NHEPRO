package com.st_ones.nhepro.CCPI.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCPI.CCPI1300_Mapper;

@Service(value = "CCPI1300_Service")
public class CCPI1300_Service {

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired CCPI1300_Mapper ccpi1300_Mapper;
    @Autowired MessageService msg;
    
    @Autowired DocNumService docNumService;
    @Autowired BAPM_Service approvalService;
   // @Autowired private FileAttachService fileAttachService;
   // @Autowired private EverSmsService everSmsService;
   // @Autowired private EverMailService everMailService;

    private static final String MAIN_FORM_SQ = "0";

    
    /**
     * 개인근로자 계약서 계약Header정보 가져오기
     * @param req
     * @param resp
     * @param parameterMap
     */
    public void ccpi1300_getBundleContractInfo(EverHttpRequest req, EverHttpResponse resp, Map<String, String> parameterMap) {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
        // 일괄계약번호
        String bundleNum = EverString.nullToEmptyString(parameterMap.get("BUNDLE_NUM"));
        String appDocNum = EverString.nullToEmptyString(parameterMap.get("APP_DOC_NUM"));
        String appDocCnt = EverString.nullToEmptyString(parameterMap.get("APP_DOC_CNT"));
        
        Map<String, String> bundleContractInfo = new HashMap<String, String>();
        bundleContractInfo.putAll(parameterMap);
        
        String progressCd   = "";
        String contractForm = "";
        
        if( !"".equals(bundleNum) || !("".equals(appDocNum) && "".equals(appDocCnt))) {
            bundleContractInfo = ccpi1300_Mapper.ccpi1300_getBundleContractInfo(bundleContractInfo);
            
            progressCd = bundleContractInfo.get("PROGRESS_CD");
            // 결재상신 후 수정 불가능
            if( Integer.parseInt(progressCd) > 4200 ){
                contractForm = ContStringUtil.getHtmlContents(bundleContractInfo.get("CONTRACT_TEXT"),true);
            }
            bundleContractInfo.put("formContents", contractForm);
        }
        else {
       // 	bundleContractInfo.put("PR_BUYER_CD", userInfo.getCompanyCd());
        //	bundleContractInfo.put("PR_DEPT_CD", userInfo.getDeptCd());
       // 	bundleContractInfo.put("PR_BUYER_DEPT_NM", userInfo.getCompanyNm() + " " + userInfo.getDeptNm());
        	logger.debug("ccpi1300_getBundleContractInfo + 개인근로자 계약번호 else");
        	
        }
        bundleContractInfo.put("reCont", parameterMap.get("reCont"));
        
        req.setAttribute("form", bundleContractInfo);
    }
    
    
    /**
     * 메인 서식 가져오기
     * @param param
     * @return
     */
    public List<Map<String, Object>> ccpi1300_doSearchMainForm(Map<String, String> param) {
        return ccpi1300_Mapper.ccpi1300_doSearchMainForm(param);
    }
    
    /**
     * 추가서식 가져오기
     * @param param
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> ccpi1300_doSearchAdditionalForm(Map<String, String> param) throws Exception {
        return ccpi1300_Mapper.ccpi1300_doSearchAdditionalForm(param);
    };
    
    // 일괄계약서 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccpi1300_doDeleteContract(Map<String, String> formData, List<Map<String, Object>> gridV) throws Exception {
        for(Map<String, Object> grid : gridV) {
            Map<String, String> param = new HashMap<>();
            param.put("CONT_NUM", (String)grid.get("CONT_NUM"));
            param.put("CONT_CNT", String.valueOf(grid.get("CONT_CNT")));
            
           
            ccpi1300_Mapper.ccpi1300_doDeleteTCRL(param); // 계약서식정보
            ccpi1300_Mapper.ccpi1300_doDeleteTCCT(param); // 계약기본정보

        }
    } 

    // 일괄계약서 결재상신 후 처리
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccpi1300_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        // 1. 임시저장(4200)으로 등록
        Map<String, Object> formData = ccpi1300_doSave(dataForm, gridDataM, gridDataA, gridDataV);
        
        // 2. 결재상신 후 진행상태 및 결재상태 변경
        Map<String, String> param = new HashMap<String, String>();
        param.put("BUNDLE_NUM", (String)formData.get("BUNDLE_NUM"));
        param.put("PROGRESS_CD", "4206");
        param.put("SIGN_STATUS", "P");
        ccpi1300_Mapper.ccpi1300_doUpdateTCCTSignStatus(param);
        
        List<Map<String, Object>> vndList = (List<Map<String, Object>>) formData.get("gridDataV");
        for (Map<String, Object> rowData : vndList) {
            String appDocNum = String.valueOf(rowData.get("APP_DOC_NUM"));
            String appDocCnt = String.valueOf(rowData.get("APP_DOC_CNT"));

            if( EverString.isEmpty(appDocNum) || "null".equals(appDocNum)){
                dataForm.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(),"APPDOC"));
            }

            if( EverString.isEmpty(appDocCnt) || "null".equals(appDocCnt) || appDocCnt.equals("0") ){
                appDocCnt = "1";
            } else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }

            dataForm.put("APP_DOC_CNT", appDocCnt);
            dataForm.put("DOC_TYPE", "TC3");           
            dataForm.put("SUBJECT", "[" +rowData.get("USER_NM") +"]" + gridDataM.get(0).get("FORM_NM"));
            
           System.out.println((String) gridDataM.get(0).get("FORM_NM")+"--------------------주서식 명");
           System.out.println((String) gridDataV.get(0).get("CONT_DESC")+"--------------------계약명");
           System.out.println("-----------------------------------------------------------------------");
            
           	dataForm.put("REL_TEXT_NUM", dataForm.get("CONTRACT_TEXT_NUM"));
           	dataForm.put("BUYER_CD", userInfo.getCompanyCd());
            // 일괄계약의 계약번호는 근로자별로 체번한 것을 사용함
            dataForm.put("CONT_NUM", (String)rowData.get("CONT_NUM"));
            dataForm.put("CONT_CNT", String.valueOf(rowData.get("CONT_CNT")));
           
            System.out.println("CONT_NUM----"+rowData.get("CONT_NUM"));
            System.out.println("CONT_CNT----"+rowData.get("CONT_CNT"));
            
            
            String strApprovalFormData = dataForm.get("approvalFormData");
            String strApprovalGridData = dataForm.get("approvalGridData");

            approvalService.doApprovalProcess(dataForm, strApprovalFormData, strApprovalGridData);
            ccpi1300_Mapper.ccpi1300_doUpdateApprovalInformation(dataForm);
        }

        return param;
    }
    /**
     * 일괄계약서 저장
     * @param formData  화면의 폼데이터
     * @param gridDataM 주서식 그리드 데이터
     * @param gridDataA 부서식 그리드 데이터
     * @param gridDataV 개인근로자 그리드 데이터
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccpi1300_doSave(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {
        return processBundleContract("4200", dataForm, gridDataM, gridDataA, gridDataV);
    }
    
    /**
     * 2021.04.07 추가
     * 계약서작성(다수업체)인 경우 PDF_ATT_FILE_NUM은 STOCECCM에 저장한다
     * @param param
     */
    public void ccpi1300_doUpdatePdfUUID(Map<String, Object> param) {
        ccpi1300_Mapper.ccpi1300_doUpdatePdfUUID(param);
    }
    
    /*임시저장된 개인근로자 내역 조회*/
    public List<Map<String, Object>> ccpi1300_getSavedEmpListForBundleContract(Map<String, String> formData) {
       // if(formData.get("CONT_TYPE").equals("1310")) {
        	return ccpi1300_Mapper.ccpi1300_getSavedEmpListForBundleContract(formData);
     //   }
    }
    
    
    /**
     * 일괄계약서의 저장 또는 전송처리 (상태 빼고는 저장과 전송의 처리가 동일 -> 메일 처리는 생각)
     * @param progressCd 진행상태만 다르게 넣어줌
     * @param formData
     * @param gridDataM
     * @param gridDataA
     * @param gridDataV
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> processBundleContract(String progressCd, Map<String, String> formData, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        // 리턴 값
        Map<String, Object> rtnData = new HashMap<String, Object>();
        
        Map<String, Object> map = new HashMap<String, Object>();
       
        
        formData.put("FORM_NUM", (String) gridDataM.get(0).get("FORM_NUM"));
        formData.put("CONT_TYPE", (String) gridDataM.get(0).get("CONTRACT_FORM_TYPE")); // 계약서 종류 (M136 : (1310)근로계약서) 
        
        // 일괄계약번호가 없으면 채번
        if( StringUtils.isEmpty(formData.get("BUNDLE_NUM")) ){
            String bundleNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "BC");
            formData.put("BUNDLE_NUM", bundleNum);
            // 리턴값
            rtnData.put("BUNDLE_NUM", bundleNum);
        }
        
        // 근로자별 계약정보 세팅
        List<Map<String, Object>> empList = new ArrayList<>();

        for (Map<String, Object> empDatum : gridDataV) {

            
        	formData.put("GEUNMU_STS_NAME",(String)empDatum.get("GEUNMU_STS_NAME"));
        	formData.put("CONT_TYPE",(String)empDatum.get("CONT_TYPE"));
        	formData.put("USER_ID",(String)empDatum.get("USER_ID"));
        	formData.put("USER_NM",(String)empDatum.get("USER_NM"));
        	formData.put("BIRTH_DATE",(String)empDatum.get("BIRTH_DATE"));
        	formData.put("GENDER",(String)empDatum.get("GENDER"));
        	formData.put("CELL_NUM",(String)empDatum.get("CELL_NUM"));
        	formData.put("K_ADDR",(String)empDatum.get("K_ADDR"));
        	formData.put("JIKMU_NAME",(String)empDatum.get("JIKMU_NAME"));
        	formData.put("JIKJONG_TYPE", (String) empDatum.get("JIKJONG_TYPE"));
        	formData.put("CONT_DATE",(String)empDatum.get("CONT_DATE"));
        	formData.put("CONT_START_DATE",(String)empDatum.get("CONT_START_DATE"));
        	formData.put("CONT_END_DATE",(String)empDatum.get("CONT_END_DATE"));
        	formData.put("DAY_OR_HOUR_PAY",(String)empDatum.get("DAY_OR_HOUR_PAY"));
        	formData.put("WORKER_PAY_AMT", String.valueOf(empDatum.get("WORKER_PAY_AMT")));
        	formData.put("G_PLACE",(String)empDatum.get("G_PLACE"));
        	formData.put("WORK_TIME",(String)empDatum.get("WORK_TIME_HOUR")+(String)empDatum.get("WORK_TIME_MIN"));
        	formData.put("REST_TIME",(String)empDatum.get("REST_TIME_HOUR")+(String)empDatum.get("REST_TIME_MIN"));
        	formData.put("SPECIAL_CONDITION",(String)empDatum.get("SPECIAL_CONDITION"));
        	formData.put("WORK_CONDITION", (String) empDatum.get("WORK_CONDITION"));
        	formData.put("REST_CONDITION", (String) empDatum.get("REST_CONDITION"));
        	formData.put("EDU_DATE",(String)empDatum.get("EDU_DATE"));
        	formData.put("EDU_TIME_START",(String)empDatum.get("EDU_TIME_START_HOUR") + (String)empDatum.get("EDU_TIME_START_MIN"));
        	formData.put("EDU_TIME_END",(String)empDatum.get("EDU_TIME_END_HOUR")+(String)empDatum.get("EDU_TIME_END_MIN"));
        	formData.put("EDU_HOUR",(String)empDatum.get("EDU_HOUR"));
        	formData.put("EDU_PLACE",(String)empDatum.get("EDU_PLACE"));
        	formData.put("EDU_PLACE_RMKS",(String)empDatum.get("EDU_PLACE_RMKS"));
        	formData.put("EDU_WAY",(String)empDatum.get("EDU_WAY"));
        	formData.put("EDU_WAY_RMKS",(String)empDatum.get("EDU_WAY_RMKS"));
        	formData.put("TH_NAME",(String)empDatum.get("TH_NAME"));
        	formData.put("ADMIN3",(String)empDatum.get("ADMIN3"));
        	formData.put("BUSINESS",(String)empDatum.get("BUSINESS"));
        	formData.put("CONT_NUM",(String)empDatum.get("CONT_NUM"));
        	formData.put("PROGRESS_CD",(String)empDatum.get("PROGRESS_CD"));
        	formData.put("EMP_ATT_FILE_CNT",(String)empDatum.get("EMP_ATT_FILE_CNT"));
        	formData.put("EMP_ATT_FILE_NUM",(String)empDatum.get("EMP_ATT_FILE_NUM"));


        	formData.put("CUST_NAME",(String)(empDatum.get("CUST_NAME")));
            formData.put("SUBCUST_NAME",(String)(empDatum.get("SUBCUST_NAME")));
            
        	formData.put("PROGRESS_CD", progressCd);
        	formData.put("FORM_SQ", MAIN_FORM_SQ);
        	//formData.put("SIGN_STATUS","T");
        	formData.put("CONT_DESC",  (String)gridDataM.get(0).get("FORM_NM")+"_"+(String) empDatum.get("USER_NM"));
            //주서식 처리 
            String largeTextNum = formData.get("CONTRACT_TEXT_NUM");
            if( EverString.isEmpty(EverString.replace(largeTextNum, " ", "")) ){
                largeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            } else {
                formData.put("CONTRACT_TEXT_NUM", largeTextNum);
            }

            /* PK가 없으면 insert 한다. */
            String contNum = "";
            String contCnt = "1";
            if (StringUtils.isEmpty((String) empDatum.get("CONT_NUM")) && StringUtils.isEmpty((String) empDatum.get("CONT_CNT"))) {
                contNum = docNumService.getDocNumber(userInfo.getCompanyCd(),"TC");
                contCnt = "1";
            } else {
                contNum = (String) empDatum.get("CONT_NUM");
                contCnt = String.valueOf(empDatum.get("CONT_CNT"));
            }
            formData.put("CONT_NUM", contNum);
            formData.put("CONT_CNT", contCnt);
            
            //계약정보 저장
            if (StringUtils.isEmpty((String) empDatum.get("CONT_NUM")) && StringUtils.isEmpty((String) empDatum.get("CONT_CNT"))) {        
                ccpi1300_Mapper.ccpi1300_doInsertTCCT(formData);
                ccpi1300_Mapper.ccpi1300_doInsertTCRL(formData);
            	
            }
            else {
                ccpi1300_Mapper.ccpi1300_doUpdateTCCT(formData);
                ccpi1300_Mapper.ccpi1300_doUpdateTCRL(formData);
               
                // 주계약서를 제외한 부서식은 저장 후에 선택을 뺄 수도 있으므로 기존 데이터를 삭제하고 다시 넣는다.
                ccpi1300_Mapper.ccpi1300_doDeleteAddTCRL(formData); // 부서식 내용번호 삭제
            }

            Map<String, Object> empMap = new HashMap<String, Object>();
            empMap.put("USER_ID",   formData.get("USER_ID"));
            empMap.put("USER_NM",   formData.get("USER_NM"));
            empMap.put("CONT_NUM",    formData.get("CONT_NUM"));
            empMap.put("CONT_CNT",    formData.get("CONT_CNT"));
            empMap.put("APP_DOC_NUM", formData.get("APP_DOC_NUM"));
            empMap.put("APP_DOC_CNT", formData.get("APP_DOC_CNT"));
            empList.add(empMap);

            // 부서식 처리
            System.out.println("---------------gridDataA 크기 ---------------------------");
            System.out.println("-------------------"+gridDataA.size()+"------------------------------");
            for (int i = 0; i < gridDataA.size(); i++) {
                Map<String, Object> datum = gridDataA.get(i);
                datum.put("CONT_NUM", formData.get("CONT_NUM"));
                datum.put("CONT_CNT", formData.get("CONT_CNT"));
                
                String subLargeTextNum  = (String) datum.get("CONTRACT_TEXT_NUM");
                if( EverString.isEmpty(EverString.replace(subLargeTextNum, " ", "")) ){
                    subLargeTextNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "TN");
                    datum.put("CONTRACT_TEXT_NUM", subLargeTextNum);
                } else {
                    datum.put("CONTRACT_TEXT_NUM", subLargeTextNum);
                }

                ccpi1300_Mapper.ccpi1300_doInsertAddTCRL(datum);
            }
        }

        // 근로자 데이터에 계약번호 넣은 후 리턴
        rtnData.putAll(formData);
        rtnData.put("gridDataV", empList);

        return rtnData;
    }

    public String ccpi1300_doSelectPdfJsonData(Map<String, String> formData) {
    	System.out.println("pdf+service");
		return ccpi1300_Mapper.ccpi1300_doSelectPdfJsonData(formData); 
	}
    
    
    /**
     * 첨부파일 저장
     * @param formData  화면의 폼데이터
     * @param gridDataV 개인근로자 그리드 데이터
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccpi1300_doSavePdf(Map<String, String> formData, List<Map<String, Object>> gridDataV) throws Exception {
        
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
    	// 근로자별 계약정보 첨부파일 추가
    	List<Map<String, Object>> empList = new ArrayList<>();
    	// 리턴 값
        Map<String, Object> rtnData = new HashMap<String, Object>();

        for (Map<String, Object> empDatum : gridDataV) {
        	
        	 formData.put("EMP_ATT_FILE_NUM", (String) empDatum.get("EMP_ATT_FILE_NUM"));
             formData.put("EMP_ATT_FILE_CNT", (String) empDatum.get("EMP_ATT_FILE_CNT"));
             
             String contNum = (String) empDatum.get("CONT_NUM");
             String contCnt = String.valueOf(empDatum.get("CONT_CNT"));
             formData.put("CONT_NUM", contNum);
             formData.put("CONT_CNT", contCnt);
             formData.put("CONT_TYPE", (String) empDatum.get("CONT_TYPE"));
             ccpi1300_Mapper.ccpi1300_doUpdatePdfTCCT(formData);
        }
        
        rtnData.putAll(formData);
        rtnData.put("gridDataV", empList);

        return rtnData;
    	    	 
    }
}

