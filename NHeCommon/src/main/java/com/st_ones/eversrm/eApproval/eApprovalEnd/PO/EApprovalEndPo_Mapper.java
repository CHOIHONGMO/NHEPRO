package com.st_ones.eversrm.eApproval.eApprovalEnd.PO;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndPo_Mapper.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
public interface EApprovalEndPo_Mapper {

	/**
	 * 모듈명 : 발주 [PO]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	public Map<String, String> getPoNum(Map<String, String> param);
	List<Map<String, String>> getMailList(Map<String, String> param);
	Map<String, String> costSmsInfo(Map<String, String> param);

	public void setPoSignStatus(Map<String, String> param);
	public void setPoStatus(Map<String, String> param);
	
	// 2021.01.25 발주완료 후 구매진행상태=5200(발주완료)
	public void setPrProgressCd(Map<String, String> param);
}