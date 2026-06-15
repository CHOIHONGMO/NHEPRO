package com.st_ones.nosession.index.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
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

		String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
		rtnMap.put("NOTICE_CONTENTS", splitString);

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

    public Map<String, String> mainNoticeDetail(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeDetail(param);
    }

    public int mainNoticeTotalCount(Map<String, String> param) throws Exception {
        return indexMapper.mainNoticeTotalCount(param);
    }

}
