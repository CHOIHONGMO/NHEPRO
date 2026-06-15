package com.st_ones.nhepro.OCUR;

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
 * @File Name : OCUR0030_Mapper.java
 * @date 2020. 03. 09.
 * @version 1.0
 */
@Repository
public interface OCUR0030_Mapper {

	/**
	 * 화면명 : 고객사별 사용자현황
	 * 처리내용 : 시스템에 등록된 고객사들의 사용자들을 조회/관리하는 화면.
	 * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 사용자현황
	 */
	List<Map<String, Object>> ocur0030_doSearch(Map<String, String> param);

	void ocur0030_doDeleteMngYn(Map<String, Object> gridData);

	void ocur0030_doUpdate(Map<String, Object> gridData);

	void ocur0030_doDelete(Map<String, Object> gridData);

    void ocur0030_doInitPassword(Map<String, Object> gridData);

	void ocur0030_doSearch_pw(Map<String, Object> param);

	/**
	 * 화면명 : 고객사별 사용자 등록/상세 (팝업)
	 * 처리내용 : 시스템에 등록된 고객사들의 사용자들의 상세정보를 조회, 신규 사용자를 등록하는 화면.
	 * 경로 : 시스템운영사 > 회원사관리 > 고객사 관리 > 고객사별 사용자현황 > 고객사별 사용자 등록/상세 (팝업)
	 */
	Map<String, String> ocur0031_doSearchInfo(Map<String, String> param);

	List<Map<String, Object>> ocur0031_doSearchAuth(Map<String, String> param);

    int CheckUserInfoPassWordSame(Map<String, String> generalForm);

	void ocur0031_doMerge(Map<String, String> formData);

	void ocur0031_doInsertUSAP(Map<String, String> formData);

	Map<String, String> ocur0031_getUserData(Map<String, String> param);

	void ocur0031_doMergeTB(Map<String, String> data);

	String ocur0031_doCheckUserId(Map<String, String> param);

	int getExistCtrlCd(Map<String, Object> gridData);

	void ocur0031_doMergeAuth(Map<String, Object> gridData);

	void ocur0031_doDeleteAuth(Map<String, Object> gridData);
}