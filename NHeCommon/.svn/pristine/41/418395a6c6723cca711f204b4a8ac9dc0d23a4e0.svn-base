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
 * @File Name : AuthorizedButtonCache.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "authorizedButtonCache")
public class AuthorizedButtonCache extends DataCacheCommon {

	@Autowired CacheMapper cacheMapper;

	protected Map<String, List<Map<String, String>>> data = new HashMap<String, List<Map<String, String>>>();

	@SuppressWarnings("unchecked")
	@Override
	protected Map<String, List<Map<String, String>>> getCacheData() {
		return data;
	}
	
	private String getAuthAction() {
		return PropertiesManager.getString("eversrm.auth.action");
	}
	
	@SuppressWarnings({"unchecked", "rawtypes"})
	public List<Map<String, String>> getData(String screenId, String actionAuthCd) {
		
		if(getAuthAction().equals("disabled")){
			actionAuthCd = "notUse";
		}	
		
		if (!PropertiesManager.getBoolean("everF.cacheEnable.button")) {
			return cacheMapper.getAuthorizedButtonCd(screenId, actionAuthCd);
		}

		List<Map<String, String>> authorizedButtonCd = getCacheDataByKey(screenId + actionAuthCd);

		if (authorizedButtonCd == null) {
			setDatum(screenId + actionAuthCd, cacheMapper.getAuthorizedButtonCd(screenId, actionAuthCd));
			authorizedButtonCd = getCacheDataByKey(screenId + actionAuthCd);
		}

		logging(String.format("screenId: %s, actionAuthCd: %s", screenId, actionAuthCd), new MapLogger(authorizedButtonCd).toString());
		return authorizedButtonCd;
	}

	public void removeData(String screenId, String actionAuthCd) {
		removeDatum(screenId + actionAuthCd);
	}

	public void removeDataContainKey(String screenId) {
		removeDatumContainKey(screenId);
	}

}