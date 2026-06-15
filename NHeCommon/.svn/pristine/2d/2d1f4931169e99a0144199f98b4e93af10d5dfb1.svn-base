package com.st_ones.eversrm.eApproval.eApprovalEnd.EXEC;

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
 * @File Name : EApprovalEndExec_Mapper.java
 * @date 2020. 6. 30.
 * @version 1.0
 */
public interface EApprovalEndExec_Mapper {

	/**
	 * 모듈명 : 선정품의 [EXEC]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	public Map<String, String> getExecNum(Map<String, String> param);

	public void setExecSignStatus(Map<String, String> param);

	public void setProgressCd(Map<String, String> param);
	
	// 2021.01.22 구매품의 결재승인 후 PRDT의 구매진행상태 = 3200(품의완료)로 변경
	public void setPrProgressCd(Map<String, String> param);

	List<Map<String, Object>> getTargetList(Map<String, String> param);

	void insertECHB(Map<String, Object> data);
	
	String getRfxExSq(Map<String, String> param);
	
	List<Map<String, String>> getRfxMailTargetList(Map<String, String> param);
	
	String getBidExSq(Map<String, String> param);

	List<Map<String, String>> getBidMailTargetList(Map<String, String> param);

}