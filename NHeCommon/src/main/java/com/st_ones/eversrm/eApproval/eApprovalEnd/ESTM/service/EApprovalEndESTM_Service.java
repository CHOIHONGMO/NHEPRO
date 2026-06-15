package com.st_ones.eversrm.eApproval.eApprovalEnd.ESTM.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.eApprovalEnd.ESTM.EApprovalEndESTM_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndPr_Service.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
@Service(value = "eApprovalEndESTM_Service")
public class EApprovalEndESTM_Service extends BaseService {

    @Autowired private MessageService msg;

	@Autowired private EApprovalEndESTM_Mapper endEstm_Mapper;

	/**
	 * 모듈명 : 예가 [ESTM]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String endApproval(String buyerCd, String appDocNum, String appDocCnt, String signStatus) throws Exception {

		Map<String, String> param = new HashMap<String, String>();
		param.put("BUYER_CD", buyerCd);
		param.put("APP_DOC_NUM", appDocNum);
		param.put("APP_DOC_CNT", appDocCnt);
		param.put("SIGN_STATUS", signStatus);

		// 결재번호에 해당하는 구매요청번호 가져오기
		Map<String, String> bdes = endEstm_Mapper.getBdesNum(param);
		param.put("GATE_CD", bdes.get("GATE_CD"));
		param.put("BID_NUM", bdes.get("BID_NUM"));
		param.put("BID_CNT", bdes.get("BID_CNT"));


		// STOCPRHD.SIGN_STATUS 변경
		endEstm_Mapper.setBdesSignStatus(param);

		String rtnMsg = (signStatus.equals("E") ? msg.getMessage("0057")
				: (signStatus.equals("R") ? msg.getMessage("0058")
				: (signStatus.equals("C") ? msg.getMessage("0061")
				: msg.getMessage("0001"))));

		return rtnMsg;
	}

}
