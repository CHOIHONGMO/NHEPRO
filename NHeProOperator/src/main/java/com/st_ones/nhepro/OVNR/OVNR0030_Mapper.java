package com.st_ones.nhepro.OVNR;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : OVNR0030_Mapper.java
 * @date 2020. 09. 16.
 * @version 1.0
 */
@Repository
public interface OVNR0030_Mapper {

    List<Map<String, Object>> ovnr0030_doSearch(Map<String, String> param);
    
    void ovnr0030_doReject(Map<String, Object> grid);
}