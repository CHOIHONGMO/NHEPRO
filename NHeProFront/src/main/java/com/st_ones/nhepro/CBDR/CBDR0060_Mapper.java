package com.st_ones.nhepro.CBDR;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CBDR0060_Mapper.java
 * @date 2020. 6. 23.
 * @version 1.0
 */
@Repository
public interface CBDR0060_Mapper {

    /**
     * 화면명 : 선정품의대기목록
     * 처리내용 : 낙찰된 협력업체에 대한 선정품의를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목록
     */
    List<Map<String, Object>> cbdr0060_doSearch(Map<String, String> param);

    String cbdr0060_getCancelPossibleFlag(Map<String, Object> data);
    
    String cbdr0060_getConfirmProgressFlag(Map<String, Object> data);

    List<Map<String, Object>> cbdr0060_getTargetList(Map<String, Object> data);

    void cancelBDHD(Map<String, Object> gridData);

    void cancelBDVO(Map<String, Object> gridData);

    void cancelPRDT(Map<String, Object> gridData);

    void deleteCNHB(Map<String, Object> gridData);
    
    // 견적 업체 선정 취소
    void doUpdateProgressRQHD(Map<String, Object> gridData);
    
	void doUpdateProgressRQDT(Map<String, Object> gridData);
	
	void doUpdateSettleQTDT(Map<String, Object> gridData);
	
	void doDeleteCNHB(Map<String, Object> gridData);
	
	List<Map<String, Object>> doSearchRqdt(Map<String, Object> param);
	
	void doUpdateInitJungGa(Map<String, Object> gridData);
	
	void doUpdateProgressItemRQDT(Map<String, Object> gridData);

    String cbdr0060_getPrcPossibleFlag(Map<String, Object> data);

    void doUpdateAdjPrcStatus(Map<String, Object> gridData);

    /**
     * 화면명 : 선정품의작성
     * 처리내용 : 협력업체 선정 품의서를 작성하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의대기목 > 선정품의작성
     */
    Map<String, String> cbdi0061_doSearchHD(Map<String, String> param);

    List<Map<String, Object>> cbdi0061_doSearchVDByRfx(Map<String, String> param);

    List<Map<String, Object>> cbdi0061_doSearchVD(Map<String, String> param);

    List<Map<String, Object>> cbdi0061_doSearchDTByRfx(Map<String, String> param);

    List<Map<String, Object>> cbdi0061_doSearchDT(Map<String, String> param);

    void cbdi0061_doMergeHD(Map<String, String> formData);

    void cbdi0061_doMergeVD(Map<String, Object> gridDataV);

    void cbdi0061_doDeleteAllDT(Map<String, String> formData);

    void cbdi0061_doInsertDT(Map<String, Object> gridDataI);

    void cbdi0061_doDeleteCNHB(Map<String, Object> gridDataI);

    void updateAppNum(Map<String, String> formData);

    void cbdi0061_doDeleteHD(Map<String, String> formData);

    void cbdi0061_doDeleteVD(Map<String, String> formData);

    void cbdi0061_doDeleteDT(Map<String, String> formData);

    void cbdi0061_doInsertHB(Map<String, Object> gridData);

    /**
     * 화면명 : 선정품의현황
     * 처리내용 : 작성된 품의 목록을 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 품의관리 > 선정품의현황
     */
    List<Map<String, Object>> cbdr0070_doSearch(Map<String, String> param);

    /**
     * 공통모듈
     */
    String getSignStatus(Map<String, String> param);

}