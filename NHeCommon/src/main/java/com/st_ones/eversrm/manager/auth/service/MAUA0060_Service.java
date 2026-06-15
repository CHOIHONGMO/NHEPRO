package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.common.cache.data.ButtonInfoCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0060_Mapper;
import org.apache.commons.lang.StringUtils;
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
 * @File Name : MAUA0060_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0060_Service")
public class MAUA0060_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private ButtonInfoCache buttonInfoCache;

	@Autowired private MAUA0060_Mapper maua0060_Mapper;

	/**
	 * 화면명 : 메뉴/버튼 권한설정
	 * 처리내용 : 시스템에 등록된 직무별 메뉴 접근/버튼 사용 권한을 관리하는 화면.
	 * 경로 : 시스템관리 > 권한 > 메뉴/버튼 권한설정
	 */
	// 사용자조회
	public List<Map<String, Object>> doSearch_UserList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_UserList(param);
	}

	// 직무조회
	public List<Map<String, Object>> doSearch_CtrlList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_CtrlList(param);
	}

	// 메뉴-버튼조회
	public List<Map<String, Object>> doSearch_ButtonList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_ButtonList(param);
	}

	// 메뉴-사용자 권한매핑 현황
	public List<Map<String, Object>> doSearch_Menu_UserList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_Menu_UserList(param);
	}

	// 메뉴-직무 권한매핑 현황
	public List<Map<String, Object>> doSearch_Menu_CtrlList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_Menu_CtrlList(param);
	}

	// 메뉴트리검색
	public List<Map<String, Object>> doSearch_menuTree(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_menuTree(param);
	}

	// 버튼-사용자 권한매핑 현황
	public List<Map<String, Object>> doSearch_Button_UserList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_Button_UserList(param);
	}

	// 버튼-직무 권한매핑 현황
	public List<Map<String, Object>> doSearch_Button_CtrlList(Map<String, String> param) throws Exception {
		return maua0060_Mapper.doSearch_Button_CtrlList(param);
	}

	// 메뉴-직무/사용자 권한등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSave_Menu_Auth(Map<String, String> formData, List<Map<String, Object>> menuGrid, List<Map<String, Object>> historymenuGrid) throws Exception {

		if(menuGrid.size() > 0) {

			// 해당직무에 해당하는 메뉴권한전체삭제
			if(formData.get("CtrlClickYn").equals("Y")){
				formData.put("DATA_TYPE","J");
				formData.put("DATA_CD", formData.get("CTRL_CD"));
				maua0060_Mapper.doDelete_Menu_Auth(formData);
			}
			// USER에 해당하는 메뉴권한전체삭제
			if(formData.get("userClickYn").equals("Y")){
				formData.put("DATA_TYPE","U");
				formData.put("DATA_CD", formData.get("USER_ID"));
				maua0060_Mapper.doDelete_Menu_Auth(formData);
			}

			for (Map<String, Object> Lv1 : menuGrid) {

				List<Map<String, Object>> menuGridLv2 = (List<Map<String, Object>>) Lv1.get("items");
				for (Map<String, Object> Lv2 : menuGridLv2) {
					List<Map<String, Object>> menuGridLv3 = (List<Map<String, Object>>) Lv2.get("items");
					for (Map<String, Object> Lv3 : menuGridLv3) {
						List<Map<String, Object>> menuGridLv4 = (List<Map<String, Object>>) Lv3.get("items");
						for (Map<String, Object> Lv4 : menuGridLv4) {
							// 직무 메뉴권한 저장
							if (formData.get("CtrlClickYn").equals("Y")) {
								// 체크된데이터만
								if (Lv4.get("CTRL_MAPPING_YN").equals("1") && StringUtils.isNotEmpty((String)Lv4.get("SCREEN_ID"))) {
									Lv4.put("DATA_TYPE", "J");
									Lv4.put("DATA_CD", formData.get("CTRL_CD"));
									maua0060_Mapper.doSave_Menu_Auth(Lv4);
								}
							}

							// USER 메뉴권한 저장
							if (formData.get("userClickYn").equals("Y")) {
								//체크된데이터만
								if (Lv4.get("USER_MAPPING_YN").equals("1") && StringUtils.isNotEmpty((String)Lv4.get("SCREEN_ID"))) {
									Lv4.put("DATA_TYPE", "U");
									Lv4.put("DATA_CD", formData.get("USER_ID"));
									maua0060_Mapper.doSave_Menu_Auth(Lv4);
								}
							}
						}
					}
				}
			}
		}

		// 변경된 이력 저장
		for (Map<String, Object> history : historymenuGrid) {
			maua0060_Mapper.doSaveHistory_Menu_Auth(history);
		}
		return msg.getMessage("0031");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSave_Menu_Auth_CTRL(Map<String, String> formData, List<Map<String, Object>> ctrlGrid) throws Exception {

		for (Map<String, Object> gridData : ctrlGrid) {
			gridData.put("SCREEN_ID",formData.get("SCREEN_ID"));
			gridData.put("DATA_TYPE","J");
			gridData.put("DATA_CD",gridData.get("CTRL_CD"));
			gridData.put("ACTION_CD", formData.get("ACTION_CD"));

			// maua0060_Mapper.doSave_Menu_Auth(gridData);
			maua0060_Mapper.doSave_Button_Auth(gridData);

			// 이력저장
			gridData.put("CH_TYPE","C");
			maua0060_Mapper.doSaveHistory_Button_Auth(gridData);
		}
		return msg.getMessage("0001");
	}

	// 버튼-직무/사용자 권한등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSave_Button_Auth(Map<String, String> formData, List<Map<String, Object>> buttonGrid, List<Map<String, Object>> ctrlgrid, List<Map<String, Object>> usergrid) throws Exception {

		for (Map<String, Object> bt : buttonGrid) {
			if(ctrlgrid.size() > 0) {
				for (Map<String, Object> gridData : ctrlgrid) {
					gridData.put("SCREEN_ID", formData.get("SCREEN_ID"));
					gridData.put("ACTION_CD", bt.get("ACTION_CD"));
					gridData.put("DATA_TYPE", "J");
					gridData.put("DATA_CD", gridData.get("CTRL_CD"));
					maua0060_Mapper.doSave_Button_Auth(gridData);

					// 이력저장
					Map<String, Object> grid = new HashMap<String, Object>(gridData);
					grid.put("CH_TYPE","C");
					maua0060_Mapper.doSaveHistory_Button_Auth(grid);
				}
			}

			if(usergrid.size() > 0) {
				for (Map<String, Object> gridData : usergrid) {
					gridData.put("SCREEN_ID", formData.get("SCREEN_ID"));
					gridData.put("ACTION_CD", bt.get("ACTION_CD"));
					gridData.put("DATA_TYPE", "U");
					maua0060_Mapper.doSave_Button_Auth(gridData);

					// 이력저장
					Map<String, Object> grid = new HashMap<String, Object>(gridData);
					grid.put("CH_TYPE","C");
					maua0060_Mapper.doSaveHistory_Button_Auth(gridData);
				}
			}
		}
		//buttonInfoCache.removeData(formData.get("SCREEN_ID"));

		return msg.getMessage("0031");
	}

	// 버튼-직무/사용자 권한삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDelete_Button_Auth(Map<String, String> formData, List<Map<String, Object>> buttonGrid, List<Map<String, Object>> ctrlgrid, List<Map<String, Object>> usergrid) throws Exception {

		for (Map<String, Object> bt : buttonGrid) {
			if(ctrlgrid.size() > 0) {
				for (Map<String, Object> gridData : ctrlgrid) {
					gridData.put("SCREEN_ID", formData.get("SCREEN_ID"));
					gridData.put("ACTION_CD", bt.get("ACTION_CD"));
					gridData.put("DATA_TYPE", "J");
					gridData.put("DATA_CD", gridData.get("CTRL_CD"));
					maua0060_Mapper.doDelete_Button_Auth(gridData);

					// 삭제이력저장
					Map<String, Object> grid = new HashMap<String, Object>(gridData);
					grid.put("CH_TYPE","D");
					maua0060_Mapper.doSaveHistory_Button_Auth(grid);
				}
			}

			if(usergrid.size() > 0) {
				for (Map<String, Object> gridData : usergrid) {
					gridData.put("SCREEN_ID", formData.get("SCREEN_ID"));
					gridData.put("ACTION_CD", bt.get("ACTION_CD"));
					gridData.put("DATA_TYPE", "U");
					maua0060_Mapper.doDelete_Button_Auth(gridData);

					// 삭제이력저장
					Map<String, Object> grid = new HashMap<String, Object>(gridData);
					grid.put("CH_TYPE","D");
					maua0060_Mapper.doSaveHistory_Button_Auth(grid);
				}
			}
		}
		//buttonInfoCache.removeData(formData.get("SCREEN_ID"));
		return msg.getMessage("0017");
	}

}