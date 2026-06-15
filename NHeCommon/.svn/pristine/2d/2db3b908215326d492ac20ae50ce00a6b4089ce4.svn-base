package com.st_ones.eversrm.eApproval.eApprovalBox;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
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
 * @File Name : BAPP_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */
@Repository
public interface BAPP_Mapper {

	List<Map<String, Object>> searchMailBox(Map<String, String> param);

	List<Map<String, Object>> getSendBoxList(Map<String, String> param);

	void doCancelRFA(Map<String, Object> gridData);

	String getCurrentDocCount(Map<String, String> approvalInfoKey);

	Map<String, String> selectSTOCSCTM(Map<String, String> approvalInfoKey);
	
	List<Map<String, Object>> selectSTOCSCTP(Map<String, String> formData);

	List<Map<String, Object>> selectLULP(HashMap<String, String> approvalPathKey);

	int getAuthorizedCount(Map<String, String> approvalInfoKey);

	Map<String, String> getUserInfoByName(HashMap<String, String> hashMap);

	int matchUserCountByName(HashMap<String, String> hashMap);

	/**
	 * 화면명 : 결재요청 Popup
	 * 처리내용 : 사용자가 결재요청을 위해 결재선 등의 정보를 입력하는 화면.
	 * 경로 : Popup
	 */
    List<Map<String, Object>> userSearch(Map<String, String> param);

	Map<String, String> getAppLineCd(Map<String, Object> param);

	String getParentDeptCd(Map<String, Object> param);

	Map<String, String> checkITO(Map<String, String> param);

	List<Map<String, Object>> getAgrLines(Map<String, Object> param);

	List<Map<String, Object>> getAppLines(Map<String, String> param);

	List<Map<String, Object>> getAppLinesOperator(Map<String, String> param);

	List<Map<String, Object>> getAppLinesInCust(Map<String, String> param);

	Map<String, Object> getAppLinesTeamLeader(Map<String, String> param);

	List<Map<String, Object>> doSearchSync(Map<String, Object> param);
	
    List<Map<String, Object>> getSendReceiveBoxList(Map<String, String> param);

	List<Map<String, Object>> getSendReceiveBoxListA(Map<String, String> param);

    List<Map<String, Object>> getPcSmartDeviceNewRequest();

	List<Map<String,Object>> getPcSmartDeviceChangeRequest();

	List<Map<String,Object>> getworkRequest();

}