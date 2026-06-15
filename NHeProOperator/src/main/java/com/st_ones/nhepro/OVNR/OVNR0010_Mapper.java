package com.st_ones.nhepro.OVNR;

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
 * @File Name : OVNR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface OVNR0010_Mapper {

    List<Map<String, Object>> ovnr0010_doSearch(Map<String, String> param);
    void ovnr0010_doBlock(Map<String, Object> param);
    void ovnr0010_doBlockRemove(Map<String, Object> param);
    
    Map<String, Object> ovnr0011_doSearch(Map<String, String> param);
    List<Map<String, Object>> ovnr0011_doSearchVNSL(Map<String, String> param);
    List<Map<String, Object>> ovnr0011_doSearchVNAP(Map<String, String> param);
    List<Map<String, Object>> ovnr0011_doSearchATTD(Map<String, String> param);
    List<Map<String, Object>> ovnr0011_doSearchVNCM(Map<String, String> param);

}