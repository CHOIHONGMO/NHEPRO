package com.st_ones.nhepro.CCPI;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface CCPI1000_Mapper {

	// 개인근로자 계약 Header정보 가져오기
	Map<String, String> ccpi1000_getBundleContractInfo(Map<String, String> bundleContractInfo);
	
	//임시저장된 근로자 계약내용 조회
	List<Map<String, Object>> ccpi1000_getSavedEmpListForBundleContract(Map<String, String> formData);
	
	//일괄계약서 조회 
	List<Map<String, Object>> ccpi1000_doSearchBundelInfo(Map<String, String> formData);
	
	//PDF_ATT_FILE_NUM 저장
	void ccpi1000_doUpdatePdfUUID(Map<String, Object> param);
	
	//주서식 조회
	List<Map<String, Object>> ccpi1000_doSearchMainForm(Map<String, String> param);
	
	//추가서식 조회
	List<Map<String, Object>> ccpi1000_doSearchAdditionalForm(Map<String, String> formData);
	
	//근로계약서 테이블 insert
	void ccpi1000_doInsertTCCT(Map<String, String> formData);
	
	//근로계약서 테이블 update
	void ccpi1000_doUpdateTCCT(Map<String, String> formData);
	
	//계약서 주서식정보 insert
	void ccpi1000_doInsertTCRL(Map<String, String> additionalForm);
	
	//계약서 주서식정보 update
	void ccpi1000_doUpdateTCRL(Map<String, String> additionalForm);
	
	//계약서 부서식정보 insert
	void ccpi1000_doInsertAddTCRL(Map<String, Object> additionalForm);
	
	// 부서식 내용번호 delete
	void ccpi1000_doDeleteAddTCRL(Map<String, String> formData);
	
	//계약서 결재상태 update
	void ccpi1000_doUpdateTCCTSignStatus(Map<String, String> param);
	
	int ccpi1000_doUpdateApprovalInformation(Map<String, String> formData);
	
	//개인근로자 서명 완료 후 pdf 번호 조회
    String ccpi1000_doSelectPdfJsonData(Map<String, String> formData);
	
    //근로계약서 테이블 pdf update
  	void ccpi1000_doUpdatePdfTCCT(Map<String, String> formData);
  	
  	void ccpi1000_doDeleteTCRL(Map<String, String> formData);
  	
  	void ccpi1000_doDeleteTCCT(Map<String, String> formData);
}
