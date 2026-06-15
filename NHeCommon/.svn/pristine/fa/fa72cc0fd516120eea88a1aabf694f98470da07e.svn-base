package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUB0010_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
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
 * @File Name : MAUB0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "maub0010_Service")
public class MAUB0010_Service extends BaseService {

    @Autowired private MAUB0010_Mapper maub0010_Mapper;

    /**
     * 화면명 : 사용자별-직무매핑 이력
     * 처리내용 : 사용자에게 직무를 매핑한 이력을 조회하는 화면
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑 이력
     */
    public List<Map<String, Object>> doSelect(Map<String, String> param) {

        Map<String, Object> fParam = new HashMap<String, Object>(param);
        fParam.put("CTRL_NM_LIST", Arrays.asList(param.get("CTRL_NM").split(",")));

        return maub0010_Mapper.doSelect(fParam);
    }

}