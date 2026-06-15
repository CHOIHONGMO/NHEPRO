package com.st_ones.nhepro.CETR;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
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
 * @File Name : CETR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CETR0010_Mapper {

    List<Map<String, Object>> cetr0010_doSearchG(Map<String, String> param);

    void cetr0010_doSaveG(Map<String, Object> gridData);

    void cetr0010_doDeleteG(Map<String, Object> gridData);

    HashMap<String, String> selectUser(Map<String, String> param);

    HashMap<String, String> selectUserCS(Map<String, String> param);

    void doUpdate(Map<String, String> formData);

    void doUpdateCS(Map<String, String> formData);

    HashMap<String, String> getDateFormatValue(Map<String, String> formData);

}