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
 * @File Name : CPOR0050_Mapper.java
 * @date 2018. 01. 30.
 * @version 1.0
 */
@Repository
public interface CPOR0050_Mapper {
    List<Map<String, Object>> cpor0050_doSearch(Map<String, String> param);
    void cpor0050_doUpdateChangePOHD(Map<String, Object> param);
    void cpor0050_doUpdateIVHD(Map<String, Object> param);
    void cpor0050_doUpdateIVGH(Map<String, Object> param);

    Map<String, Object> cpor0051_doSearchIVHD(Map<String, String> param);
    List<Map<String, Object>> cpor0051_doSearchIVDT(Map<String, String> param);
    List<Map<String, Object>> cpor0051_doSearchIVGH(Map<String, String> param);
    List<Map<String, Object>> cpor0051_doSearchPOPC(Map<String, String> param);
    List<Map<String, Object>> cpor0051_getPayCntSumAmt(Map<String, String> param);
    void cpor0051_doUpdateApprovalIVHD(Map<String, String> param);
    void cpor0051_doUpdateIVPC(Map<String, Object> param);
    void cpor0051_doInsertIVPC(Map<String, Object> param);
    // 2021.09.06 : 정산담당자 변경시 발주서의 정산담당자도 함께 변경 추가
    void cpor0051_doUpdatePOPC(Map<String, Object> param);
    // 2021.11.23 : 대금지급요청서의 대금지급상태가 지급완료 이전까지 고객사 첨부파일은 변경 가능
    void cpor0051_doUpdateFileInfo(Map<String, String> param);
    
    // 2021.01.20 : 검수요청서 고객사 반송 추가
    void cpor0051_setInvRejectIVHD(Map<String, String> param);
	void cpor0051_setInvRejectIVGH(Map<String, String> param);
	void cpor0051_setInvRejectPODT(Map<String, String> param);
	
    List<Map<String, Object>> cpor0060_doSearch(Map<String, String> param);
    void cpor0060_doUpdateCancelINVHD(Map<String, Object> param);
    void cpor0060_doUpdateCancelIVPC(Map<String, Object> param);
    void cpor0060_doUpdateCancelPODT(Map<String, Object> param);

}
