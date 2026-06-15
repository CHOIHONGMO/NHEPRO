package com.st_ones.eversrm.manager.screen.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.ButtonInfoCache;
import com.st_ones.common.cache.data.ScrnCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.screen.MSRA0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSRA0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MSRA0010_service")
public class MSRA0010_Service extends BaseService {

	@Autowired private LargeTextService largeTextService;

	@Autowired private MessageService msg;

	@Autowired private ButtonInfoCache buttonInfoCache;

	@Autowired private ScrnCache scrnCache;

	@Autowired private MSRA0010_Mapper msra0010_mapper;

	/**
	 * 화면명 : 화면관리
	 * 처리내용 : 시스템에서 사용하는 화면정보를 관리하는 화면
	 * 경로 : 시스템관리 > 화면 > 화면관리
	 */
	public List<Map<String, Object>> doSearchScreenManagement(Map<String, String> param) {
		return msra0010_mapper.doSearchScreenManagement(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveScreenManagement(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {

			int checkCnt = msra0010_mapper.checkScreenManagement(gridData);
			if (checkCnt == 0) {
				msra0010_mapper.doInsertScreenManagement(gridData);
				scrnCache.removeData();
			} else {
				msra0010_mapper.doUpdateScreenManagement(gridData);
				scrnCache.removeData();
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteScreenManagement(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			msra0010_mapper.doDeleteScreenManagement(gridData);
			scrnCache.removeData();
		}
		return msg.getMessage("0017");
	}

	public List<Map<String, Object>> doSearchScreenIdPopup(Map<String, String> param) {
		return msra0010_mapper.doSearchScreenIdPopup(param);
	}

	public Map<String, String> selectHelpInfo(String paramScreenId) {
		return msra0010_mapper.selectHelpInfo(paramScreenId);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveHelpInfo(Map<String, String> formData) throws Exception {

		formData.put("HELP_TEXT_NUM", largeTextService.saveLargeText(EverString.nullToEmptyString(formData.get("HELP_TEXT_NUM")), formData.get("CONTENTS")));
		msra0010_mapper.updateHelpInfo(formData);

		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteHelpInfo(Map<String, String> formData) throws Exception {
		msra0010_mapper.deleteHelpInfo(formData);
		return msg.getMessage("0001");
	}

}