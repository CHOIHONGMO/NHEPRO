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
 * @File Name : SPOR0050_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SPOR0050_Mapper {
    List<Map<String, Object>> spor0050_doSearch(Map<String, String> param);
    String spor0050_doIvhCheck(Map<String, Object> param);
    
    Map<String, Object> spoi0051_doSearch(Map<String, Object> param);
    Map<String, Object> spoi0051_doSearchIVHD(Map<String, String> param);
    List<Map<String, Object>> spoi0051_doSearchIVGH(Map<String, String> param);
    List<Map<String, Object>> spoi0051_doSearchIVDT(Map<String, String> param);
    List<Map<String, Object>> spoi0051_doSearchPODT(Map<String, Object> param);
    List<Map<String, Object>> spoi0051_doSearchPOPC(Map<String, String> param);
    void spoi0051_doUpdatePODT(Map<String, Object> param);
    void spoi0051_doInsertIVHD(Map<String, String> param);
    void spoi0051_doUpdateIVHD(Map<String, String> param);
    void spoi0051_doUpdateSignIVHD(Map<String, String> param);
    void spoi0051_doInsertIVGH(Map<String, String> param);
    void spoi0051_doUpdateIVGH(Map<String, String> param);
    void spoi0051_doDeleteIVDT(Map<String, String> param);
    void spoi0051_doInsertIVDT(Map<String, Object> param);
    void spoi0051_doDeleteFlagIVHD(Map<String, String> param);
    void spoi0051_doDeleteFlagIVDT(Map<String, String> param);
    void spoi0051_doDeleteFlagIVGH(Map<String, String> param);
    List<Map<String, Object>> spoi0051_getPayCntSumAmt(Map<String, String> param);
    
    // 2021.01.27 추가 : 구매진행상태=6100 변경
    void setPrProgressCd(Map<String, Object> param);
    
    List<Map<String, String>> getMailList(Map<String, String> param);

    List<Map<String, Object>> spor0060_doSearch(Map<String, String> param);
}