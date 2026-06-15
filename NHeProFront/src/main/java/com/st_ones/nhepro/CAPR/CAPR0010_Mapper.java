package com.st_ones.nhepro.CAPR;

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
 * @File Name : CAPR0010_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CAPR0010_Mapper {
    List<Map<String, Object>> capr0010_doSearch(Map<String, Object> formData);
    // 2021.11.17 : 정산담당자 변경시 대금지급요청서의 정산담당자도 함께 변경 추가
    void capr0010_doUpdateChangeIVAP(Map<String, Object> param);
    void capr0010_doUpdateChangeIVHD(Map<String, Object> param);
    void capr0010_doUpdatePayRegIVAP(Map<String, Object> param);
    void capr0010_doUpdatePayRegPODT(Map<String, Object> param);
    // 2021.09.06 : 정산담당자 변경시 발주서의 정산담당자도 함께 변경 추가
    void capr0010_doUpdatePOPC(Map<String, Object> param);
    
    Map<String, Object> capr0011_doSearchIVHD(Map<String, String> param);
    List<Map<String, Object>> capr0011_doSearchIVDT(Map<String, String> param);
    List<Map<String, Object>> capr0011_doSearchIVAP(Map<String, String> param);
    List<Map<String, Object>> capr0011_doSearchIVGH(Map<String, String> param);
    List<Map<String, Object>> capr0011_getPayCntSumAmt(Map<String, String> param);
    void capr0011_doUpdateIVAP(Map<String, String> param);
    void capr0011_doRejectIVAP(Map<String, String> param);
    void capr0011_doRejectPODT(Map<String, Object> param);
    void capr0011_doUpdateApprovalIVAP(Map<String, String> param);
    // 2021.11.18 : Multi 결재상신 추가
    void capr0010_doUpdateApprovalIVAP(Map<String, String> param);
    
    // 2021.01.27 추가 : 구매진행상태=8200 변경
    void setPrProgressCd(Map<String, Object> param);
    
    // 2024.03.21 추가 : PDF_ATT_FILE_NUM STOCIVAP에 저장
    void capr0011_doUpdatePdfUUID(Map<String, Object> param);
    
}