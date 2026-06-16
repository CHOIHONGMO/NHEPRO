package com.st_ones.nhepro.LLM;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * ******************************************************************************
 * </pre>
 * @File Name : LLM0010_Mapper.java
 * @date 2026.06.16
 * @version 1.0
 */
public interface LLM0010_Mapper {

    /**
     * AI 가격 정보 조회 (팝업)
     * 품목별 과거 AI 조회 이력 조회
     */
    List<Map<String, Object>> llm0010_doSearch(Map<String, String> formData);

    /**
     * AI 가격 정보 조회 (팝업)
     * AI 분석 결과 이력 적재
     */
    int llm0010_doInsertHistory(Map<String, Object> param);

    /**
     * AI 결과 데이터 목록 조회
     * 전체 AI 추천 결과 이력 조회
     */
    List<Map<String, Object>> llm0020_doSearch(Map<String, String> formData);

}
