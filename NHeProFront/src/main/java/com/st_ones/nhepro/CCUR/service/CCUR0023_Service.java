package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0023_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : CCUR0021_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "CCUR0023_Service")
public class CCUR0023_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private CCUR0023_Mapper ccur0023_mapper;

    /**
     * 화면명 : 품목분류-속성매핑
     * 처리내용 : 시스템에 등록된 품목분류를 조회하는 화면.
     * 경로 : 품목관리 > 품목분류/SG > 품목분류-속성매핑
     */
    public List<Map<String, Object>> ccur0023_doSearch_ItemClassPopup_TREE(Map<String, String> param) {
        return ccur0023_mapper.ccur0023_doSearch_ItemClassPopup_TREE(param);
    }

    public List<Map<String, Object>> ccur0023_doSearch(Map<String, String> param) throws Exception {
        return ccur0023_mapper.ccur0023_doSearch(param);
    }
}