package com.st_ones.nhepro.CBDI;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDI0010_Mapper.java
 * @date 2020. 4. 02.
 * @version 1.0
 */

@Repository
public interface CBDI0010_Mapper {

	/**
	 * 화면명 : 입찰공고
	 * 처리내용 : 입찰공고의 생성 이후 입찰등록까지의 입찰공고 목록을 조회하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고
	 */
	List<Map<String, Object>> cbdi0010_doSearch(Map<String, String> param);

	String getPossibleFlag(Map<String, Object> gridData);

	void cbdi0010_doChangeCtrl(Map<String, Object> gridData);
	
	void cbdi0010_doChangeEv(Map<String, Object> gridData);

	/**
	 * 화면명 : 입찰공고생성
	 * 처리내용 : 입찰공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성
	 */
	Map<String, String> cbdi0011_doSearchHD(Map<String, String> param);

	List<Map<String, Object>> cbdi0011_doSearchItemByPr(Map<String, String> param);

	List<Map<String, Object>> cbdi0011_doSearchDT(Map<String, String> param);

	List<Map<String, Object>> cbdi0011_doSearchEU(Map<String, String> param);

	void cbdi0011_doMergeHD(Map<String, String> formData);

	void cbdi0011_doMergePG(Map<String, String> formData);

	void cbdi0011_doDeleteAP(Map<String, String> bidVendor);

	void cbdi0011_doInsertAP(Map<String, String> bidVendor);

	void cbdi0011_doDeleteAllEU(Map<String, String> formData);

	void cbdi0011_doInsertEU(Map<String, Object> gridData);

	void cbdi0011_doDeleteAllDT(Map<String, String> formData);

	void cbdi0011_doInsertDT(Map<String, Object> gridData);

	void cbdi0011_doUpdatePrdtProgressCd(Map<String, Object> gridData);


	void insertDONUData(Map<String, Object> param);

	void cbdi0011_doDeleteBDHD(Map<String, String> param);

	void cbdi0011_doDeleteBDPG(Map<String, String> param);

	void cbdi0011_doDeleteBDAP(Map<String, String> param);

	void cbdi0011_doDeleteBDEU(Map<String, String> param);

	void cbdi0011_doDeleteBDDT(Map<String, String> param);

	List<Map<String, String>> getPrSqs(Map<String, String> param);

	void updatePrProgressCd(Map<String, String> param);

	void setBDESPreCopy(Map<String, String> formData);
	
	/**
	 * 2021.07.05 : 입찰취소공고 삭제
	 * @param param
	 */
	void cbdi0011_doDeleteCompBDHD(Map<String, String> param);

	void cbdi0011_doDeleteCompBDDT(Map<String, String> param);

	void cbdi0011_doDeleteCompBDAP(Map<String, String> param);
	
	/**
	 * 화면명 : 입찰공고상세
	 * 처리내용 : 입찰공고의 상세내용을 조회하는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고상세
	 */
	Map<String, Object>cbdr0012_doSearch(Map<String, String> param);

	/**
	 * 화면명 : 취소공고생성
	 * 처리내용 : (입찰)취소공고를 작성하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 취소공고생성
	 */
	Map<String, String> cbdr0013_doSearchHD(Map<String, String> param);

	void cbdr0013_doCancelBid(Map<String, String> formData);

	void cbdr0013_doCancelBidDT(Map<String, String> formData);
	
	void cbdr0013_doCancelBidAP(Map<String, String> formData);

	void setBidStatusForPreCnt(Map<String, String> formData);

	void cbdr0013_doUpdateBid(Map<String, String> formData);

	void setBDESCopy(Map<String, String> formData);

	/**
	 * 화면명 : 기술평가실행
	 * 처리내용 : 기술평가를 진행하기 위하여 평가자에게 통보하는 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 기술평가실행
	 */
	Map<String, String> cbdr0015_doSearchHD(Map<String, String> param);

	String getMaxProgressCd(Map<String, String> param);

	void cbdr0015_doEval(Map<String, Object> gridData);

	void cbdr0015_setBidStatus(Map<String, String> formData);

	/**
	 * 화면명 : 지명경쟁 협력업체조회
	 * 처리내용 : 입찰요청서를 전송할 업체를 조회하는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
	 */
	List<Map<String, Object>> cbdr0016_doSearchCandidate(Map<String, Object> param);

	/**
	 * 화면명 : 평가템플릿 선택
	 * 처리내용 : 시스템에 등록된 평가템플릿을 조회/선택할 수 있는 Popup 화면.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰공고 > 입찰공고생성 > Popup
	 */
	List<Map<String, Object>> cbdi0016_doSearchEVTD(Map<String, String> param);

	List<Map<String, Object>> cbdi0016_doSearchBDEV(Map<String, String> param);

	List<Map<String, Object>> cbdi0016_doSearchEvalItemMgtDetail1(Map<String, String> param);

	List<Map<String, Object>> cbdi0016_doSearchEvalItemMgtDetail2(Map<String, String> param);

	List<Map<String, Object>> cbdi0016_doSearchBDEI(Map<String, String> param);

	void cbdi0016_doMergeBDEV(Map<String, Object> gridData);

	void cbdi0016_doInsertBDEI(Map<String, Object> gridData);

	void cbdi0016_doDeleteBDEV(Map<String, Object> gridData);

	void cbdi0016_doDeleteBDEI(Map<String, Object> gridData);

	void cbdi0016_doMergeBDEI(Map<String, Object> gridData);

	void cbdi0016_doDeleteR(Map<String, Object> gridData);

	void cbdi0016_doDeleteBDEUGarbage1(Map<String, String> formData);

	void cbdi0016_doDeleteBDEIGarbage2(Map<String, String> formData);

	void cbdi0016_doDeleteBDEVGarbage3(Map<String, String> formData);

	/**
	 * 화면명 : 입찰등록
	 * 처리내용 : 입찰공고 중부터 입찰마감까지의 입찰공고 목록을 조회하여 마감/유찰처리한다.
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록
	 */
	List<Map<String, Object>> cbdi0020_doSearch(Map<String, String> param);

    void cbdi0020_doFailBidding(Map<String, Object> gridData);

    List<Map<String, Object>> cbdi0020_getPrList(Map<String, Object> param);

    void cbdi0020_doUpdatePrProgressCd(Map<String, Object> param);
    
    Map<String, String> cbdi0020_doCheckProgressCd(Map<String, String> param);
    
    Map<String, Object>cbdi0022_doSearch(Map<String, String> param);
    
    String getBidAppStatus(Map<String, String> param);
    
    String getBidStatus(Map<String, String> param);

    String getOriBidStatus(Map<String, String> param);
    
    void cbdi0022_doSaveHD(Map<String, String> param);
    
    void cbdi0022_doSavePG(Map<String, String> param);
    
    void cbdi0022_doSaveRtn(Map<String, String> param);
    
	/**
	 * 화면명 : 입찰등록결과 등록
	 * 처리내용 : 협력업체의 입찰참가자격을 확인하여 입찰등록을 마감하는 화면
	 * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰등록 > 입찰등록결과 등록
	 */
	Map<String, String> cbdi0021_doSearchHD(Map<String, String> param);

	List<Map<String, Object>> cbdi0021_doSearch(Map<String, String> param);

	String getClosePossibleFlag(Map<String, String> param);

	void cbdi0021_doFinalFlagUpdate(Map<String, Object> gridData);

	/**
	 * 공통모듈
	 */
	List<Map<String, String>> getComCodeAndText(Map<String, String> param);

	String getSignStatus(Map<String, String> param);

	void updateAppNum(Map<String, String> formData);
	
}