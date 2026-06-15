package com.st_ones.common.menu.service;

import com.st_ones.common.menu.MenuMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
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
 * @File Name : MenuService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "menuService")
public class MenuService extends BaseService {

	@Autowired private MenuMapper menuMapper;

	public List<Map<String, Object>> getScreenInfo(Map<String, String> param) throws Exception {
		return menuMapper.getScreenInfo(param);
	}

	public List<Map<String, Object>> getLeftMenu(Map<String, String> params) throws Exception {

		String sslFlag = PropertiesManager.getString("ever.ssl.use.flag");
		params.put("SSL_FLAG", sslFlag);
		return menuMapper.getLeftMenu(params);
	}

	public List<Map<String, Object>> getScreenInfo2(Map<String, String> param) throws Exception {
		return menuMapper.getScreenInfo2(param);
	}

	public void setBookmark(String templateMenuCd, String bookmarkMode) throws Exception {

		if(StringUtils.equals(bookmarkMode, "true")) {
			try {
				menuMapper.insertBookmark(templateMenuCd);
			} catch(SQLException e) {
				if(e.getErrorCode() == 1400) {
					throw new Exception("즐겨찾기하실 수 없는 화면입니다.");
				}
			}
		} else {
			menuMapper.deleteBookmark(templateMenuCd);
		}
	}
}
