package com.st_ones.common.cache.data;

import com.st_ones.common.cache.CacheMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
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
 * @File Name : MulgMtCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "mulgMtCache")
public class MulgMtCache extends DataCacheCommon {

	@Autowired private CacheMapper cacheMapper;

	protected Map<String, String> data = new HashMap<String, String>();

	@SuppressWarnings("unchecked")
	@Override
	protected Map<String, String> getCacheData() {
		return data;
	}

	public String getData(String tmplMenuCode) throws UserInfoNotFoundException {

		String langCd = UserInfoManager.getUserInfo().getLangCd();
		if (!PropertiesManager.getBoolean("everF.cacheEnable.breadCrumb")) {
			return cacheMapper.getMulgMt(tmplMenuCode, langCd, "MT");
		}
		
		if(data.size() == 0){
			loadAllData();
		}
		String menuName = getCacheDataByKey(tmplMenuCode + langCd);
		if (menuName == null) {
			setDatum(tmplMenuCode + langCd, cacheMapper.getMulgMt(tmplMenuCode, langCd, "MT"));
			menuName = getCacheDataByKey(tmplMenuCode + langCd);
		}
		logging(String.format("screenId: %s, langCd: %s", tmplMenuCode, langCd), menuName);
		return menuName;
	}
	
	public void removeData(String tmplMenuCode, String langCd){
		removeDatum(tmplMenuCode + langCd);
	}

	private void setDatum(String key, String value) {
		data.put(key, value);
		
	}
	
	public void loadAllData() {
		String[] langCds = {"EN","KO","VI"};
		for (String langCd : langCds) {
			List<Map<String,String>> icommulgMtAll = cacheMapper.getMulgMtAll(langCd, "MT");
			for (Map<String, String> map : icommulgMtAll) {
				String tmplMenuCode = map.get("TMPL_MENU_CODE");
				setDatum(tmplMenuCode+langCd, map.get("MULTI_NAME"));
			}
		}
	}
}