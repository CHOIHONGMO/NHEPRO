package com.st_ones.nosession.index.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.nosession.index.IndexMapper;

@Service
public class IndexService extends BaseService {

    @Autowired
    IndexMapper indexMapper;

    @Autowired
    LargeTextService largeTextService;

    public List<Map<String, String>> getNoticeList(List<Map<String, String>> noticeList) throws Exception {
        List<Map<String, String>> noticeList1 = indexMapper.getNoticeList(noticeList);
        for (Map<String, String> datum : noticeList1) {
            datum.put("CONTENTS", largeTextService.selectLargeText(datum.get("NOTICE_TEXT_NUM")));
        }

        return noticeList1;
    }

    /**
     * 공지사항 팝업 목록
     * @param noticeList
     * @return
     * @throws Exception
     */
    public List<Map<String, String>> getNoticeListPopup(List<Map<String, String>> noticeList) throws Exception {
        return indexMapper.getNoticeListPopup(noticeList);
    }

    /**
     * 공지사항 상세정보
     * @return
     * @throws Exception
     */
    public Map<String, Object> getNoticePopupInfo(Map<String, String> param) throws Exception {
    	Map<String, Object> rtnMap = indexMapper.getNoticePopupInfo(param);
    	
    	String splitString = "";
    	if( rtnMap != null && rtnMap.size() > 0 ) {
    		String textNum = EverString.nullToEmptyString(rtnMap.get("NOTICE_TEXT_NUM"));
    		splitString = largeTextService.selectLargeText(textNum);
    		
    		rtnMap.put("NOTICE_CONTENTS", splitString);
    	}

    	return rtnMap;
    }
    
    /**
     * 2021.02.16 추가
     * 사업자 ASP 이용계약서 및 사용자 개인정보/서비스이용약관 동의서 상세정보 가져오기
     * @return
     * @throws Exception
     */
    public Map<String, Object> getSystemAgreeInfo(Map<String, String> param) throws Exception {
    	//String CompanyCd = "";
    	
    	//CompanyCd = param.get("COMPANY_CD");
    	
    	param.put("OPERATOR_CD", PropertiesManager.getString("eversrm.default.company.code"));
    	
		/*
		 * if(CompanyCd.equals("C00009")) { System.out.println("===== 중앙회IT전락본부 =====");
		 * param.put("ASP_NOTICE_NUM", "NT202300012"); } else
		 * if(CompanyCd.equals("C00066")) { System.out.println("===== 중앙회 =====");
		 * param.put("ASP_NOTICE_NUM", "NT202200004"); } else {
		 * System.out.println("===== 그외 고객사 ====="); param.put("ASP_NOTICE_NUM",
		 * "NT202300011"); }
		 */
    	
    	Map<String, Object> rtnMap = indexMapper.getSystemAgreeInfo(param);
    	
    	String splitString = "";
    	if( rtnMap != null && rtnMap.size() > 0 ) {
    		String textNum = EverString.nullToEmptyString(rtnMap.get("NOTICE_TEXT_NUM"));
    		splitString = largeTextService.selectLargeText(textNum);
    		
    		rtnMap.put("NOTICE_CONTENTS", splitString);
    	}
		
    	return rtnMap;
    }
    
    /**
     * 공지사항 메인화면 목록
     * @return
     * @throws Exception
     */
    public List<Map<String, String>> getNoticeListMain(List<Map<String, String>> param) throws Exception {
        return indexMapper.getNoticeListMain(param);
    }

    /**
     * 운영사 메인 목록
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> mainNoticeList(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeList(param);
    }

    public List<Map<String, Object>> mainNoticeList2(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeList2(param);
    }

    public Map<String, String> mainNoticeDetail(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeDetail(param);
    }

    public int mainNoticeTotalCount(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeTotalCount(param);
    }

    public int mainNoticeTotalCount2(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeTotalCount2(param);
    }

    public List<Map<String, String>> cbdi0010_doSearch_Main(List<Map<String, String>> cbdi0010_doSearch) {
        return indexMapper.cbdi0010_doSearch_Main();
    }

    public List<Map<String, Object>> mainNoticeDetail_File(Map<String, String> param) {
        return indexMapper.mainNoticeDetail_File(param);
    }
}
