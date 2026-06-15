package com.st_ones.nhepro.SAPR;

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
 * @File Name : SAPR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SAPR0010_Mapper {
    List<Map<String, Object>> sapr0010_doSearch(Map<String, String> param);

    void sapr0010_doUpdatePODT(Map<String, Object> param);
    void sapr0010_doSaveReject(Map<String, Object> param);

    Map<String, Object> sapi0011_doSearch(Map<String, String> param);
    Map<String, Object> sapi0011_doSearchIVHD(Map<String, String> param);
    List<Map<String, Object>> sapi0011_doSearchIVDT(Map<String, String> param);
    List<Map<String, Object>> sapi0011_doSearchIVAP(Map<String, String> param);
    List<Map<String, Object>> sapi0011_doSearchPOPC(Map<String, Object> param);
    List<Map<String, String>> getMailList(Map<String, String> param);
    void sapi0011_doInsertIVAP(Map<String, String> param);
    void sapi0011_doUpdateIVAP(Map<String, String> param);
    void sapi0011_doUpdateSignIVAP(Map<String, String> param);
    void sapi0011_doUpdatePODT(Map<String, Object> param);
    void sapi0011_doDeleteFlagIVAP(Map<String, String> param);
    
    // 2021.01.27 추가 : 구매진행상태=7300 변경
    void setPrProgressCd(Map<String, Object> param);

    List<Map<String, Object>> sapr0020_doSearch(Map<String, String> param);
    
    List<Map<String, Object>> sapr0030_doSearchVNAP(Map<String, String> param);

}