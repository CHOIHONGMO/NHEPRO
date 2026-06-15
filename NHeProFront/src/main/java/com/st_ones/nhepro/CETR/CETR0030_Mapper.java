package com.st_ones.nhepro.CETR;

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
 * @File Name : CETR0030_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CETR0030_Mapper {

    List<Map<String, Object>> cetr0030_doSearch(Map<String, String> param);

    Map<String, Object> cetr0031_doSearchNoticeInfo(Map<String, String> param);
    void cetr0031_doSaveCount(Map<String, Object> param);
    void cetr0031_doInsert(Map<String, String> formData);
    void cetr0031_doUpdate(Map<String, String> formData);
    void cetr0031_doDelete(Map<String, Object> gridData);
    void cetr0031_doInsertSTOCNOTV(Map<String, String> formData);
    void cetr0031_doDeleteSTOCNOTV(Map<String, String> formData);

}