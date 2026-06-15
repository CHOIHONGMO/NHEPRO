package com.st_ones.nhepro.CCTR;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTR0020_Mapper.java
 * @date 2020.04.17
 * @version 1.0
 * @see
 */public interface CCTR0020_Mapper {

	/**
	 * 화면명 : 
	 * 처리내용 : 
	 * 경로 :  >  > 
	 */
    List<Map<String,Object>> cctr0020_doSearch(Map<String, String> param) throws Exception;
    
    // 2021.01.08 추가
    // 1. 수기계약이관 STOCECCT 등록
    void cctr0020_doInsertECCT(Map<String, Object> param);
    // 2. 수기계약이관 STOCECCM 등록
    void cctr0020_doInsertECCM(Map<String, Object> param);
    // 3. 수기계약이관 STOCECMT 등록
    void cctr0020_doInsertECMT(Map<String, Object> param);
    // 4. STOCECHB 삭제값 변경
    void cctr0020_doDeleteECHB(Map<String, Object> param);
    
    String cctr0020_doResumeCheck(Map<String, Object> rowData);
    
	List<Map<String, Object>> ccta0030_doSearchAdditionalForm(Map<String, String> formData);

	void ccta0030_doInsertECCT(Map<String, String> formData);

	void ccta0030_doUpdateECCT(Map<String, String> formData);

	void ccta0030_doDeleteECCT(Map<String, String> formData);

	void ccta0030_doUpdateECWT(Map<String, String> formData);

	void ccta0030_doInsertECRL(Map<String, String> additionalForm);

	void ccta0030_doInsertAddECRL(Map<String, Object> additionalForm);

	void ccta0030_doUpdateECRL(Map<String, String> additionalForm);

	void ccta0030_doDeleteECRL(Map<String, String> formData);

	Map<String, String> ccta0030_getBuyerInformation(Map<String, Object> formData);

	Map<String, String> ccta0030_getVendorInformation(Map<String, String> formData);

	// 계약서 작성정보 가져오기
	Map<String, String> ccta0030_getContractInformation(Map<String, String> formData);

	void ccta0030_doUpdateStatusOfECCT(Map<String, String> formData);

	int ccta0030_doUpdateECCT4NotesIF(Map<String, String> formData);

	int ccta0030_doInsertECSV(Map<String, String> formData);

	Map<String, String> ccta0030_getFormContents(@Param("formNum") String formNum);

	List<Map<String, Object>> ccta0030_getFileInformation(Map<String, String> paramMap);

	int ccta0030_doUpdateApprovalInformation(Map<String, String> formData);

	// 이전차수의 계약종료일자 = 현재차수의 계약시작일자 - 1
	void ccta0030_updateBfContEndDate(Map<String, String> gridData);

	List<Map<String, String>> ccta0030_getContractMainContents(Map<String, String> formData);

	List<Map<String, String>> ccta0030_getContractAllContents(Map<String, String> formData);

	List<Map<String, Object>> ccta0030_doSearchMainForm(Map<String, String> param);

	List<Map<String, Object>> doSearchAdditionalForm(Map<String, String> formData);

	List<Map<String, Object>> ccta0030_doSearchECCM(Map<String, String> formData);

	List<Map<String, Object>> ccta0030_doSearchECMT(Map<String, String> formData);

    void ccta0030_doInsertECCM(Map<String, Object> gridECCM);

	void ccta0030_doInsertECCM2(Map<String, Object> gridECCM);

    void ccta0030_doInsertECMT(Map<String, Object> gridECMT);

	void ccta0030_doInsertECPC(Map<String, Object> gridECPC_hd);

	void ccta0030_doInsertECPY(Map<String, Object> gridECPY);

	void ccta0030_doDeleteECCM(Map<String, String> gridECCM);

	void ccta0030_doDeleteECPC(Map<String, String> gridECPC_hd);

	void ccta0030_doDeleteECPY(Map<String, String> gridECPY);

	void ccta0030_doDeleteECMT(Map<String, String> gridECMT);
	
	// 2021.03.08 기능 추가 : 협력사 계약서 공유
	void ccta0030_doVendorSend(Map<String, String> formData);
	
	// 2021.02.09 기능 추가 : 협력사 재서명 요청
	void ccta0030_doReContract(Map<String, String> formData);
	
    List<Map<String, Object>> cctr0050_doSearch(Map<String, Object> formData);

	List<Map<String, Object>> ccta0030_doSearchECPC_HD(Map<String, Object> gridECCM);

	List<Map<String, Object>> ccta0030_doSearchECPY(Map<String, Object> gridECCM);

	List<Map<String, Object>> ccta0030_doSearchECPC(Map<String, Object> gridECCM);

	void ccta0030_doDeleteAddECRL(Map<String, String> formData);
	
	Map<String, String> ccta0030_guarCancelData(Map<String, String> param);

	void cctr0050_changeContUser(Map<String, Object> grid);

	void cctr0050_doStop(Map<String, Object> grid);
	
	// 2021.08.26 : IT포탈 의뢰번호 등 저장
	void cctr0050_doSave(Map<String, Object> grid);

    List<Map<String, Object>> cctr0051_doSearch(Map<String, String> paramDataMap);

    List<Map<String, Object>> cctr0052_doSearch(Map<String, String> paramDataMap);

    List<Map<String, Object>> cctr0053_doSearch(Map<String, String> paramDataMap);

    List<Map<String, Object>> cctr0054_doSearch(Map<String, String> paramDataMap);
    
    //2021.03.11 협력업체 보증 취소요청 승인
    void cctr0051_doConfirm(Map<String, Object> param);
    
    //2021.03.11 협력업체 보증 취소요청 반려
    void cctr0051_doReject(Map<String, Object> param);
    
    //2021.03.11 협력업체 보증 취소요청 승인/반려처리후 협력사에 메일전송을 위한 계약정보
    List<Map<String, String>> cctr0051_getguarInformation(Map<String, Object> param);
    
    //List<Map<String, String>> cctr0051_getguarInformation(Map<String, String> formData);

	void cctr0050_doFinish(Map<String, Object> grid);

	void cctr0050_doUpdate(Map<String, Object> grid);

	String cctr0050_doResumeCheck(Map<String, Object> rowData);

	void cctr0050_doResume(Map<String, Object> rowData);

	List<Map<String, Object>> cctr0050_doSearchECRL(Map<String, String> param);

	void cctr0050_doResumeECRL(Map<String, Object> ecrlData);

	void cctr0050_doResumeECCM(Map<String, Object> rowData);

	void cctr0050_doResumeECMT(Map<String, Object> rowData);

	void cctr0050_doResumeECPC(Map<String, Object> rowData);

	void cctr0050_doResumeECPY(Map<String, Object> rowData);

    Map<String, String> ccta0040_getBundleContractInfo(Map<String, String> bundleContractInfo);

    void ccta0030_doUpdateECCM(Map<String, Object> formDataObj);

	void ccta0030_doUpdateECCM2(Map<String, Object> formDataObj);

	String ccta0040_isDeleteBundleFlag(Map<String, String> param);

	void ccta0040_doDeleteECCM(Map<String, String> param);

	void ccta0040_doUpdateECCTSignStatus(Map<String, String> param);

	List<Map<String, Object>> ccta0040_getSavedVendorListForBundleContract(Map<String, String> formData);

	List<Map<String, Object>> ccta0040_getVendorListForBundleContract(Map<String, Object> param);

	List<Map<String, Object>> ccta0030_doSearchCNDT(Map<String, Object> formData);
	
	// 2021.05.24 추가
	// 연장계약시 구매의뢰를 기준으로 기존 계약에 대한 연장계약 체결
	List<Map<String, Object>> ccta0030_doSearchPRDT(Map<String, Object> formData);

	String ccta0030_getMaxContCnt();

	String ccta0030_getMaxContCnt(Map<String, String> formData);

    void cctr0051_cctr0053_doSave(Map<String, Object> grid);

	List<Map<String, Object>> ccta0040_getSavedCustListForBundleContract(Map<String, String> formData);

	List<Map<String, Object>> ccta0040_doSearchBundelInfo(Map<String, String> formData);

	void ccta0030_doUpdatePdfUUID(Map<String, Object> param);
	
	void ccta0040_doUpdatePdfUUID(Map<String, Object> param);

	void ccta0030_doDeleteECHB(Map<String, Object> grid);

	Map<String, String> cctr0050_doPdfFileInfo(Map<String, String> param);

    Map<String, String> ccta0030_doSignChk(Map<String, Object> grid);

	List<Map<String, Object>> ccta0030_doSearchPOList(Map<String, String> formData);

	void ccta0030_doUpdatePOHD(Map<String, Object> po);

	void ccta0030_doUpdatePODT(Map<String, Object> po);
	
	// 2021.05.28 IT포탈 연장계약건 계약서 작성 후 구매진행상태=4200
	void setPrProgressCdReCont(Map<String, Object> gridData);
	
	// 2021.01.25 계약체결 완료 후 구매진행상태=4300
	void setPrProgressCdCont(Map<String, String> formData);
	
	// 2021.01.25 발주서 생성 후 구매진행상태=5200
	void setPrProgressCdPo(Map<String, Object> gridData);

	List<Map<String, String>> ccta0030_sendVendorInfo(Map<String, String> formData);

	List<Map<String, String>> ccta0030_sendVendorUserInfo(Map<String, String> formData);

    List<Map<String, String>> ccta0030_sendCustUserInfo(Map<String, String> formData);

	Map<String, String> ccta0040_doSignChk(Map<String, Object> grid);

	void ccta0040_doInsertECSV(Map<String, Object> grid);

    void ccta0030_doUpdateEformJsonData(Map<String, String> param);

    //Map<String, String> ccta0030_doSelectEformJsonData(Map<String, String> formData);
    String ccta0030_doSelectEformJsonData(Map<String, String> formData);
    
	void ccta0040_doUpdateVendorFile(Map<String, String> formData);

	int cctr0030_doSingCnt(Map<String, String> formData);

	void cctr0030_doUpdateECPC_HD(Map<String, String> gridMap);

	int cctr0030_doSearchECSV(Map<String, String> gridMap);
	
	// 2020.11.25 추가
	// -- 단일계약 계약완료 후 지불 고객사별 사용수수료 부과
	Map<String, String> getPrepaymentCust(Map<String, String> formData);
	
	// -- 단일계약 완료 후 협력사에 사용수수료 부과
	Map<String, String> getPrepaymentVendor(Map<String, String> formData);
	
	// -- 위수탁 계약건의 다수계약 완료 후 고객사에게 사용수수료 부과
	List<Map<String, String>> getPrepaymentConsignCust(Map<String, Object> grid);
	
	// -- 위수탁 계약건의 다수계약 완료 후 협력사에게 사용수수료 부과
	Map<String, String> getPrepaymentConsignVendor(Map<String, Object> grid);
	// =========== 고객사별 수수료 종료 =================
	
	List<Map<String, Object>> ccta0030_doSearchPdfNum(Map<String, String> parameterMap);
	
	List<Map<String, Object>> cctr0055_doSearch(Map<String, Object> formData);
	
	Map<String, String> costSmsInfo(Map<String, String> param);
	
	int cctr0030_doBuyerSignCnt(Map<String, String> formData);
	
	
	String cctr0050_getHash(Map<String, Object> grid);
}

