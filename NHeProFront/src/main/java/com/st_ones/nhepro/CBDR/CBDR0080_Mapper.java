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
 * @File Name : CBDR0080_Mapper.java
 * @date 2020. 5. 27.
 * @version 1.0
 */

@Repository
public interface CBDR0080_Mapper {

    /**
     * 화면명 : 기술평가진행현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황
     */
    List<Map<String, Object>> cbdr0080_doSearch(Map<String, String> param);

    /**
     * 화면명 : 기술평가등록
     * 처리내용 : 협력업체별 평가를 수행하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가진행 > 기술평가진행현황 > 기술평가등록
     */
    List<Map<String, Object>> cbdr0081_doSearch(Map<String, String> param);

    String cbdr0081_getEiSqList(Map<String, String> param);

    List<Map<String, Object>> cbdr0081_getHtmlTypeA(Map<String, String> param);

    List<Map<String, Object>> cbdr0081_getHtmlTypeB(Map<String, Object> param);

    List<Map<String, Object>> cbdr0081_getHtmlTypeC(Map<String, Object> param);

    void cbdr0081_doMergeResult(Map<String, Object> data);

    String getCompliteFlag(Map<String, Object> data);

    void cbdr0081_doCompliteET(Map<String, Object> data);

    String getFinishPossibleFlag(Map<String, Object> data);

    void cbdr0081_doFinishEU(Map<String, Object> data);

    void cbdr0081_doEvExceptET(Map<String, Object> data);

    void cbdr0081_doCompleteEvel(Map<String, String> data);

    List<Map<String, Object>> cbdr0081_getEtResults(Map<String, String> data);

    void cbdr0081_doInsertSP(Map<String, Object> data);

    /**
     * 화면명 : 기술평가결과현황
     * 처리내용 : 평가자로 지정된 사용자가 배정된 평가건을 조회, 평가할 수 있는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 기술평가결과 > 기술평가결과현황
     */
    List<Map<String, Object>> cbdr0090_doSearch(Map<String, String> param);
    
    void cbdr0090_doUserChange(Map<String, Object> data);

}