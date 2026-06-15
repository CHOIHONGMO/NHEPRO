package com.st_ones.nhepro.SETR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverMath;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.SETR.SETR0020_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
 * @File Name : SETR0020_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SETR0020_Service")
public class SETR0020_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SETR0020_Mapper setr0020_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired private DocNumService docNumService;

    /**
     * 화면명 : 공지사항
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 조회/삭제하는 화면.
     * 경로 : 협력업체 > My Page > My Page > 공지사항
     */
    public List<Map<String, Object>> setr0020_doSearch(Map<String, String> param) {
        return setr0020_mapper.setr0020_doSearch(param);
    }

    /**
     * 화면명 : 공지사항 작성
     * 처리내용 : 시스템 사용자들을 위한 공지사항을 작성하는 화면.
     * 경로 : 협력업체 > My Page > My Page > 공지사항 > 신규등록 (팝업), 상세 (팝업)
     */
    public Map<String, Object> setr0021_doSearchNoticeInfo(Map<String, String> param) throws Exception {
        Map<String, Object> rtnMap = setr0020_mapper.setr0021_doSearchNoticeInfo(param);

        String splitString = largeTextService.selectLargeText(String.valueOf(rtnMap.get("NOTICE_TEXT_NUM")));
        rtnMap.put("NOTICE_CONTENTS", splitString);

        if (param.get("detailView").equals("true")) {
            double cnt = Double.parseDouble(String.valueOf(rtnMap.get("VIEW_CNT"))) + 1;
            rtnMap.put("VIEW_CNT", Double.toString(cnt));

            setr0020_mapper.setr0021_doSaveCount(rtnMap);
        }

        rtnMap.put("VIEW_CNT", EverMath.EverNumberType(String.valueOf(rtnMap.get("VIEW_CNT")), "###,###"));

        return rtnMap;
    }

}
