package com.st_ones.nhepro.CCPI;

import java.util.List;
import java.util.Map;

public interface CCPI1200_Mapper {
	
	// 개인근로자 계약 Header정보 가져오기
	Map<String, String> ccpi1200_getBundleContractInfo(Map<String, String> bundleContractInfo);
	
	//임시저장된 근로자 계약내용 조회
	List<Map<String, Object>> ccpi1200_getSavedEmpListForBundleContract(Map<String, String> formData);
	
	//PDF_ATT_FILE_NUM 저장
	void ccpi1200_doUpdatePdfUUID(Map<String, Object> param);
	
	//주서식 조회
	List<Map<String, Object>> ccpi1200_doSearchMainForm(Map<String, String> param);
	
	//추가서식 조회
	List<Map<String, Object>> ccpi1200_doSearchAdditionalForm(Map<String, String> formData);
	
	//근로계약서 테이블 insert	
	void ccpi1200_doInsertTCCT(Map<String, String> gridData);
	
	//근로계약서 테이블 update
	void ccpi1200_doUpdateTCCT(Map<String, String> formData);
	
	//계약서 주서식정보 insert
	void ccpi1200_doInsertTCRL(Map<String, String> additionalForm);
	
	//계약서 주서식정보 update
	void ccpi1200_doUpdateTCRL(Map<String, String> additionalForm);
	
	//계약서 부서식정보 insert
	void ccpi1200_doInsertAddTCRL(Map<String, Object> additionalForm);
	
	// 부서식 내용번호 delete
	void ccpi1200_doDeleteAddTCRL(Map<String, String> formData);
	
	//계약서 결재상태 update
	void ccpi1200_doUpdateTCCTSignStatus(Map<String, String> param);

	int ccpi1200_doUpdateApprovalInformation(Map<String, String> formData);
	
	//개인근로자 서명 완료 후 pdf 번호 조회
    String ccpi1200_doSelectPdfJsonData(Map<String, String> formData);
	
   //근로계약서 테이블 pdf update
  	void ccpi1200_doUpdatePdfTCCT(Map<String, String> formData);
  	
  	void ccpi1200_doDeleteTCRL(Map<String, String> formData);
  	
  	void ccpi1200_doDeleteTCCT(Map<String, String> formData);
}
