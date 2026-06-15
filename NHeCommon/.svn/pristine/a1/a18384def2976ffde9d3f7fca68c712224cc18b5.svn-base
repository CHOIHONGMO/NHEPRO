package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import org.springframework.beans.factory.annotation.Autowired;
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
 * @File Name : MulgPopupInfoCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "mulgPopupInfoCache")
public class MulgPopupInfoCache extends DataCacheCommon{

	@Autowired private CacheMapper cacheMapper;

	protected Map<String, List<Map<String,String>>> data = new HashMap<String, List<Map<String,String>>>();

	@SuppressWarnings("unchecked")
	@Override
	protected Map<String, List<Map<String,String>>> getCacheData() {
		return data;
	}

	@SuppressWarnings({"unchecked", "rawtypes"})
	public List<Map<String,String>> getData(String commonId, String langCode) {
		if(!PropertiesManager.getBoolean("everF.cacheEnable.popup")){
			return cacheMapper.getMULGCommonPopupInfo(commonId, langCode, null);
		}
		List<Map<String,String>> popupInfo = getCacheDataByKey(commonId + langCode);
		if(popupInfo == null){
			setDatum(commonId+langCode, cacheMapper.getMULGCommonPopupInfo(commonId, langCode, null));
			popupInfo = getCacheDataByKey(commonId + langCode);
		}
		
		logging(String.format("commonId: %s, langCode: %s", commonId, langCode), new MapLogger(popupInfo).toString());
		return popupInfo;
	}

	public void removeData(String commonId, String langCode) {
		removeDatum(commonId + langCode);
	}
}