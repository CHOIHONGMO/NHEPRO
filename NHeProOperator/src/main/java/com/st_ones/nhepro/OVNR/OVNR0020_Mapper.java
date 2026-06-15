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
 * @File Name : OVNR0020_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface OVNR0020_Mapper {

    List<Map<String, Object>> ovnr0020_doSearch(Map<String, String> param);
    void ovnr0020_doDelete(Map<String, Object> param);

    Map<String, Object> ovnr0021_doSearch(Map<String, String> param);
    void ovnr0021_doSave(Map<String, String> param);
    void ovnr0021_doDelete(Map<String, String> param);
    void ovnr0021_doDeleteUserComm(Map<String, String> param);
    void ovnr0021_doPasswordInit(Map<String, String> param);

}