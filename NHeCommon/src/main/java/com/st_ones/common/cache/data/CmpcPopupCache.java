package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import com.st_ones.common.util.service.UtilService;
import com.st_ones.everf.serverside.config.PropertiesManager;
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
 * @File Name : CmpcPopupCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "cmpcPopupCache")
public class CmpcPopupCache extends DataCacheCommon{

	@Autowired CacheMapper cacheMapper;

	@Autowired UtilService utilService;

	protected Map<String, Map<String, String>> data = new HashMap<String, Map<String, String>>();

	@SuppressWarnings("unchecked")
	@Override
	protected Map<String, Map<String, String>>getCacheData() {
		return data;
	}
	
	public void setDatum(String key, Map<String, String> datum){
		Map<String, Map<String, String>> _data = getCacheData();
		_data.put(key, datum);
	}

	@SuppressWarnings({"rawtypes", "unchecked"})
	public Map<String, String> getData(String commonId) {

		String databaseCode = utilService.getDatabaseCode();

		if(!PropertiesManager.getBoolean("everF.cacheEnable.popup")){
			return cacheMapper.getCommonPopupDetailInfo(commonId, databaseCode);
		}
		
		Map<String, String> commonPopupDetailInfo = getCacheDataByKey(commonId);
		if(commonPopupDetailInfo == null){
			setDatum(commonId, cacheMapper.getCommonPopupDetailInfo(commonId, databaseCode));
			commonPopupDetailInfo = getCacheDataByKey(commonId);
		}
		
		logging("commonId - " + commonId, new MapLogger(commonPopupDetailInfo).toString());
		return commonPopupDetailInfo;
	}
	
	public void removeData(String commonId) {
		removeDatum(commonId);
	}
}