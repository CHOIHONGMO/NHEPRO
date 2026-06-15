package com.st_ones.nhepro.CVNR;

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
 * @File Name : CVNR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CVNR0010_Mapper {

    List<Map<String, Object>> cvnr0010_doSearch(Map<String, String> param);

    Map<String, Object> cvnr0011_doSearch(Map<String, String> param);
    List<Map<String, Object>> cvnr0011_doSearchCVUR(Map<String, String> param);
    List<Map<String, Object>> cvnr0011_doSearchVNSL(Map<String, String> param);
    List<Map<String, Object>> cvnr0011_doSearchVNAP(Map<String, String> param);
    List<Map<String, Object>> cvnr0011_doSearchATTD(Map<String, String> param);
    List<Map<String, Object>> cvnr0011_doSearchVNCM(Map<String, String> param);

    void cvnr0011_doConfirm(Map<String, String> formData);
    void cvnr0011_doUpdateCvur(Map<String, String> formData);
    void cvnr0011_doUpdateVngl(Map<String, String> formData);
    void cvnr0011_doReject(Map<String, String> formData);

    Map<String, String> cvnr0011_vendorUserId(Map<String, String> param);
    List<Map<String, Object>> vendorUserList(Map<String, String> param);
    List<Map<String, Object>> cvnr0020_doSearch(Map<String, String> param);
    Map<String, String> costSmsInfo(Map<String, String> param);
    
    Map<String, String> cvnr0011_corpList(Map<String, String> param);
    Map<String, String> cvnr0011_corpDeptList(Map<String, String> param);
    void cvnr0011_doInsertCorp(Map<String, String> data);
    void cvnr0011_doInsertBrc(Map<String, String> data);
    void cvnr0011_doInsertBrcDetail(Map<String, String> data);
    void cvnr0011_doInsertDept(Map<String, String> data);
    void cvnr0011_doInsertDeptCust(Map<String, String> data);
    
    List<Map<String, Object>> cnvr0011_userList(Map<String, String> param);
    void cnvr0011_doInsertUserComm(Map<String, Object> data);
    void cnvr0011_doInsertUserBasic(Map<String, Object> data);
    void cnvr0011_doInsertUserDetail(Map<String, Object> data);
    

}