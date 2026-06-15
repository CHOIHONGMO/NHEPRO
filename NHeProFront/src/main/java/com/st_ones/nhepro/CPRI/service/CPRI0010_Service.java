package com.st_ones.nhepro.CPRI.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.config.service.EverConfigService;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.eApproval.eApprovalModule.BAPM_Mapper;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CPRI.CPRI0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CPRI0010_Service.java
 * @date 2020. 03. 20.
 * @version 1.0
 */
@Service(value = "cpri0010_Service")
public class CPRI0010_Service extends BaseService {

    @Autowired private LargeTextService largeTextService;

    @Autowired private EverConfigService everConfigService;

    @Autowired private DocNumService docNumService;

    @Autowired private FileAttachService fileAttachService;

    @Autowired private MessageService msg;

    @Autowired private BAPM_Service approvalService;

    @Autowired private BAPM_Mapper bapm_mapper;

//  @Autowired private AutoPOService autoPOService;

//  @Autowired private DH3030_Service dh3030_service;

    @Autowired private CPRI0010_Mapper cpri_Mapper;

    @Autowired private EverSmsService eversmsservice;


    /**
     * 화면명 : 구매의뢰등록
     * 처리내용 : 구매의뢰서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 구매의뢰 > 구매의뢰등록
     */
    public Map<String, String> getPrFormData(Map<String, String> parameterMap) {
        return cpri_Mapper.getPrFormData(parameterMap);
    }

    public Map<String, String> getPrManualRegInitData(BaseInfo userInfo) throws Exception {
        return cpri_Mapper.getPrManualRegInitData(new HashMap<String, String>());
    }
    
    public List<Map<String, Object>> getPrGridData(Map<String, String> paramMap) throws IOException {

        List<Map<String, Object>> prdtData = cpri_Mapper.getPrGridData(paramMap);
        // 2021.04.16 삭제
        //List<Map<String, Object>> prsiData = new ArrayList<Map<String, Object>>();
        //getPrdtPrsiData(prdtData, prsiData);

        return prdtData;
    }

    public List<Map<String, Object>> getPrGridData2(List<Map<String, String>> prList) throws Exception {

        List<Map<String, Object>> prdtData = new ArrayList<Map<String, Object>>();
        //List<Map<String, Object>> prsiData = new ArrayList<Map<String, Object>>();
        for(Map<String, String> pr : prList) {
        	
            List<Map<String, Object>> prdtList = cpri_Mapper.getPrGridData(pr);
            if(prdtList.size() > 0) { prdtData.add(prdtList.get(0)); }
            
            //List<Map<String, Object>> prsiList = new ArrayList<Map<String, Object>>();
            //if(prsiList.size() > 0) { prsiData.add(prsiList.get(0)); }
        }
        
        // 2021.04.16 삭제
        //getPrdtPrsiData(prdtData, prsiData);
        
        return prdtData;
    }
    
    /**
     * 구매의뢰 저장
     * @param formData
     * @param gridData
     * @param signStatus
     * @return
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> cpri0010_doSave(Map<String, String> formData, List<Map<String, Object>> gridData, String signStatus) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
        
        String oldSignStatus = "";
        HashMap<String, String> hashMap = new HashMap<String, String>();
        if( EverString.isNotEmpty(formData.get("PR_NUM")) ) {
        	
            oldSignStatus = EverString.nullToEmptyString(cpri_Mapper.getSignStatus(formData));
            // PRHD의 진행상태 체크(P, E인 경우 수정안됨)
            if( oldSignStatus.equals("P") || oldSignStatus.equals("E") ) {
            	hashMap.put("BUYER_CD", formData.get("BUYER_CD"));
            	hashMap.put("PR_NUM", formData.get("PR_NUM"));
                hashMap.put("message", msg.getMessage("0047"));
                //return hashMap;
            }
            
            // 2021.04.21 변경
            // PRDT의 진행상태 체크(2100[구매담당자 접수대기] 초과인 경우 수정안됨)
            // STOCPRDT의 품목별 진행상태 가져오기
            int maxProgressCode = cpri_Mapper.getMaxProgressCode(formData);
            if( maxProgressCode > 2100 ) {
            	hashMap.put("BUYER_CD", formData.get("BUYER_CD"));
                hashMap.put("PR_NUM", formData.get("PR_NUM"));
                hashMap.put("message", msg.getMessage("0044"));
                return hashMap;
            }
        }
        else {
            formData.put("COMPANY_CD", userInfo.getCompanyCd());
            formData.put("BUYER_CD", userInfo.getCompanyCd());
        }
        
        formData.put("RMK_TEXT_NUM", largeTextService.saveLargeText(formData.get("RMK_TEXT_NUM"), formData.get("RMK")));

        // 결재요청인 경우 STOCSCTM 테이블에 등록 후, STOCPRHD, STOCPRDT에 임시저장(SIGN_STATUS = 'T')
        String appDocCnt = formData.get("APP_DOC_CNT");
        if( signStatus.equals("P") ) {
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
            }
            
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            }
            else {
                appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
            }
            
            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("DOC_TYPE", "PR");
            
            // 결재요청
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
        }
        
        // 구매의뢰 신규등록
        if (EverString.isEmpty(formData.get("PR_NUM"))) {
            // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
            String prNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "PR");
            formData.put("PR_NUM", prNo);
            
            // STOCPRHD 등록
            cpri_Mapper.prRegistrationInsertFormData(formData);
            
            // STOCPRDT 등록
            for (Map<String, Object> prdtData : gridData) {
                prdtData.put("BUYER_CD", formData.get("BUYER_CD"));
                prdtData.put("PR_NUM", formData.get("PR_NUM"));
                prdtData.put("PR_SQ", cpri_Mapper.getPrSeq(prdtData));
                
                if (signStatus.equals("E")) {
                    prdtData.put("PR_SIGN_STATUS", signStatus);
                }
                
                cpri_Mapper.prRegistrationInsertGridData(prdtData);
            }
        } // 구매의뢰 수정
        else {
        	// STOCPRHD 수정
        	cpri_Mapper.updatePrRegistrationFormData(formData);
        	
        	// STOCPRDT 삭제 후 등록
        	cpri_Mapper.deletePrdtData(formData);
        	
            for (Map<String, Object> prdtData : gridData) {
                prdtData.put("BUYER_CD", formData.get("BUYER_CD"));
                prdtData.put("PR_NUM", formData.get("PR_NUM"));
                prdtData.put("PR_SQ", cpri_Mapper.getPrSeq(prdtData));
                
                if (signStatus.equals("E")) {
                    prdtData.put("PR_SIGN_STATUS", signStatus);
                }
                
                cpri_Mapper.prRegistrationInsertGridData(prdtData);
            }
        }
        
        // 구매의뢰 품목이 없는 경우 예외 발생
        int prdtCount = cpri_Mapper.getPrdtCount(formData);
        if (prdtCount == 0) {
            throw new NoResultException(msg.getMessageForService(this, "PRDT_NOT_EXIST"));
        }
        
        hashMap.put("BUYER_CD", formData.get("BUYER_CD"));
        hashMap.put("PR_NUM", formData.get("PR_NUM"));
        hashMap.put("message", msg.getMessage("0001"));
        
        return hashMap;
    }

	/** ******************************************************************************************
     * 구매요청 현황
     * @param req
     * @return
     * @throws Exception
     */

	public List<Map<String, Object>> CPRR0020_doSearch(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRR0020_doSearch(param);
	}

	/**
	 * 화면명 : 구매요청진행현황
	 * 처리내용 : 구매요청진행현황
	 * 경로 : 구매관리 > 구매관리 > 구매요청진행현황
	 */
	public List<Map<String, Object>> CPRR0030_doSearch(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRR0030_doSearch(param);
	}




























































    /**
     * Gets grid data by rFI no.
     *
     * @param rfiNo the rfi no
     * @return the grid data by rFI no
     */
    public List<Map<String, Object>> getGridDataByRFINo(String rfiNo) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("rfiNo", rfiNo);
        return cpri_Mapper.getGridDataByRFINo(map);
    }

    /**
     * Copy pr form data.
     *
     * @param prNo the pr no
     * @return the map
     */
    public Map<String, String> copyPrFormData(String prNo) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("PR_NUM", prNo);
        map = cpri_Mapper.getPrFormData(map);
        map.remove("PR_NUM");
        map.remove("APP_DOC_NUM");
        map.remove("APP_DOC_CNT");
        map.remove("SIGN_STATUS");
        map.remove("RMK_TEXT_NUM");
        return map;
    }

    /**
     * Copy pr grid data.
     *
     * @param prNo the pr no
     * @return the list
     */
    public List<Map<String, Object>> copyPrGridData(String prNo) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("PR_NUM", prNo);
        List<Map<String, Object>> prdtData = cpri_Mapper.getPrGridData(map);
        List<Map<String, Object>> prsiData = new ArrayList<Map<String, Object>>();


        setPrdtPrsiData(prsiData, "COPY_PR");
        //		setPrdtPrsiData(prdtData, prsiData, "COPY_PR");
        for (Map<String, Object> gridRow : prdtData) {
            gridRow.remove("PR_NUM");
            gridRow.remove("PR_SQ");
            gridRow.remove("INSERT_FLAG");
        }
        return prdtData;
    }

    /**
     * Pr registration do delete.
     *
     * @param prNo the pr no
     * @return the string
     * @throws Exception the exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String prRegistrationDoDelete(Map<String, String> map) throws Exception {
        Map<String, Object> gridParam = new HashMap<String, Object>();
        gridParam.putAll(map);
        String signStatus = cpri_Mapper.getSignStatus(map);
        int maxProgressCode = cpri_Mapper.getMaxProgressCode(map);

        // PRHD의 진행상태 체크(작성중[T]인 경우에만 삭제)
        if (!signStatus.equals("T") && !signStatus.equals("R")) {
            throw new NoResultException(msg.getMessage("0047"));
        }
        // PRDT의 진행상태 체크(구매요청중[1100]인 경우에만 삭제)
       	if (maxProgressCode > 1100) {
            throw new NoResultException(msg.getMessage("0044"));
        }

        cpri_Mapper.deletePrRegistrationFormData(map);
        cpri_Mapper.deletePrRegistrationGridData(gridParam);
//        cpri_Mapper.deletePrsiData(gridParam);
//        cpri_Mapper.deletePRHBData(map);
//        cpri_Mapper.deleteDONUData(map);
        //Map<String, String> appDocNo = cpri_Mapper.getAppDocNo(map);
        //if (signStatus.equals("E") || signStatus.equals("R") || signStatus.equals("C")) {
        //    approvalService.deleteSCTM(appDocNo);
        //}
//if (1==1) throw new Exception("======================================================");
        return msg.getMessage("0020", map.get("PR_NUM"));
    }

    private void setPrdtPrsiData(List<Map<String, Object>> prsiData, String mode) {
        for (Map<String, Object> prsiRow : prsiData) {
            prsiRow.put("MODE", mode);
        }
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    private Map<String, String> insertPrRequest(Map<String, String> formData, List<Map<String, Object>> gridData, List<Map<String, Object>> docGridData, String signStatus) throws Exception {
        return formData;
    }

    private Map<String, String> getCtrlUserId(String buyerReqCode, String itemCode) {
        Map<String, String> hashMap = new HashMap<String, String>();
        hashMap.put("ITEM_CD", itemCode);
        hashMap.put("BUYER_REQ_CD", buyerReqCode);
        List<Map<String, String>> ctrlUserId = cpri_Mapper.getCtrlUserId(hashMap);
        if (ctrlUserId.size() == 1) {
            return ctrlUserId.get(0);
        }
        return null;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    private void insertPRHBDONU(Map<String, String> map) {
        cpri_Mapper.deletePRHBData(map);
        cpri_Mapper.deleteDONUData(map);
        cpri_Mapper.insertPRHBData(map);
        cpri_Mapper.insertDONUData(map);
    }

	// 결재진행중(P)시 sign_status 변경
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String progressApproval(String docNum, String docCnt) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		map.put("APP_DOC_NUM", docNum);
		map.put("APP_DOC_CNT", docCnt);
		map.put("SIGN_STATUS", "P");
		cpri_Mapper.updateSignStatus(map);

		return msg.getMessage("0058");
	}

    public Map<String, String> doAccountSearch(Map<String, String> reqMap) {
        return cpri_Mapper.doAccountSearch(reqMap);
    }

    public Map<String, String> doCostSearch(Map<String, String> reqMap) {
        return cpri_Mapper.doCostSearch(reqMap);
    }











































    /** 공통모듈 */
    private void getPrdtPrsiData(List<Map<String, Object>> prdtData, List<Map<String, Object>> prsiData) throws IOException {

        for (Map<String, Object> prdtRow : prdtData) {
            HashMap<String, Object> map = (HashMap<String, Object>) prdtRow;
            int prSeq = Integer.valueOf((String) map.get("PR_SQ"));
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            for (Map<String, Object> prsiRow : prsiData) {
                int prsiPrSeq = Integer.valueOf((String) prsiRow.get("PR_SQ"));
                if (prSeq != prsiPrSeq) {
                    continue;
                }
                if (prsiRow.get("MODE") != null && prsiRow.get("MODE").equals("COPY_PR")) {
                    prsiRow.remove("PR_NUM");
                    prsiRow.remove("PR_SQ");
                    prsiRow.remove("INSERT_FLAG");
                }
                list.add(prsiRow);
            }
            if (list.size() > 0) {
                prdtRow.put("PRSI_DATA", new ObjectMapper().writeValueAsString(list));
            }
        }
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    private void deleteBasketData(Map<String, Object> prdtData) {
        if (EverString.isNotEmpty((String)prdtData.get("CART_SEQ"))) {
            cpri_Mapper.deleteBasketData(prdtData);
        }
    }

    @SuppressWarnings({"unchecked"})
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    private void savePrsiData(Map<String, Object> prdtData) throws IOException {

        String prsiData = (String)prdtData.get("PRSI_DATA");
        if (EverString.isEmpty(prsiData)) {
            return;
        }

        List<Map<String, Object>> prsiDataList = new ObjectMapper().readValue(prsiData.replace("＂", "\""), List.class);
        List<Map<String, Object>> prsiDataListConverted = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> map : prsiDataList) {
            Map<String, Object> newMap = new HashMap<String, Object>();
            Set<String> keySet = map.keySet();
            for (String key : keySet) {
                Object value = map.get(key);
                if (value instanceof Integer) {
                    newMap.put(key, String.valueOf(value));
                } else if (value instanceof String) {
                    newMap.put(key, value);
                }
            }
            prsiDataListConverted.add(newMap);
        }

        for (Map<String, Object> prsiDatarow : prsiDataListConverted) {
            if (EverString.isEmpty((String)prsiDatarow.get("PR_NUM"))) {
                prsiDatarow.put("PR_SQ", prdtData.get("PR_SQ"));
                prsiDatarow.put("PR_NUM", prdtData.get("PR_NUM"));
                cpri_Mapper.insertPrsiData(prsiDatarow);
            } else if (prsiDatarow.get("INSERT_FLAG") != null && prsiDatarow.get("INSERT_FLAG").equals("D")) {
                cpri_Mapper.deletePrsiData(prsiDatarow);
            } else {
                cpri_Mapper.updatePrsiData(prsiDatarow);
            }
        }
    }

}