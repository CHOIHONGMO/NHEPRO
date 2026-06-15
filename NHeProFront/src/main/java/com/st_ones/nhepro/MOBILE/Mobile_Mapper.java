package com.st_ones.nhepro.MOBILE;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface Mobile_Mapper {

    Map<String, String> userIdCheck(Map<String, String> param);

    void certified_update(Map<String, String> param);

    int certified_confirm(Map<String, String> param);

    void certified_confirm_Update(Map<String, String> param);

    Map<String, String> emailCheck(Map<String, String> param);

    void doSave(Map<String, String> param);

    List<Map<String, Object>> MAGG_030_doSearch(Map<String, String> param);

    Map<String, String> MIDPW_010_doSearch(Map<String, String> param);

    void MIDPW_040_resetPassword(Map<String, String> param);

    void MIDPW_010_InsertPW(Map<String, String> userInfo);

    List<Map<String, Object>> MIDPW_040_doSearchUSPW(Map<String, String> param);

    List<Map<String, Object>> mobileHome_contract_list(Map<String, String> param);

    List<Map<String, Object>> mobileHome_doPledge_list(Map<String, String> param);

    List<Map<String, Object>> mobileHome_doNotice_list(Map<String, String> param);

    Map<String, String> mobileHome_checkLeglAgree2(Map<String, String> param);

    void mobile_doOath(Map<String, String> param);

    void mobile_doContract(Map<String, String> param);
    
    // 2020.11.25 추가
 	// -- 개인근로자 전자서명 후 계약 고객사에 수수료 부과
 	Map<String, String> getPrepaymentCust(Map<String, String> param);

    int fileUserCheck(Map<String, String> formData);

    void updateNoticeView(@Param("noticeNo") String noticeNo);

    Map<String, String> selectNotice(@Param("noticeNo") String noticeNo);

    void insertSMS(Map<String, String> param);
}
