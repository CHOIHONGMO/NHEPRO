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
 * @File Name : SVNR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface SVNR0010_Mapper {

    Map<String, Object> svnr0010_doSearch(Map<String, String> param);
    List<Map<String, Object>> svnr0010_doSearchVNSL(Map<String, String> param);
    List<Map<String, Object>> svnr0010_doSearchVNAP(Map<String, String> param);
    List<Map<String, Object>> svnr0010_doSearchATTD(Map<String, String> param);
    List<Map<String, Object>> svnr0010_doSearchVNCM(Map<String, String> param);
    int svnr0010_doSearchCntVNCM(Map<String, String> param);

    void svnr0010_doUpdate(Map<String, String> formData);
    void svnr0010_doMergeVNFI(Map<String, String> formData);
    
    void svnr0010_doUpateCorp(Map<String, String> formData);
    void svnr0010_doUpateBrc(Map<String, String> formData);
    void svnr0010_doUpateDept(Map<String, String> formData);
    
    void svnr0010_doInsertVNSL(Map<String, String> formData);
    void svnr0010_doUpdateVNSL(Map<String, String> formData);
    void svnr0010_doDeleteVNSL(Map<String, String> formData);

    void svnr0010_doInsertVNAP(Map<String, String> formData);
    void svnr0010_doUpdateVNAP(Map<String, String> formData);
    void svnr0010_doDeleteVNAP(Map<String, String> formData);

    void svnr0010_doInsertVNCM(Map<String, String> formData);
    void svnr0010_doUpdateVNCM(Map<String, String> formData);
    void svnr0010_doDeleteVNCM(Map<String, String> formData);
    void svnr0010_doUpdateReqVNCM(Map<String, String> formData);
    List<Map<String, Object>> getBrUserList(Map<String, String> param);

    void svnr0010_doMergeATTS(Map<String, String> param);
    void svnr0010_doDeleteATTS(Map<String, String> formData);
    
    Map<String, String> costSmsInfo(Map<String, Object> param);
}