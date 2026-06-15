package com.st_ones.nhepro.CPRA.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CPRA.CPRA0040_Mapper;

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
@Service(value = "cpra0040_Service")
public class CPRA0040_Service extends BaseService {

    @Autowired private CPRA0040_Mapper cpri_Mapper;
    @Autowired private DocNumService docNumService;
	@Autowired private EverSmsService eversmsservice;
    @Autowired private MessageService msg;

    /** ******************************************************************************************
	 * 담당자 지정
	 * @param req
	 * @return
	 * @throws Exception
	 */
    public List<Map<String, Object>> CPRA0040_doSearch(Map<String, String> param) {
		// TODO Auto-generated method stub
		return cpri_Mapper.CPRA0040_doSearch(param);
	}
    
    public String CPRA0040_doChangeCtrl(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	String ctrlUserId = param.get("CTRL_USER_ID");
    	
    	int cnt = 0;
    	StringBuffer sb = new StringBuffer(255);
    	sb.append("[전자구매시스템]");
    	for(Map<String, Object> gridData : gridDatas) {
			gridData.put("CTRL_USER_ID",  ctrlUserId);
			gridData.put("CTRL_BUYER_CD", param.get("CTRL_BUYER_CD"));
			gridData.put("CTRL_DEPT_CD",  param.get("CTRL_DEPT_CD"));
			
			cpri_Mapper.CPRA0040_doChangeCtrl(gridData);
			
			// 2021.06.29 : 구매담당자 지정 SMS 수수료 부과하기
			//if (sb.toString().indexOf(gridData.get("SUBJECT").toString()) == -1 )
			//sb.append(" " + gridData.get("PR_BUYER_NM") + " " + gridData.get("REQ_USER_NM") + "께서 의뢰한 [" + gridData.get("SUBJECT") + "]의 구매담당자로 지정되셨습니다 \n");
			if( cnt == 0 ) {
				sb.append(" " + gridData.get("PR_BUYER_NM") + " " + gridData.get("REQ_USER_NM") + "께서 의뢰한 [" + gridData.get("SUBJECT") + "]");
			}
			cnt++;
		}
    	
    	if (cnt > 0) {
    		sb.append(" 외 " + (cnt - 1) + " 건의 구매담당자로 지정되셨습니다.");
            Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", sb.toString());
            smsMap.put("REF_MODULE_CD", "MPR03");
            smsMap.put("RECV_USER_ID", ctrlUserId);
            
            // 2021.06.29 : 구매담당자 지정 SMS 수수료 부과하기
            Map<String, String> costInfo = cpri_Mapper.costSmsInfo(param);
            smsMap.put("CORP_NO", costInfo.get("CORP_NO"));			// 고객사 사업자번호
    		smsMap.put("BRC", costInfo.get("BRC"));					// 고객사 부서
    		smsMap.put("EPRO_PS_DSC", "1");							// 1  : 구매
            smsMap.put("EPRO_RATE_DSC", "01");						// 01 : 최초
    		smsMap.put("APLY_DT", costInfo.get("APLY_DT"));			// 발생일 YYYYMMDD
    		smsMap.put("USER_ID", costInfo.get("USER_ID"));			// 고객사 보내는사람 ID
    		smsMap.put("CONT_TBL_ID", "STOCCVUR");					// 검증 테이블
    		smsMap.put("CONT_TBL_PK", costInfo.get("CONT_TBL_PK")); // 검증 조건(협력사별 입찰번호)
    		smsMap.put("tmp", costInfo.get("CONT_TBL_PK"));			// myBatis 버그 해결을 위한 무의미한, 유니크한 값.
    		smsMap.put("payFlag", "Y");								// SMS 과금여부
    		
            eversmsservice.sendSmsNhe(smsMap);
    	}

    	// 성공적으로 담당자를 변경하였습니다
		return msg.getMessageByScreenId("CPRA0040", "M0001");
    }
    
    public String cpra0040_doSearchCtrlUserNm(Map<String, String> param) {
		return cpri_Mapper.cpra0040_doSearchCtrlUserNm(param);
	}
    
    /**
     * IT포탈 구매의뢰건 삭제
     * @param param
     * @param gridDatas
     * @return
     * @throws Exception
     */
    public String cpra0040_doDelete(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	for(Map<String, Object> gridData : gridDatas) {
			gridData.put("DEL_RMK",  param.get("DEL_RMK"));
			cpri_Mapper.cpra0040_doDelete(gridData);
		}
    	
    	return msg.getMessage("0001");
    }

	/** ******************************************************************************************
	 * 구매요청 접수
	 * @param req
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> CPRA0050_doSearch(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0050_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String CPRA0050_doReceipt(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		for(Map<String, Object> gridData : gridDatas) {

			String confirmYN = EverString.nullToEmptyString(getProgressCd(gridData));
			if(Integer.parseInt(confirmYN) >= 2200 ) {
				throw new Exception(msg.getMessageByScreenId("CPRA0050", "001"));
			}
			
			String ctrlUserId = EverString.nullToEmptyString(cpri_Mapper.getCtrlUserId(gridData));
			if(!userInfo.getUserId().equals(ctrlUserId)) {
				throw new Exception(msg.getMessageByScreenId("CPRA0050", "002"));
			}

			gridData.put("PROGRESS_CD", "2200");
			cpri_Mapper.CPRA0050_doReceipt(gridData);
		}
		
		return msg.getMessageByScreenId("CPRA0050", "003");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String CPRA0050_doReject(String rejectRMK, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		for(Map<String, Object> gridData : gridDatas) {

			String ctrlUserId = EverString.nullToEmptyString(cpri_Mapper.getCtrlUserId(gridData));
			if(!userInfo.getUserId().equals(ctrlUserId)) {
				throw new Exception(msg.getMessageByScreenId("CPRA0050", "002"));
			}
			
			gridData.put("PROGRESS_CD", "1200");
			gridData.put("REJECT_RMK", rejectRMK);
			cpri_Mapper.CPRA0050_doReject(gridData);
			cpri_Mapper.CPRA0050_doRejectAllCheck(gridData);
		}
		
		return msg.getMessageByScreenId("CPRA0050", "010");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String CPRA0050_doTrans(String ctrlUserId, List<Map<String, Object>> gridDatas) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("USER_ID", ctrlUserId);
		
		for(Map<String, Object> gridData : gridDatas) {
			String confirmYN = EverString.nullToEmptyString(getProgressCd(gridData));
			if(Integer.parseInt(confirmYN) > 2200 ) {
				throw new Exception(msg.getMessageByScreenId("CPRA0050", "005"));
			}
			
			gridData.put("CTRL_USER_ID", ctrlUserId);
			gridData.put("PROGRESS_CD", "2100");
			cpri_Mapper.CPRA0050_doTrans(gridData);
		}
		
		return msg.getMessageByScreenId("CPRA0050", "007");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String CPRA0050_doJongPo(String ctrlUserId, List<Map<String, Object>> gridDatas) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("USER_ID", ctrlUserId);

		for(Map<String, Object> gridData : gridDatas) {
			String confirmYN = EverString.nullToEmptyString(getProgressCd(gridData));
			if(Integer.parseInt(confirmYN) > 2200 ) {
				//throw new Exception(msg.getMessageByScreenId("CPRA0050", "005"));
			}
			gridData.put("CTRL_USER_ID", ctrlUserId);
			gridData.put("PROGRESS_CD", "5100");
			gridData.put("PO_WT_NUM", docNumService.getDocNumber( String.valueOf(gridData.get("PR_BUYER_CD")) , "POW"));

			cpri_Mapper.CPRA0050_setProgressCd(gridData);
			cpri_Mapper.CPRA0050_doJongPo(gridData);
		}
		
		return msg.getMessageByScreenId("CPRA0050", "025");
	}

	public String getProgressCd(Map<String, Object> param) throws Exception {
		return cpri_Mapper.getProgressCd(param);
	}

	/** ******************************************************************************************
	 * IT Potal 조회
	 * @param req
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> CPRA0060_Master(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Master(param);
	}

	public List<Map<String, Object>> CPRA0060_Grid1(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid1(param);
	}
	public List<Map<String, Object>> CPRA0060_Grid2(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid2(param);
	}
	public List<Map<String, Object>> CPRA0060_Grid3(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid3(param);
	}
	public List<Map<String, Object>> CPRA0060_Grid4(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid4(param);
	}
	public List<Map<String, Object>> CPRA0060_Grid5(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid5(param);
	}
	public List<Map<String, Object>> CPRA0060_Grid6(Map<String, String> param) throws Exception {
		return cpri_Mapper.CPRA0060_Grid6(param);
	}

}

