package com.st_ones.nhepro.OETR;

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
 * @File Name : OETR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface OETR0020_Mapper {

    List<Map<String, Object>> oetr0020_doSearch(Map<String, String> param);

    Map<String, Object> oetr0021_doSearchNoticeInfo(Map<String, String> param);
    void oetr0021_doSaveCount(Map<String, Object> param);
    void oetr0021_doInsert(Map<String, String> formData);
    void oetr0021_doUpdate(Map<String, String> formData);
    void oetr0021_doDelete(Map<String, Object> gridData);
    
    void oetr0051_doUpdateLastFlag(Map<String, String> formData);
    
    List<Map<String, Object>> oetr0060_doSearch(Map<String, String> param);
    
    // 2021.03.04 추가
    Map<String, Object> oetr0061_doSearchNoticeInfo(Map<String, String> param);
}