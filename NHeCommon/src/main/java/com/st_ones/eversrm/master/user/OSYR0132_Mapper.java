package com.st_ones.eversrm.master.user;

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
 * @File Name : OSYR0132_Mapper.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */
public interface OSYR0132_Mapper {

    /**
     * 화면명 : 개인정보요청 처리현황
     * 처리내용 : 개인정보 열람 요청에 대한 처리현황을 조회하는 화면.
     * 경로 : 시스템관리 > 사용자관리 > 개인정보요청 처리현황
     */
    List<Map<String,Object>> osyr0132_doSearch(Map<String, String> param) throws Exception;

    void osyr0132_doUpdate(Map<String, Object> rowData) throws Exception;

}

