package com.st_ones.eversrm.manager.basic.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.cache.data.CodeCache;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverAuthorityIgnore;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.basic.MBSA0020_Mapper;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : MBSA0020_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MBSA0020_Service")
public class MBSA0020_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private CodeCache codeCache;

	@Autowired private MBSA0020_Mapper mbsa0020_mapper;

	/**
	 * 화면명 : 코드관리
	 * 처리내용 : 시스템에서 사용하는 공통코드를 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 코드관리
	 */
	public List<Map<String, Object>> doSearchHD(Map<String, String> param) {
		return mbsa0020_mapper.doSearchHD(param);
	}

	@SuppressWarnings("rawtypes")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveHD(List<Map<String, Object>> gridDatas) throws Exception {

		Map<String, Object> param = new HashMap<String, Object>();
		String newKey = mbsa0020_mapper.getNewKey(param);

		for (Map<String, Object> gridData : gridDatas) {

			gridData.put("CODE_TYPE", EverString.isEmpty(String.valueOf(gridData.get("CODE_TYPE"))) || gridData.get("CODE_TYPE") == null ? newKey : gridData.get("CODE_TYPE"));

			int checkCnt = mbsa0020_mapper.checkHDData(gridData);
			// checkCnt = 0 : new Insert, checkCnt = 1 : Update, checkCnt = 2 : Select Insert

			if (checkCnt == 0) {
				mbsa0020_mapper.doInsertHD(gridData);
			} else if (checkCnt == 1) {
				mbsa0020_mapper.doUpdateHD(gridData);
				codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
			} else if (checkCnt == 2) {
				int transCnt = mbsa0020_mapper.doSelectInsertHD(gridData);
				if (transCnt < 1) {
					throw new EverException(msg.getMessageForService(this, "exception_msg"));
				}
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteHD(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {

			mbsa0020_mapper.doDeleteHD(gridData);

			mbsa0020_mapper.doDeleteDT(gridData);

			codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
		}
		return msg.getMessage("0017");
	}

	public List<Map<String, Object>> doSearchDT(Map<String, String> param) {
		return mbsa0020_mapper.doSearchDT(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveDT(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {

			if (mbsa0020_mapper.checkConstraintR31(gridData) == 0) {
				throw new NoResultException(msg.getMessageForService(this, "exception_msg"));
			}

			int checkCnt = mbsa0020_mapper.checkDTData(gridData);
			// checkCnt = 0 : new Insert, checkCnt = 1 : Update, checkCnt = 2 : Select Insert

			if (checkCnt == 0) {
				mbsa0020_mapper.doInsertDT(gridData);
				codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
			} else if (checkCnt == 1) {
				mbsa0020_mapper.doUpdateDT(gridData);
				codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
			} else if (checkCnt == 2) {
				int transCnt = mbsa0020_mapper.doSelectInsertDT(gridData);
				codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
				if (transCnt < 1) {
					throw new NoResultException(msg.getMessageForService(this, "exception_msg"));
				}
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDeleteDT(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mbsa0020_mapper.doDeleteDT(gridData);
			codeCache.refreshData((String) gridData.get("CODE_TYPE"), (String) gridData.get("LANG_CD"));
		}
		return msg.getMessage("0017");
	}

	@EverAuthorityIgnore
	public List<Map<String, String>> getSTOCCODEByCodeType(String codeType, String langCd) {
		return codeCache.getData(codeType, langCd);
	}

	@EverAuthorityIgnore
	public List<Map<String, String>> getSTOCCODEByCodeType(String codeType, String[] columnIds) {

		String langCd = UserInfoManager.getUserInfo().getLangCd();
		List<Map<String, String>> stocCodeByCodeType = getSTOCCODEByCodeType(codeType, langCd);
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();

		for (Map<String, String> stcoCode : stocCodeByCodeType) {
			Map<String, String> map = new HashMap<String, String>();
			for (String columnId : columnIds) {
				map.put(columnId, stcoCode.get(columnId));
			}
			list.add(map);
		}
		return list;
	}

	@EverAuthorityIgnore
	public String getCodeValue(String codeType, String code) {

		String langCd = UserInfoManager.getUserInfo().getLangCd();
		List<Map<String, String>> codes = getSTOCCODEByCodeType(codeType, langCd);
		for (Map<String, String> map : codes) {
			if (map.get("CODE").equals(code)) {
				return map.get("CODE_DESC");
			}
		}
		getLog().error(String.format("code value is not exist. codeType: %s, code: %s", codeType, code));
		return null;
	}

	public List<Map<String, String>> getCodeCombo(String codeType) {

		List<Map<String, String>> list = new ArrayList<Map<String, String>>();

		Map<String, String> param = new HashMap<String, String>();
		param.put("CODE_TYPE", codeType);
		param.put("LANG_CODE", UserInfoManager.getUserInfo().getLangCd());

		List<Map<String, String>> codes = mbsa0020_mapper.getComCodeAndText(param);
		for (Map<String, String> code : codes) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("value", code.get("CODE"));
			map.put("text", code.get("CODE_DESC"));
			list.add(map);
		}
		return list;
	}

}