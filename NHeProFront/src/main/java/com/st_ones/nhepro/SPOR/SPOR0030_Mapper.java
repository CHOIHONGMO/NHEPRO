package com.st_ones.nhepro.SPOR;

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
 * @File Name : SPOR0030_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SPOR0030_Mapper {
    List<Map<String, Object>> spor0030_doSearch(Map<String, String> param);
    
    Map<String, String> spoi0031_doCheckINVData(Map<String, String> formData);
    
    Map<String, Object> spoi0031_doSearch(Map<String, Object> param);
    Map<String, Object> spoi0031_doSearchIVHD(Map<String, String> param);
    List<Map<String, Object>> spoi0031_doSearchPODT(Map<String, Object> param);
    List<Map<String, Object>> spoi0031_doSearchIVDT(Map<String, String> param);
    
    void spoi0031_doUpdatePODT(Map<String, Object> param);
    void spoi0031_doInsertIVHD(Map<String, String> param);
    void spoi0031_doUpdateIVHD(Map<String, String> param);
    void spoi0031_doUpdateSignIVHD(Map<String, String> param);
    void spoi0031_doInsertIVGH(Map<String, String> param);
    void spoi0031_doUpdateIVGH(Map<String, String> param);
    void spoi0031_doDeleteIVDT(Map<String, String> param);
    void spoi0031_doInsertIVDT(Map<String, Object> param);
    void spoi0031_doDeleteFlagIVHD(Map<String, String> param);
    void spoi0031_doDeleteFlagIVDT(Map<String, String> param);
    void spoi0031_doDeleteFlagIVGH(Map<String, String> param);
    
    // 2021.01.27 추가 : 구매진행상태=6100 변경
    void setPrProgressCd(Map<String, Object> param);

    List<Map<String, String>> getMailList(Map<String, String> param);

    List<Map<String, Object>> spor0040_doSearch(Map<String, String> param);
}