package com.st_ones.nhepro.SVNR;

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
 * @File Name : SVNR0030_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SVNR0030_Mapper {

    List<Map<String, Object>> svnr0030_doSearch(Map<String, String> param);
    void svnr0030_doSave(Map<String, Object> param);
    void svnr0030_doDelete(Map<String, Object> param);
    void svnr0030_doDeleteUserComm(Map<String, Object> param);

    Map<String, Object> svnr0031_doSearch(Map<String, String> param);
    void svnr0031_doInsertCVUR(Map<String, String> param);
    void svnr0031_doUpdateCVUR(Map<String, String> param);
    String svnr0031_doDupChkUserId(Map<String, String> param);
    int svnr0031_dupChkPassword(Map<String, String> param);
    
    void svnr0031_doInsertUserComm(Map<String, String> data);
    void svnr0031_doInsertUserBasic(Map<String, String> data);
    void svnr0031_doInsertBrcDetail(Map<String, String> data);
    void svnr0031_doUpdateUserComm(Map<String, String> param);

}