package com.st_ones.eversrm.manager.screen.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.AuthorizedButtonCache;
import com.st_ones.common.cache.data.ButtonInfoCache;
import com.st_ones.common.cache.data.ScrnCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.screen.MSRA0020_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSRA0020_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MSRA0020_service")
public class MSRA0020_Service extends BaseService {

	@Autowired private AuthorizedButtonCache authorizedButtonCache;

	@Autowired private MessageService msg;

	@Autowired private ButtonInfoCache buttonInfoCache;

	@Autowired private ScrnCache scrnCache;

	@Autowired private MSRA0020_Mapper msra0020_mapper;

	/**
	 * 화면명 : 화면액션관리
	 * 처리내용 : 시스템에서 사용되는 화면 안에 존재하는 버튼들을 관리하는 화면
	 * 경로 : 시스템관리 > 화면 > 화면액션관리
	 */
	public List<Map<String, Object>> doSearchScreenActionManagement(Map<String, String> param) {
		return msra0020_mapper.doSearchScreenActionManagement(param);
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveScreenActionManagement(List<Map<String, Object>> gridDatas) throws Exception {

		List<Map<String, String>> availableButtonCodeList = msra0020_mapper.getAvailableButtonCodeList();
		List<String> codeList = new ArrayList<String>();
		List<String> codeAndNameList = new ArrayList<String>();

		for (Map<String, String> rowData : availableButtonCodeList) {
			codeList.add(rowData.get("CTRL_CD"));
			codeAndNameList.add("   "+rowData.get("CTRL_CD")+ "  ("+ rowData.get("CTRL_NM") + ")\n");
		}

		for (Map<String, Object> gridData : gridDatas) {

			if(StringUtils.isNotEmpty((String)gridData.get("BUTTON_AUTH"))) {

				String buttonAuth = (String)gridData.get("BUTTON_AUTH");
				String[] bas = buttonAuth.split(",");
				for (String ba : bas) {
					if(!codeList.contains(ba)) {
						String[] t = codeAndNameList.toArray(new String[codeAndNameList.size()]);
						throw new EverException("Couldn't update data.\n* Available button auth codes are: \n\n"+StringUtils.join(t, ",").replaceAll(",", ""));
					}
				}
			}

			String screenId = (String)gridData.get("SCREEN_ID");

			int checkCnt = msra0020_mapper.checkScreenActionManagement(gridData);
			if (checkCnt > 0) {
				msra0020_mapper.doUpdateScreenActionManagement(gridData);
				authorizedButtonCache.removeDataContainKey(screenId);
				buttonInfoCache.removeData(screenId);
			} else {
				msra0020_mapper.doInsertScreenActionManagement(gridData);
				authorizedButtonCache.removeDataContainKey(screenId);
				buttonInfoCache.removeData(screenId);
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteScreenActionManagement(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			msra0020_mapper.doDeleteScreenActionManagement(gridData);
			String screenId = (String)gridData.get("SCREEN_ID_ORI");
			authorizedButtonCache.removeDataContainKey(screenId);
			buttonInfoCache.removeData(screenId);
		}
		return msg.getMessage("0017");
	}

}