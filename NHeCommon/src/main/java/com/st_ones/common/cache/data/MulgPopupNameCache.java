package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
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
 * @File Name : MulgPopupNameCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "mulgPopupNameCache")
public class MulgPopupNameCache extends DataCacheCommon {

    @Autowired private CacheMapper cacheMapper;

    protected Map<String, String> data = new HashMap<String, String>();

    @Override
    protected Map<String, String> getCacheData() {
        return data;
    }

    public String getData(String screenId, String multiCd) throws UserInfoNotFoundException {

        String langCd = UserInfoManager.getUserInfo().getLangCd();
        if (!PropertiesManager.getBoolean("everF.cacheEnable.breadCrumb")) {
            return cacheMapper.getMulgPopupName(screenId, multiCd, langCd);
        }

        String popupName = getCacheDataByKey(screenId + multiCd + langCd);
        if (popupName == null) {
            String queriedPopupName = cacheMapper.getMulgPopupName(screenId, multiCd, langCd);

            setDatum(screenId + multiCd + langCd, queriedPopupName == null ? "" : queriedPopupName);
            popupName = getCacheDataByKey(screenId + multiCd + langCd);
        }
        logging(String.format("screenId: %s, multiCd %s, langCd: %s", screenId, multiCd, langCd), popupName);
        return popupName;
    }

    public void removeData(String screenId, String multiCd, String langCd) {
        removeDatum(screenId + multiCd + langCd);
    }

    private void setDatum(String key, String value) {
        data.put(key, value);
    }
}