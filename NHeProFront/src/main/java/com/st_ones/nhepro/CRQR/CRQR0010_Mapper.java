package com.st_ones.nhepro.CRQR;

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
 * @File Name : CRQR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CRQR0010_Mapper {
	/**
     * 화면명 : 견적현황
     * 처리내용 : 견적현황 조회 및 강제종료 처리
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황
     */
    List<Map<String, Object>> crqr0010_doSearch(Map<String, Object> formData);

    void crqr0010_doForceClosingRQHD(Map<String, Object> param);
    void crqr0010_doForceClosingRQDT(Map<String, Object> param);
    
    // 2021.01.04 견적서 협력사전송 추가
    void crqr0010_doSendVendorRQHD(Map<String, Object> param);
    void crqr0010_doSendVendorRQDT(Map<String, Object> param);
    List<Map<String, String>> getMailList(Map<String, Object> param);
    
    void crqr0010_doUpdateChange(Map<String, Object> param);

    /**
     * 화면명 : 견적요청서 작성
     * 처리내용 : 견적 요청서 작성 및 수정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황
     */
    Map<String, Object> crqi0011_doSearchRQHD(Map<String, String> param);
    List<Map<String, Object>> crqi0011_doSearchPRDT(Map<String, Object> param);
    List<Map<String, Object>> crqi0011_doSearchRQDT(Map<String, String> param);
    List<Map<String, Object>> crqi0011_doSearchRQSE(Map<String, Object> param);
    
    void crqi0011_doInsertRQHD(Map<String, String> param);		// rqhd 등록
    void crqi0011_doUpdateRQHD(Map<String, String> param);		// rqhd 수정
	void crqi0011_doUpdateProgressCdReRoundingDate(Map<String, String> param);	// 재견적시 rqhd 이전차수 진행상태 변경
    void crqi0011_doInsertRQDT(Map<String, Object> param);		// rqdt 등록
    void crqi0011_doUpdateRQDT(Map<String, Object> param);		// rqdt 변경
    
    void updateProgressCdToPR(Map<String, Object> param);		// prdt 진행상태 변경
    void crqi0011_doDeleteRQDT(Map<String, Object> param);		// 견적서 저장시 rqdt 삭제
    void crqi0011_doDeleteRQVN(Map<String, Object> param);
	void crqi0011_doDeleteRQSE(Map<String, Object> param);
    
	void crqi0011_doInsertRQVN(Map<String, Object> param);
	void crqi0011_doInsertRQSE(Map<String, Object> param);
	
	List<Map<String, Object>> getDataOfDONU(Map<String, String> param);
	void insertDONUData(Map<String, Object> param);
	void updateDONUData(Map<String, Object> param);
    
	// 견적서 삭제시 테이블 삭제(RQHD, RQDT, RQVN, RQSE)
	List<Map<String, Object>> getPRDataByRFX(Map<String, String> param);
	void crqi0011_doDeleteFlag(Map<String, String> param);
	
	// 재견적시 견적횟수 체크
	String crqi0011_checkRfqLimitCount(Map<String, String> param);
	// 재견적시 이전차수의 진행상태 체크
	String crqi0011_checkBeforeRfqProgressCd(Map<String, String> param);
	// 재견적시 현재차수의 존재여부 체크
	String crqi0011_checkNextRfqExistYn(Map<String, String> param);
	
	/**
     * 화면명 : 협력업체 견적제출조회
     * 처리내용 : 참여협력업체 조회
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황, 협력업체선정 > 참여협력업체조회
     * 21.06.29 신규 추가
     */
	Map<String, Object> crqi0012_doSearchRQHD(Map<String, String> param);
	
	String getProgressCd(Map<String, String> param);
	
	void crqi0012_doSaveRQHD(Map<String, String> param);
	
	/**
     * 화면명 : 협력업체 견적제출조회
     * 처리내용 : 참여협력업체 조회
     * 경로 : 고객사 > 구매관리 > 견적관리 > 견적현황, 협력업체선정 > 참여협력업체조회
     */
	Map<String, Object> crqr0031_doSearchRQHD(Map<String, String> param);
	List<Map<String, Object>> crqr0031_doSearchDT(Map<String, String> param);

	/**
     * 화면명 : 협력업체선정
     * 처리내용 : 견적서 개찰 및 견적비교
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정
     */
    List<Map<String, Object>> crqa0040_doSearch(Map<String, String> param);

	// 견적서 개찰
    String checkRfqOpenDate(Map<String, Object> gridData);
	String checkRfqOpenStatus(Map<String, Object> gridData);
	List<Map<String, Object>> checkSignDataList(Map<String, Object> param);
	void doOpenRfqProposalOpen(Map<String, Object> gridData);
	void doOpenQTHD(Map<String, Object> gridData);
	void doOpenQTDT(Map<String, Object> gridData);
	void setDecES(Map<String, Object> gridData);
	void setFinalEstmPrcSE(Map<String, Object> gridData);
	
	void crqa0040_doUpdateAppNum(Map<String, Object> gridData);

    /**
     * 화면명 : 단일업체선정 견적비교
     * 처리내용 : 전체 품목에 대해 단일업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 단일업체선정 견적비교
     */
	Map<String, String> doSearchComparisonByTotal_F(Map<String, String> param);
	List<Map<String, Object>> crqi0041_doSearchV(Map<String, String> param);
	List<Map<String, Object>> crqi0041_doSearchI(Map<String, String> param);
	int checkRfqProgressStatusComparisonByTotal(Map<String, Object> formData);
	Map<String, String> checkRfqProgressStatusComparisonByItem(Map<String, Object> formData);
	void doUpdateComparisonByTotal_RQDT(Map<String, Object> formData);
	void doUpdateComparisonByTotal_RQHD(Map<String, Object> formData);
	void doInsertComparisonByTotal_PRHB(Map<String, Object> formData);
	void doUpdateComparisonByTotal_QTDT(Map<String, Object> formData);
	void doUpdateComparisonByTotal_PRDT(Map<String, Object> formData);
	void doUpdateComparisonByTotal_QTDT_F(Map<String, Object> formData);
	List<Map<String, Object>> getRfxQuotationItemList(Map<String, Object> gridData);	// 투찰번호에 해당하는 품목리스트 가져오기
	void doInsertComparisonByTotal_CNHB(Map<String, Object> formData);	// 견적서별 품의대기 등록
	List<Map<String, String>> getDonuList(Map<String, Object> formData);
	void doUpdateDonuNum(Map<String, String> data);

	/**
     * 화면명 : 품목별선정 견적비교
     * 처리내용 : 품목별로 별도의 협력업체 선정
     * 경로 : 고객사 > 구매관리 > 견적관리 > 협력업체선정 > 품목별선정 견적비교
     */
	Map<String, Object> doSearchComparisonByItem_F(Map<String, String> param);
	List<Map<String, Object>> doSearchComparisonByItem_G(Map<String, String> param);
	Map<String, Object> doSearchComparisonSumUnitPrc(Map<String, String> param);
	void doUpdateComparisonByItem_QTDT_Y(Map<String, Object> formData);
	void doUpdateComparisonByItem_QTDT_N(Map<String, Object> formData);
	void doUpdateComparisonByTotal_RQDT_Y(Map<String, Object> formData);
	void doInsertComparisonByItem_CNHB(Map<String, Object> formData);	// 품목별 품의대기 등록

}