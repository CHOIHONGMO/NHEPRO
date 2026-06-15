package com.st_ones.eversrm.manager.menu.service;

import java.util.List;
import java.util.Map;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.BreadCrumbCache;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.menu.MNUA0020_Mapper;

/**
* <pre>
******************************************************************************
* 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
* ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
* ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
* (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
******************************************************************************
* </pre>
* @File Name : MNUA0020_Service.java
* @date 2013. 07. 22.
* @version 1.0
*/

@Service(value = "MNUA0020_Service")
public class MNUA0020_Service extends BaseService {

	@Autowired private DocNumService docNumService;

	@Autowired private MessageService msg;

	@Autowired private BreadCrumbCache breadCrumbCache;

	@Autowired private MNUA0020_Mapper mnua0020_mapper;

	/**
	 * 화면명 : 메뉴그룹관리
	 * 처리내용 : 시스템에 등록된 메뉴템플릿들을 조합하여 사용자에게 부여 할 메뉴그룹을 관리하는 화면.
	 * 경로 : 시스템관리 > 메뉴 > 메뉴그룹관리
	 */
	public List<Map<String, Object>> searchMenu(Map<String, String> param) {
		return mnua0020_mapper.searchMenu(param);
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveMenu(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {

			if (String.valueOf(gridData.get("INSERT_FLAG")).equals("C")) {
				// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
				String docNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "MG");
				gridData.put("MENU_GROUP_CD", docNum);
				mnua0020_mapper.createMenu(gridData);
			}
			else if (String.valueOf(gridData.get("INSERT_FLAG")).equals("U")) {
				mnua0020_mapper.updateMenu(gridData);
			}
		}
		breadCrumbCache.initData();
		return msg.getMessage("0001");
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doCopyMenu(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {
			String oldMenuGroupCd = (String)gridData.get("MENU_GROUP_CD");
			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			String newMenuGroupCd = docNumService.getDocNumber(userInfo.getCompanyCd(), "MG");
			gridData.put("MENU_GROUP_CD", newMenuGroupCd);
			mnua0020_mapper.createMenu(gridData);
			gridData.put("OLD_MENU_GROUP_CD", oldMenuGroupCd);
			mnua0020_mapper.copyMenuMums(gridData);
		}
		breadCrumbCache.initData();
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String updateMenu(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mnua0020_mapper.updateMenu(gridData);
		}
		breadCrumbCache.initData();
		return msg.getMessage("0001");
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String deleteMenu(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mnua0020_mapper.deleteMenuMums(gridData);
			mnua0020_mapper.deleteMenu(gridData);
		}
		breadCrumbCache.initData();
		return msg.getMessage("0017");
	}

}