package com.st_ones.nhepro.CCUR;

import org.springframework.stereotype.Repository;

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
 * @File Name : CCUR0030_Mapper.java
 * @date 2020. 03. 18.
 * @version 1.0
 */
@Repository
public interface CCUR0030_Mapper {

    /**
     * 화면명 : 사용자현황
     * 처리내용 : 로그인한 사용자 회상의 사용자들을 조회/관리하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황
     */
	List<Map<String, Object>> ccur0030_doSearch(Map<String, String> param);

	void ocur0030_doDeleteMngYn(Map<String, Object> gridData);

	void ccur0030_doUpdate(Map<String, Object> gridData);

	void ccur0030_doDelete(Map<String, Object> gridData);

    void ccur0030_doInitPassword(Map<String, Object> gridData);

    /**
     * 화면명 : 사용자 등록/상세 (팝업)
     * 처리내용 : 로그인한 사용자 회사의 사용자들의 상세정보를 조회, 신규 사용자를 등록하는 화면.
     * 경로 : 고객사 > 관리자 > 사용자관리 > 사용자현황 > 사용자 등록/상세 (팝업)
     */
	Map<String, String> ccur0031_doSearchInfo(Map<String, String> param);

	List<Map<String, Object>> ccur0031_doSearchAuth(Map<String, String> param);

    int CheckUserInfoPassWordSame(Map<String, String> generalForm);

	void ccur0031_doMerge(Map<String, String> formData);

	void ccur0031_doInsertUSAP(Map<String, String> formData);

	Map<String, String> ccur0031_getUserData(Map<String, String> param);

	void ccur0031_doMergeTB(Map<String, String> data);

	String ccur0031_doCheckUserId(Map<String, String> param);

	int getExistCtrlCd(Map<String, Object> gridData);
	
	void ccur0031_doDeleteAuth(Map<String, Object> gridData);
	
	void ccur0031_doMergeAuth(Map<String, Object> gridData);
	
	void ccur0031_updateCustomerMngYn(Map<String, Object> gridData);
	

}