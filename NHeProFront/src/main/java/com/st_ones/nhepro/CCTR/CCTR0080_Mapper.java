package com.st_ones.nhepro.CCTR;

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
 * @File Name : CCTR0080_Mapper.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */public interface CCTR0080_Mapper {

	/**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 위임장 요청현황 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    List<Map<String,Object>> cctr0080_doSearch(Map<String, Object> param) throws Exception;
    
	/**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 전자서명대기인 위임장에 대해 요청취소 처리함
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    void cctr0080_doCancelDT(Map<String, Object> rowData) throws Exception;

    /**
	 * 화면명 : 위임장 요청현황
	 * 처리내용 : 위임장 요청취소 가능여부 체크
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    String cctr0080_checkProgressCd(Map<String, Object> rowData) throws Exception;
    
    /**
	 * 화면명 : 위임장 현황
	 * 처리내용 : 위임장 요청현황 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장현황
	 */
    List<Map<String,Object>> cctr0081_doSearch(Map<String, Object> param) throws Exception;
    
    /**
	 * 화면명 : 위임장 요청상세
	 * 처리내용 : 위임장 요청상세 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    Map<String,String> cctr0070_doSearchHD(Map<String, String> param) throws Exception;
    
    /**
	 * 화면명 : 위임장 요청상세
	 * 처리내용 : 위임장 요청상세 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    List<Map<String,Object>> cctr0070_doSearchDT(Map<String, String> param) throws Exception;
    
    void cctr0070_doInsertHD(Map<String, String> formData) throws Exception;
    
    void cctr0070_doUpdateHD(Map<String, String> formData) throws Exception;
    
    void cctr0070_doDeleteDT(Map<String, String> formData) throws Exception;
    
    void cctr0070_doInsertDT(Map<String, Object> gridData) throws Exception;
    
    void cctr0070_doCancelHD(Map<String, String> formData) throws Exception;
    
    void cctr0070_doCancelDT(Map<String, String> formData) throws Exception;
    
    // EFORM 번호 저장
    void cctr0071_doSaveEform(Map<String, String> formData) throws Exception;
    
    /**
	 * 화면명 : 위임장 요청상세
	 * 처리내용 : 위임장 요청상세 조회
	 * 경로 : 계약관리 > 전자계약 > 위임장요청현황
	 */
    Map<String,String> cctr0071_doSearch(Map<String, String> param) throws Exception;
    
    // 메일발송 대상목록 가져오기
    List<Map<String, String>> getMailTargetList(Map<String, String> param);
    
    // 계약완료 수수료 청구 리스트 가져오기
    Map<String, String> costPayInfo(Map<String, Object> param);
    
    // SMS 수수료 청구 리스트 가져오기
    Map<String, String> costSmsInfo(Map<String, String> param);
    
    // 위임장 결재상태 진행중으로 변경
 	void doUpdateStatusOfETDT(Map<String, String> formData);
 	
    // 결재상신 후 결재문서 번호 저장
 	int doUpdateApprovalETDT(Map<String, String> formData);
 	
    // 위임장 요청 전자서명
    void sctr0071_doSaveSignedData(Map<String, Object> param) throws Exception;
    
    // 처리내용 : 위임장 요청 반려
    void cctr0071_doReject(Map<String, Object> param) throws Exception;
}

