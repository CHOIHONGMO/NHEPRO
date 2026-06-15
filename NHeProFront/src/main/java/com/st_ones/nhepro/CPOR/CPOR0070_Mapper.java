package com.st_ones.nhepro.CPOR;

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
 * @File Name : CPOR0070_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CPOR0070_Mapper {
    List<Map<String, Object>> cpor0070_doSearch(Map<String, String> param);
    void cpor0070_doUpdateChangePOHD(Map<String, Object> param);
    void cpor0070_doUpdateIVHD(Map<String, Object> param);
    void cpor0070_doUpdateIVGH(Map<String, Object> param);

    Map<String, Object> cpor0071_doSearchIVHD(Map<String, Object> param);
    List<Map<String, Object>> cpor0071_doSearchIVDT(Map<String, String> param);
    List<Map<String, Object>> cpor0071_doSearchIVGH(Map<String, String> param);
    List<Map<String, Object>> cpor0071_doSearchPOPC(Map<String, String> param);
    List<Map<String, Object>> cpor0071_getPayCntSumAmt(Map<String, String> param);
    void cpor0071_doUpdateApprovalIVHD(Map<String, String> param);
    void cpor0071_doUpdateApprovalIVGH(Map<String, String> param);
    void cpor0071_doUpdateApprovalGRDT(Map<String, Object> param);
    void cpor0071_doUpdateIVPC(Map<String, Object> param);
    void cpor0071_doInsertIVPC(Map<String, Object> param);
    // 2021.09.06 : 정산담당자 변경시 발주서의 정산담당자도 함께 변경 추가
    void cpor0071_doUpdatePOPC(Map<String, Object> param);

    List<Map<String, Object>> cpor0080_doSearch(Map<String, String> param);

}