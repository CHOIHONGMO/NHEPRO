package com.st_ones.common.generator.service;

import com.st_ones.common.generator.QueryGenMapper;
import com.st_ones.everf.serverside.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
 * @File Name : QueryGenService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "queryGenService")
public class QueryGenService extends BaseService {

    @Autowired QueryGenMapper queryGenMapper;

    public String generateSearchCondition(Map<String, String> param) {
        return queryGenMapper.generateSearchCondition(param);
    }

}