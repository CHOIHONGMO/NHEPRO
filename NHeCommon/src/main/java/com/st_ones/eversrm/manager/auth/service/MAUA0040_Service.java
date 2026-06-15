package com.st_ones.eversrm.manager.auth.service;

import java.util.List;
import java.util.Map;

import com.st_ones.common.cache.data.BreadCrumbCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.AuthorizedButtonCache;
import com.st_ones.common.cache.data.ButtonInfoCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0040_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MAUA0040_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0040_Service")
public class MAUA0040_Service extends BaseService {

    @Autowired private AuthorizedButtonCache authorizedButtonCache;

    @Autowired private ButtonInfoCache buttonInfoCache;

    @Autowired private MessageService msg;

    @Autowired private BreadCrumbCache breadCrumbCache;

    @Autowired private MAUA0040_Mapper maua0040_mapper;

    /**
     * 화면명 : 메뉴-권한 매핑
     * 처리내용 : 시스템에 등록된 권한프로파일코드에 메뉴를 매핑하여 해당 권한을 가진 사용자에게 노출될 메뉴들을 정의하는 화면.
     * 경로 : 시스템관리 > 권한 > 메뉴-권한 매핑
     */
    public List<Map<String, Object>> doSearchLMenuAuthMapping(Map<String, String> param) {
        return maua0040_mapper.doSearchLMenuAuthMapping(param);
    }

    public List<Map<String, Object>> doSearchRMenuAuthMapping(Map<String, String> param) {
        return maua0040_mapper.doSearchRMenuAuthMapping(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String doSaveMenuAuthMapping(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            if ("I".equals(gridData.get("INSERT_FLAG"))) {
                maua0040_mapper.doInsertMenuAuthMapping(gridData);
            }
        }
        breadCrumbCache.initData();
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String doDeleteMenuAuthMapping(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {
            maua0040_mapper.doDeleteMenuAuthMapping(gridData);
        }
        breadCrumbCache.initData();
        return msg.getMessage("0017");
    }

}