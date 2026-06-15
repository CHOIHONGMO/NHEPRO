package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.common.cache.data.BreadCrumbCache;
import com.st_ones.common.cache.data.MulgSaCache;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0030_Mapper;
import com.st_ones.eversrm.manager.screen.MSRA0030_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : MAUA0030Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0030Service")
public class MAUA0030_Service extends BaseService {

	@Autowired private LargeTextService largeTextService;

	@Autowired private MessageService msg;

	@Autowired private DocNumService docNumService;

	@Autowired private MulgSaCache mulgSaCache;

	@Autowired private BreadCrumbCache breadCrumbCache;

	@Autowired private MSRA0030_Mapper msra0030_mapper;

	@Autowired private MAUA0030_Mapper maua0030_mapper;

	/**
	 * 화면명 : 권한프로프알관리
	 * 처리내용 : 화면 접근권한을 등록/수정/삭제/조회할 수 있는 화면
	 * 경로 : 시스템관리 > 권한 > 권한프로파일관리
	 */
	public List<Map<String, Object>> doSearchAuthProfileManagement(Map<String, String> param) {
		return maua0030_mapper.doSearchAuthProfileManagement(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveAuthProfileManagement(List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		for (Map<String, Object> gridData : gridDatas) {

			String docNum = "";
			Map<String, Object> formdata = new HashMap<String, Object>();
			int checkCnt = maua0030_mapper.checkAuthProfileManagement(gridData);

			if (checkCnt == 0) {

				// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
				docNum = docNumService.getDocNumber(userInfo.getCompanyCd(), "AU");
				gridData.put("AUTH_CD", docNum);

				BaseInfo baseInfo = UserInfoManager.getUserInfoImpl();
				String langCd = baseInfo.getLangCd();
				formdata.put("LANG_CD", langCd);
				formdata.put("MULTI_NAME", gridData.get("AUTH_NM"));
				formdata.put("SCREEN_ID", "-");
				formdata.put("DEL_FLAG", "0");
				formdata.put("MULTI_CD", "AU");
				formdata.put("ACTION_PROFILE_CD", "");
				formdata.put("ACTION_CD", "");
				formdata.put("TMPL_MENU_CD", "");
				formdata.put("AUTH_CD", docNum);
				formdata.put("TMPL_MENU_GROUP_CD", "");
				formdata.put("MENU_GROUP_CD", "");
				formdata.put("COMMON_ID", "");
				formdata.put("MULTI_DESC", gridData.get("AUTH_DESC"));

				msra0030_mapper.msra0031_doInsert(formdata);
				mulgSaCache.initData();

				maua0030_mapper.doInsertAuthProfileManagement(gridData);

			} else {
				maua0030_mapper.doUpdateAuthProfileManagement(gridData);
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteAuthProfileManagement(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			maua0030_mapper.doDeleteAuthProfileManagement(gridData);
		}
		return msg.getMessage("0017");
	}

}