package com.st_ones.nhepro.CBDR.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CBDR.CBDR0050_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Service(value = "cbdr0050_Service")
public class CBDR0050_Service extends BaseService {

	@Autowired private MessageService msg;
	@Autowired private DocNumService docNumService;
	@Autowired private BAPM_Service approvalService;
	@Autowired private CBDR0050_Mapper cbdi_Mapper;
	
	public List<Map<String, Object>> cbdr0050_doSearch(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdr0050_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdr0050_doChangeCtrl(String ctrlUserId, List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {

			gridData.put("CTRL_USER_ID", ctrlUserId);

			// 진행상태를 체크한다.
			String possibleFlag = cbdi_Mapper.getPossibleFlag(gridData);
			if(!EverString.nullToEmptyString(possibleFlag).equals("Y")) {
				throw new Exception(msg.getMessageByScreenId("CBDI0010", "002"));
			}
			
			// 2021.01.14 추가
			// 견적, 수의시담인 경우 STOCRQHD의 예가담당자 변경
			String rfxType = String.valueOf(gridData.get("RFX_TYPE"));
			if( "BID".equals(rfxType) ) {
				cbdi_Mapper.cbdr0050_doChangeCtrl(gridData);
			}
			else {
				cbdi_Mapper.cbdr0050_doChangeRfxCtrl(gridData);
			}
		}
		return msg.getMessageByScreenId("CBDI0010", "004");
	}

	public Map<String, Object> cbdi0051_doSearch(Map<String, String> param) throws Exception {
		return cbdi_Mapper.cbdi0051_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0051_doSave(Map<String, String> formData) throws Exception {

        UserInfo userInfo = UserInfoManager.getUserInfo();
		String signStatus = formData.get("SIGN_STATUS");
		String appDocCnt  = "";

        if (signStatus.equals("P")) {
            if (EverString.isEmpty(formData.get("APP_DOC_NUM"))) {
                // 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
                formData.put("APP_DOC_NUM", docNumService.getDocNumber(userInfo.getCompanyCd(), "APPDOC"));
            }
            if (EverString.isEmpty(appDocCnt) || appDocCnt.equals("0")) {
                appDocCnt = "1";
            }
            else {
                // 이전의 SIGN_STATUS가 반려(R), 결재취소(C)이면 결재차수 = 결재차수 + 1
				//if (oldSignStatus.equals("R") || oldSignStatus.equals("C")) {
				//	appDocCnt = String.valueOf(Integer.parseInt(appDocCnt) + 1);
				//}
            }
            formData.put("APP_DOC_CNT", appDocCnt);
            formData.put("DOC_TYPE", "ESTM");

            // 결재요청
            approvalService.doApprovalProcess(formData, formData.get("approvalFormData"), formData.get("approvalGridData"));
        }

		cbdi_Mapper.cbdi0051_doSave(formData);

		return msg.getMessageByScreenId("CBDI0051", (signStatus.equals("P") ? "002" : "001"));
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0052_doSave(Map<String, String> formData) throws Exception {

		cbdi_Mapper.cbdi0052_doSave(formData);

		if(formData.get("STATUS").equals("T")) {
			return msg.getMessage("0001");
		} else {
			return msg.getMessageByScreenId("CBDI0052", "002");
		}
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cbdi0053_doSave(Map<String, String> formData) throws Exception {

        if (formData.get("STATUS").equals("E")) {

        }

		cbdi_Mapper.cbdi0053_doSave(formData);

		if(formData.get("STATUS").equals("T")) {
			return msg.getMessage("0001");
		} else {
			return msg.getMessageByScreenId("CBDI0052", "002");
		}
	}

}