package com.st_ones.nhepro.CPOI;

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
 * @File Name : CPOI0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CPOI0010_Mapper {
    Map<String, Object> cpoi0010_doSearch(Map<String, Object> param);
    List<Map<String, Object>> cpoi0010_doSearchMTGL(Map<String, Object> param);
    Map<String, Object> cpoi0010_doSearchPOHD(Map<String, String> param);
    List<Map<String, Object>> cpoi0010_doSearchPODT(Map<String, String> param);
    List<Map<String, Object>> cpoi0010_doSearchPOPY(Map<String, String> param);
    List<Map<String, Object>> cpoi0010_doSearchPOPC(Map<String, Object> param);
    void cpoi0010_doInsertPOHD(Map<String, String> param);
    void cpoi0010_doUpdatePOHD(Map<String, String> param);
    void cpoi0010_doUpdatePOHB(Map<String, Object> param);
    void cpoi0010_doInsertPODT(Map<String, Object> param);
    void cpoi0010_doDeleteItemPODT(Map<String, Object> param);
    void cpoi0010_doUpdatePODT(Map<String, Object> param);
    void cpoi0010_doInsertPOPY(Map<String, Object> param);
    void cpoi0010_doUpdatePOPY(Map<String, Object> param);
    void cpoi0010_doInsertPOPC(Map<String, Object> param);
    void cpoi0010_doUpdatePOPC(Map<String, Object> param);
    void cpoi0010_doDeletePOHD(Map<String, String> param);
    void cpoi0010_doDeletePODT(Map<String, String> param);
    void cpoi0010_doDeletePOPY(Map<String, String> param);
    void cpoi0010_doDeletePOPC(Map<String, String> param);

    List<Map<String, Object>> cpoi0011_doSearch(Map<String, String> param);
    void cpoi0011_doDeletePOHB(Map<String, Object> param);
    void cpoi0011_doUpdatePRDT(Map<String, Object> param);

    List<Map<String, Object>> cpor0020_doSearch(Map<String, String> param);
    void cpor0020_doClosingPOHD(Map<String, Object> param);
    void cpor0020_doClosingPODT(Map<String, Object> param);
    void cpor0020_doUpdateChange(Map<String, Object> param);
    // 2021.03.11 검수담당자변경 추가
    void cpor0020_doUpdateChangeINV(Map<String, Object> param);
    // 2021.09.16 검수유형 추가
    void cpor0020_doUpdateDelivery(Map<String, Object> param);
    String cpor0020_doCheckDelivery(Map<String, Object> param);

    List<Map<String, Object>> cpor0030_doSearch(Map<String, String> param);

    List<Map<String, Object>> cpor0040_doSearch(Map<String, String> param);

}