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
 * @File Name : CCTI0090_Mapper.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
public interface CCTI0090_Mapper {
	
	// 개인근로자 계약작성 조회
	Map<String, String> ccti0090_doSearch(Map<String, String> formData);
	
	// 개인근로자 계약작성상태 조회
	String ccti0090_doCheckStatus(Map<String, String> formData);
	
	List<Map<String, Object>> ccti0090_getWorkerListForContract(Map<String, String> formData);
	
	// 개인근로자 계약서 등록
	void doInsertPCCT(Map<String, String> formData); 
	
	// 개인근로자 계약서 수정
	void doUpdatePCCT(Map<String, String> formData); 
	
	// 개인근로자 계약서 삭제
	void doDeletePCCT(Map<String, String> formData); 
	
	// 개인근로자 삭제
	void doDeletePCWU(Map<String, String> formData); 
	
	// 개인근로자 등록
	void doInsertPCWU(Map<String, Object> gridData);
	
	// 개인근로자 결재상태 진행중으로 변경
	void doUpdateStatusOfPCCT(Map<String, String> formData);
	
	// 결재상신 후 결재문서 번호 저장
	int doUpdateApprovalPCCT(Map<String, String> formData);
	
	// 개인근로자 계약담당자 변경
	void cctr0100_changeContUser(Map<String, Object> rowData);
	
	// 개인근로자 현장담당자 변경
	void cctr0100_changeSiteUser(Map<String, Object> rowData);
	
	// 개인근로자 계약서 상세조회
	List<Map<String, Object>> cctr0110_doSearch(Map<String, String> formData);
	
	// 개인근로자 계약체결 진행현황 조회
	List<Map<String, Object>> cctr0100_doSearch(Map<String, String> formData);
	
	// 개인근로자 전자서명 직접 요청
    void cctr0100_doSendYn(Map<String, Object> rowData);
    
	// 계약중단
    void cctr0100_doStop(Map<String, Object> rowData);
    
  	// 개인근로자현황 조회
 	List<Map<String, Object>> cctr0120_doSearch(Map<String, String> formData);
 	
 	// 2021.03.02 프로세스 추가 개인근로자 승인 및 반려
 	void cctr0120_doConfirm(Map<String, Object> rowData);
  	
 	// 2021.07.01 SMS 수수료 추가
 	Map<String, String> costSmsInfo(Map<String, Object> rowData);
 	
 	// 2021.07.01 SMS 수수료 추가
  	Map<String, String> costPersonalInfo(Map<String, Object> rowData);
 	
}

