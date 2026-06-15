package com.st_ones.nhepro.CSTR;

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
 * @File Name : CSTR0010_Mapper.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Repository
public interface CSTR0010_Mapper {

    /**
     * 화면명 : 공급사 입찰이력
     * 처리내용 : 입찰이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 입찰이력
     */
    List<Map<String, Object>> cstr0010_doSearch(Map<String, String> param);

    /**
     * 화면명 : 대금지급이력
     * 처리내용 : 검수 및 대금지급 이력조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 대금지급이력
     */
    List<Map<String, Object>> cstr0020_doSearch(Map<String, String> param);
    
    /**
     * 화면명 : 공급사 견적이력
     * 처리내용 : 견적이력 조회
     * 경로 : 고객사 > 통계관리 > 통계관리 > 공급사 견적이력
     */
    List<Map<String, Object>> cstr0030_doSearch(Map<String, String> param);

}