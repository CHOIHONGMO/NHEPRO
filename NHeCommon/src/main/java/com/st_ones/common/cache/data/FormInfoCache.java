package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.HashMap;
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
 * @File Name : FormInfoCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "formInfoCache")
public class FormInfoCache {

    @Autowired ScrnCache scrnCache;

    @Autowired CacheMapper cacheMapper;

    protected Map<String, List<Map<String, String>>> data = new HashMap<String, List<Map<String, String>>>();

    protected Map<String, List<Map<String, String>>> getCacheData() {
        return data;
    }

    @Cacheable("formCache")
    public List<Map<String, String>> getData(String screenId, String langCd) {
        return cacheMapper.getFormInfo(screenId, langCd);
    }

    public String getExcelDownMode(String screenId) throws Exception {
        return scrnCache.getExcelDownMode(screenId);
    }

    @CacheEvict(value = "formCache")
    public void removeData(String screenId, String langCd) {}

    @CacheEvict(value = "formCache", allEntries = true)
    public void removeAllCaches() {}

    public Map<String, Object> getScreenApprovalType(String screenId) {
        return cacheMapper.getScreenApprovalType(screenId);
    }

    public Map<String, Object> getMaskInfo(String screenId, String accessDate) {
        return cacheMapper.getMaskInfo(screenId, accessDate);
    }

}