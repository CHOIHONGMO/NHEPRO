package com.st_ones.eversrm.manager.org;

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
 * @File Name : MOGA0031Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Repository
public interface MOGA0031_Mapper {

    /**
     * 화면명 : 조직관리 (Tree)
     * 처리내용 : 조직(부서)을 조회/관리한다.
     * 경로 : 시스템관리 > 조직관리 > 조직관리2 (Tree)
     */
    List<Map<String, Object>> MOGA0031_doSelect_deptTree(Map<String, String> param);

    void MOGA0031_updateDEPTData(Map<String, Object> gridData);

}
