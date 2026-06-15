package com.st_ones.nhepro.CWOR;

import org.apache.ibatis.annotations.Param;
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
 * @File Name : CWOR0010_Mapper.java
 * @date 2020. 03. 04.
 * @version 1.0
 * @see
 */
@Repository
public interface CWOR0010_Mapper {

    /**
     * 화면명 : 결재함
     * 처리내용 : 로그인한 사용자에게 상신된 결제문서들을 조회/승인/반려할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재함
     */
	List<Map<String, Object>> cwor0010_doSearch(Map<String, String> param);

	/**
	 * 화면명 : 결재요청상세
	 * 처리내용 : 선택한 결제요청문서의 상세 정보를 조회하는 화면.
	 * 경로 : Popup
	 */
	String selectMySignStatus(Map<String, String> formDataParam);

	int getAuthorizedCount(Map<String, String> approvalInfoKey);

	Map<String, String> cwor0011_doSearchHeader(Map<String, String> approvalInfoKey);

	List<Map<String, Object>> cwor0011_doSearchDetail(Map<String, String> formData);

	String getUpdateFlag(Map<String, String> param);

	void cwor0011_documentRead(Map<String, String> formData);
	
	/**
	 * 화면명 : 결재요청상세
	 * 처리내용 : 선택한 결제요청문서 결재 문서유형이 "ESTM(예정가격)인 경우 해당 입찰의 예가등록 팝업을 오픈
	 * 경로 : Popup
	 */
	List<Map<String, Object>> cwor0011_doSearchESTM(Map<String, String> param);
	
	/**
	 * 화면명 : 결재자리스트
	 * 처리내용 : 선택한 결제요청문서의 결재자 정보를 조회하는 화면.
	 * 경로 : Popup
	 */
	List<Map<String, Object>> cwor0012_selectPathPopup(Map<String, String> param);

	/**
	 * 화면명 : 결재완료함
	 * 처리내용 : 로그인한 사용자가 승인/반려한 결제문서들을 조회할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재함 > 결재완료함
	 */
	List<Map<String, Object>> cwor0020_doSearch(Map<String, String> param);
	
	/**
     * 화면명 : 부서(팀)결재완료함
     * 처리내용 : 로그인한 사용자가 팀내 결재건은 전체 조회 할 수 있는 화면
     * 경로 : 고객사 > 전자결재 > 전자결재 > 부터(팀)결재완료함
     */
	List<Map<String, Object>> cwor0060_doSearch(Map<String, String> param);

	/**
	 * 화면명 : 결재상신함
	 * 처리내용 : 로그인한 사용자가 상신한 결제문서들을 조회/상신취소할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재상신함
	 */
	List<Map<String, Object>> cwor0030_doSearch(Map<String, String> param);

    /**
     * 화면명 : 결재경로관리
     * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 조회/등록/삭제할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리
     */
    List<Map<String, Object>> cwor0040_doSearch(Map<String, String> param);

    void deletePath(Map<String, Object> gridData);

    void deletePathDetail(Map<String, Object> gridData);

	/**
	 * 화면명 : 결재경로등록
	 * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 등록/수정할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 결재경로등록 (팝업)
	 */
	List<Map<String, Object>> cwor0041_doSearchDT(Map<String, String> param);

	String getPathNo(Map<String, String> formData);

	void insertPath(Map<String, String> formData);

	void updatePath(Map<String, String> formData);

	void deleteLULP(Map<String, String> formData);

	void insertPathDetail(Map<String, Object> gridData);

	void updateOtherPathToNormal(Map<String, String> formData);

	/**
	 * 화면명 : 나의결재경로
	 * 처리내용 : 로그인한 사용자가 등록한 경로를 조회/선택할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 나의결재경로 (팝업)
	 */
	List<Map<String, Object>> cwor0042_doSearch(Map<String, String> param);

	/**
	 * 화면명 : 결재요청
	 * 처리내용 : 결재상신을 위해 결재내용, 결재자 등을 지정하는 화면.
	 * 경로 : 고객사 > 업무화면 > 결재요청
	 */
	List<Map<String, Object>> cwor0050_userSearchAll(Map<String, String> param);

	List<Map<String, Object>> cwor0050_userSearchMy(Map<String, String> param);

	Map<String, String> getAppLineCd(Map<String, Object> param);

	List<Map<String, Object>> getAgrLines(Map<String, Object> param);

	List<Map<String, Object>> getAppLinesOperator(Map<String, String> param);

	Map<String, Object> getAppLinesTeamLeader(Map<String, String> param);

	List<Map<String, Object>> getAppLinesInCust(Map<String, String> param);

	List<Map<String, Object>> doSearchSync(Map<String, Object> param);

	List<Map<String, Object>> cwor0050_doSelectMyPath(HashMap<String, String> approvalPathKey);

	List<Map<String, Object>> cwor0050_getCust(Map<String, String> approvalPathKey);
	
	List<Map<String, Object>> cwor0050_getCustCd(Map<String, String> approvalPathKey);

}