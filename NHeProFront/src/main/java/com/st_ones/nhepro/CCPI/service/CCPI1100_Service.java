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
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCPI.CCPI1100_Mapper;

@Service(value = "CCPI1100_Service")
public class CCPI1100_Service extends BaseService{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired CCPI1100_Mapper ccpi1100_Mapper;
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
    public void ccpi1100_getBundleContractInfo(EverHttpRequest req, EverHttpResponse resp, Map<String, String> parameterMap) {
    	
    	UserInfo userInfo = UserInfoManager.getUserInfo();
    	
        // 일괄계약번호
        String bundleNum = EverString.nullToEmptyString(parameterMap.get("BUNDLE_NUM"));
        String appDocNum = EverString.nullToEmptyString(parameterMap.get("APP_DOC_NUM"));
        String appDocCnt = EverString.nullToEmptyString(parameterMap.get("APP_DOC_CNT"));
        
        Map<String, String> bundleContractInfo = new HashMap<String, String>();
        bundleContractInfo.putAll(parameterMap);
        
        String progressCd   = "";
        String contractForm = "";
        
        //일괄계약번호가 있을때
        if( !"".equals(bundleNum) || !("".equals(appDocNum) && "".equals(appDocCnt))) {
            bundleContractInfo = ccpi1100_Mapper.ccpi1100_getBundleContractInfo(bundleContractInfo);
            
            progressCd = bundleContractInfo.get("PROGRESS_CD");
            // 결재상신 후 수정 불가능
            if( Integer.parseInt(progressCd) > 4200 ){
                contractForm = ContStringUtil.getHtmlContents(bundleContractInfo.get("CONTRACT_TEXT"),true);
            }
            bundleContractInfo.put("formContents", contractForm);
        }
      
        bundleContractInfo.put("reCont", parameterMap.get("reCont"));
        
        req.setAttribute("form", bundleContractInfo);
    }
    
    
    /**
     * 메인 서식 가져오기
     * @param param
     * @return
     */
    public List<Map<String, Object>> ccpi1100_doSearchMainForm(Map<String, String> param) {
        return ccpi1100_Mapper.ccpi1100_doSearchMainForm(param);
    }
    
    /**
     * 추가서식 가져오기
     * @param param
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> ccpi1100_doSearchAdditionalForm(Map<String, String> param) throws Exception {
        return ccpi1100_Mapper.ccpi1100_doSearchAdditionalForm(param);
    };
    
    // 일괄계약서 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void ccpi1100_doDeleteContract(Map<String, String> formData, List<Map<String, Object>> gridV) throws Exception {
        for(Map<String, Object> grid : gridV) {
            Map<String, String> param = new HashMap<>();
            param.put("CONT_NUM", (String)grid.get("CONT_NUM"));
            param.put("CONT_CNT", String.valueOf(grid.get("CONT_CNT")));
            
         
            ccpi1100_Mapper.ccpi1100_doDeleteTCRL(param); // 계약서식정보
            ccpi1100_Mapper.ccpi1100_doDeleteTCCT(param); // 계약기본정보

        }
    } 

    // 일괄계약서 결재상신 후 처리
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> ccpi1100_doReqSign(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();

        // 1. 임시저장(4200)으로 등록
        Map<String, Object> formData = ccpi1100_doSave(dataForm, gridDataM, gridDataA, gridDataV);
        
        // 2. 결재상신 후 진행상태 및 결재상태 변경
        Map<String, String> param = new HashMap<String, String>();
        param.put("BUNDLE_NUM", (String)formData.get("BUNDLE_NUM"));
        param.put("PROGRESS_CD", "4206");
        param.put("SIGN_STATUS", "P");
        ccpi1100_Mapper.ccpi1100_doUpdateTCCTSignStatus(param);
        
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
            dataForm.put("DOC_TYPE", "TC4");           
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
            ccpi1100_Mapper.ccpi1100_doUpdateApprovalInformation(dataForm);
        }

        return param;
    }
    
    /**
     * 일괄계약서 저장
     * @param formData  화면의 폼데이터
     * @param gridDataM 주서식 그리드 데이터
     * @param gridDataA 부서식 그리드 데이터
     * @param gridDataV 협력회사 그리드 데이터
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccpi1100_doSave(Map<String, String> dataForm, List<Map<String, Object>> gridDataM, List<Map<String, Object>> gridDataA, List<Map<String, Object>> gridDataV) throws Exception {
        return processBundleContract("4200", dataForm, gridDataM, gridDataA, gridDataV);
    }
    
    /**
     * 2021.04.07 추가
     * PDF_ATT_FILE_NUM은 STOCECCM에 저장한다
     * @param param
     */
    public void ccpi1100_doUpdatePdfUUID(Map<String, Object> param) {
        ccpi1100_Mapper.ccpi1100_doUpdatePdfUUID(param);
    }
    
    /*임시저장된 개인근로자 내역 조회*/
    public List<Map<String, Object>> ccpi1100_getSavedEmpListForBundleContract(Map<String, String> formData) {
       // if(formData.get("CONT_TYPE").equals("1310")) {
        	return ccpi1100_Mapper.ccpi1100_getSavedEmpListForBundleContract(formData);
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

            
            formData.put("PROGRESS_CD", progressCd);
            formData.put("FORM_SQ", MAIN_FORM_SQ);
            //empDatum.putAll(formData); //그리드에 필요 폼 정보 담고
            
            formData.put("USER_ID", (String) empDatum.get("USER_ID"));
            formData.put("USER_NM", (String) empDatum.get("USER_NM"));
            formData.put("BIRTH_DATE", (String) empDatum.get("BIRTH_DATE"));
            formData.put("CELL_NUM", (String) empDatum.get("CELL_NUM"));
            formData.put("JIKMU_NAME", (String) empDatum.get("JIKMU_NAME"));
            formData.put("POSITION", (String) empDatum.get("POSITION"));
            formData.put("CONT_DATE", (String) empDatum.get("CONT_DATE"));
            formData.put("CONT_START_DATE", (String) empDatum.get("CONT_START_DATE"));
            formData.put("CONT_END_DATE", (String) empDatum.get("CONT_END_DATE"));
            formData.put("WORK_TIME_START", (String) empDatum.get("WORK_TIME_START_HOUR")+(String) empDatum.get("WORK_TIME_START_MIN"));
            formData.put("WORK_TIME_END", (String) empDatum.get("WORK_TIME_END_HOUR")+(String) empDatum.get("WORK_TIME_END_MIN"));
            formData.put("REST_TIME_START", (String) empDatum.get("REST_TIME_START_HOUR")+(String) empDatum.get("REST_TIME_START_MIN"));
            formData.put("REST_TIME_END", (String) empDatum.get("REST_TIME_END_HOUR")+(String) empDatum.get("REST_TIME_END_MIN"));
            formData.put("REST_TIME", (String) empDatum.get("REST_TIME_HOUR")+(String) empDatum.get("REST_TIME_MIN"));
            formData.put("G_PLACE", (String) empDatum.get("G_PLACE"));
            formData.put("SPECIAL_CONDITION", (String) empDatum.get("SPECIAL_CONDITION"));
            formData.put("DISPATCH_TASK", (String) empDatum.get("DISPATCH_TASK"));
            formData.put("DISPATCH_COMPANY", (String) empDatum.get("DISPATCH_COMPANY"));
            formData.put("CONT_DESC",  (String)gridDataM.get(0).get("FORM_NM")+"_"+(String) empDatum.get("USER_NM"));
            System.out.println("CONT_DESC-----------"+(String)gridDataM.get(0).get("FORM_NM")+"_"+(String) empDatum.get("USER_NM"));
            
            //------------------------급여관련---------------------------------------------------
           
           
            formData.put("BASE_PAY", String.valueOf(empDatum.get("BASE_PAY")));
            formData.put("BASE_PAY_RMKS", (String)(empDatum.get("BASE_PAY_RMKS")));
            
            formData.put("COMU_AS_PAY", String.valueOf(empDatum.get("COMU_AS_PAY")));
            formData.put("COMU_AS_RMKS",(String)(empDatum.get("COMU_AS_RMKS")));
            
            
            formData.put("EXTEND_PAY", String.valueOf(empDatum.get("EXTEND_PAY")));
            formData.put("EXTEND_PAY_RMKS",(String)(empDatum.get("EXTEND_PAY_RMKS")));
            
            
            formData.put("FOOD_PAY", String.valueOf(empDatum.get("FOOD_PAY")));
            formData.put("FOOD_PAY_RMKS", (String)(empDatum.get("FOOD_PAY_RMKS")));
            
            
            formData.put("WORK_PAY", String.valueOf(empDatum.get("WORK_PAY")));
            formData.put("WORK_PAY_RMKS", (String)(empDatum.get("WORK_PAY_RMKS")));
            
            formData.put("ETC_PAY", String.valueOf(empDatum.get("ETC_PAY")));
            formData.put("ETC_PAY_RMKS", (String)(empDatum.get("ETC_PAY_RMKS")));
            
            //----------------------------------------------------------------------------------
            
            //formData.put("CONT_USER_ID",(String)(empDatum.get("CONT_USER_ID")));
            formData.put("ATT_FILE_NUM",(String)(empDatum.get("ATT_FILE_NUM")));
            formData.put("GENDER",(String)(empDatum.get("GENDER")));
            formData.put("K_ADDR",(String)(empDatum.get("K_ADDR")));
            formData.put("G_NAME",(String)(empDatum.get("G_NAME")));
            formData.put("DISPATCH_START_DAY",(String)(empDatum.get("DISPATCH_START_DAY")));
            formData.put("DISPATCH_START_DATE",(String)(empDatum.get("DISPATCH_START_DATE")));
            formData.put("DISPATCH_END_DATE",(String)(empDatum.get("DISPATCH_END_DATE")));
            formData.put("PRE_DISPATCH_START_DATE",(String)(empDatum.get("PRE_DISPATCH_START_DATE")));
            formData.put("PRE_DISPATCH_END_DATE",(String)(empDatum.get("PRE_DISPATCH_END_DATE")));
            formData.put("DISPATCH_REASON",(String)(empDatum.get("DISPATCH_REASON")));
            formData.put("G_ADDR1",(String)(empDatum.get("G_ADDR1")));
            formData.put("G_ADDR2",(String)(empDatum.get("G_ADDR2")));
            formData.put("ORDER_POS",(String)(empDatum.get("ORDER_POS")));
            formData.put("ORDER_NM",(String)(empDatum.get("ORDER_NM")));
            formData.put("WORK_DAY", (String)(empDatum.get("WORK_DAY")));
            formData.put("WORKER_PAY_AMT",String.valueOf(empDatum.get("WORKER_PAY_AMT")));
            formData.put("WORKER_PAY_AMT2",String.valueOf(empDatum.get("WORKER_PAY_AMT2")));
            formData.put("ADMIN1",(String)(empDatum.get("ADMIN1")));
            formData.put("ADMIN2",(String)(empDatum.get("ADMIN2")));
            formData.put("CUST_NAME",(String)(empDatum.get("CUST_NAME")));
            formData.put("SUBCUST_NAME",(String)(empDatum.get("SUBCUST_NAME")));
            
            formData.put("APP_DOC_NUM", (String) empDatum.get("APP_DOC_NUM"));
            formData.put("APP_DOC_CNT", String.valueOf(empDatum.get("APP_DOC_CNT")));
            
            formData.put("CONT_TYPE", (String) empDatum.get("CONT_TYPE"));
            formData.put("JIKJONG_TYPE", (String) empDatum.get("JIKJONG_TYPE"));
            // formData.put("CONTRACT_TEXT", resultContractForm);

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
            
            
            if (StringUtils.isEmpty((String) empDatum.get("CONT_NUM")) && StringUtils.isEmpty((String) empDatum.get("CONT_CNT"))) {        
                ccpi1100_Mapper.ccpi1100_doInsertTCCT(formData);
                ccpi1100_Mapper.ccpi1100_doInsertTCRL(formData);
            	
            }
            else {
                ccpi1100_Mapper.ccpi1100_doUpdateTCCT(formData);
                ccpi1100_Mapper.ccpi1100_doUpdateTCRL(formData);
               
                // 주계약서를 제외한 부서식은 저장 후에 선택을 뺄 수도 있으므로 기존 데이터를 삭제하고 다시 넣는다.
                ccpi1100_Mapper.ccpi1100_doDeleteAddTCRL(formData); // 부서식 내용번호 삭제
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

                ccpi1100_Mapper.ccpi1100_doInsertAddTCRL(datum);
            }
        }

        // 근로자 데이터에 계약번호 넣은 후 리턴
        rtnData.putAll(formData);
        rtnData.put("gridDataV", empList);

        return rtnData;
    }
    
    
    public String ccpi1100_doSelectPdfJsonData(Map<String, String> formData) {
    	System.out.println("pdf+service");
		return ccpi1100_Mapper.ccpi1100_doSelectPdfJsonData(formData); 
	}
    
    
    /**
     * 첨부파일 저장
     * @param formData  화면의 폼데이터
     * @param gridDataV 개인근로자 그리드 데이터
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> ccpi1100_doSavePdf(Map<String, String> formData, List<Map<String, Object>> gridDataV) throws Exception {
        
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
             ccpi1100_Mapper.ccpi1100_doUpdatePdfTCCT(formData);
        }
        
        rtnData.putAll(formData);
        rtnData.put("gridDataV", empList);

        return rtnData;
    	    	 
    }
    
    

}
