package com.st_ones.nhepro.SETR;

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
 * @File Name : CETR0040_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SETR0040_Mapper {

    List<Map<String, Object>> setr0040_doSearch(Map<String, String> param);
    void setr0040_doSave(Map<String, Object> param);

    Map<String, Object> setr0041_doSearch(Map<String, String> param);
    void setr0041_doInsert(Map<String, String> param);
    void setr0041_doUpdate(Map<String, String> param);
    void setr0041_doUpdate2(Map<String, String> param);
    void setr0041_doDelete(Map<String, String> param);
    List<Map<String, String>> setr0041_getSelectBACP(Map<String, String> param);
    
    // 2021.07.13 : 협력사 VOC등록 완료시 요청고객사에 SMS수수료 부과
    Map<String, String> costSmsInfo(Map<String, String> param);
}