package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import com.st_ones.common.generator.domain.GridMeta;
import com.st_ones.everf.serverside.config.PropertiesManager;
import org.apache.commons.beanutils.BeanMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
 * @File Name : BottomBarInfoCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "bottomBarInfoCache")
public class BottomBarInfoCache extends DataCacheCommon {

	@Autowired private CacheMapper cacheMapper;

	protected Map<String, List<GridMeta>> data = new HashMap<String, List<GridMeta>>();
	
	@SuppressWarnings("unchecked")
	@Override
	protected Map<String, List<GridMeta>> getCacheData() {
		return data;
	}

	@SuppressWarnings({"unchecked", "rawtypes"})
	public List<GridMeta> getData(String langCode) {
		if(PropertiesManager.getBoolean("wisef.cacheEnable.grid") == false){
			return cacheMapper.getBottomBarInfos(langCode);
		}
		
		List<GridMeta> bottomBarInfos = getCacheDataByKey(langCode);
		if (bottomBarInfos == null) {
			setDatum(langCode, cacheMapper.getBottomBarInfos(langCode));
			bottomBarInfos = getCacheDataByKey(langCode);
		}
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (GridMeta bottomBarInfo : bottomBarInfos) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.putAll(new BeanMap(bottomBarInfo));
			map.remove("ses");
			map.remove("class");
			list.add(map);
		}
		
		logging(String.format("langCode: %s ", langCode), new MapLogger(list).toString());
		return bottomBarInfos;
	}

	public void removeData(String langCode) {
		removeDatum(langCode);
	}
}