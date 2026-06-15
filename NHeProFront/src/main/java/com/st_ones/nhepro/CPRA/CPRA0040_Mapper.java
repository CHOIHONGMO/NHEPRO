package com.st_ones.nhepro.CPRA;

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
 * @File Name : CPRA0040_Mapper.java
 * @date 2020. 03. 20.
 * @version 1.0
 */
public interface CPRA0040_Mapper {

	 /** ******************************************************************************************
	 * 담당자 지정
	 * @param req
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> CPRA0040_doSearch(Map<String, String> param);
	void CPRA0040_doChangeCtrl(Map<String, Object> gridData);
	String cpra0040_doSearchCtrlUserNm(Map<String, String> param);
	// 2021.04.12 IT포탈 구매의뢰건 삭제 추가
	void cpra0040_doDelete(Map<String, Object> gridData);
	
	/** ******************************************************************************************
	 * 구매요청 접수
	 * @param req
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> CPRA0050_doSearch(Map<String, String> param);
	void CPRA0050_doReceipt(Map<String, Object> gridData);
	void CPRA0050_doReject(Map<String, Object> gridData);


	void CPRA0050_doRejectAllCheck(Map<String, Object> gridData);


	void CPRA0050_doTrans(Map<String, Object> gridData);

	void CPRA0050_setProgressCd(Map<String, Object> gridData);
	void CPRA0050_doJongPo(Map<String, Object> gridData);



	String getCtrlUserId(Map<String, Object> param);
	String p03004_getIsFlag(Map<String, String> param);
	String getProgressCd(Map<String, Object> param);


	Map<String, Object> CPRA0060_Master(Map<String, String> param);

	List<Map<String, Object>> CPRA0060_Grid1(Map<String, String> param);
	List<Map<String, Object>> CPRA0060_Grid2(Map<String, String> param);
	List<Map<String, Object>> CPRA0060_Grid3(Map<String, String> param);
	List<Map<String, Object>> CPRA0060_Grid4(Map<String, String> param);
	List<Map<String, Object>> CPRA0060_Grid5(Map<String, String> param);
	List<Map<String, Object>> CPRA0060_Grid6(Map<String, String> param);
	
	// 2021.06.29 : 구매담당자 지정시 SMS 수수료 부과
	Map<String, String> costSmsInfo(Map<String, String> param);

}