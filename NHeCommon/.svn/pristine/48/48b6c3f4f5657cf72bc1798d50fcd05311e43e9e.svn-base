package com.st_ones.eversrm.manager.basic.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverAuthorityIgnore;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.basic.MBSA0040_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
 * @File Name : MBSA0040_Service.java
 * @date 2020. 03. 12.
 * @version 1.0
 * @see
 */

@Service(value = "mbsa0040_Service")
public class MBSA0040_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private MBSA0040_Mapper mbsa0040_Mapper;

	/**
	 * 화면명 : 첨부파일 템플릿 관리
	 * 처리내용 : 업무화면에서 사용하는 첨부파일들의 항목들을 템플릿으로 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 첨부파일 템플릿 관리
	 */
	public List<Map<String, Object>> mbsa0040_doSearchHD(Map<String, String> param) {
		return mbsa0040_Mapper.mbsa0040_doSearchHD(param);
	}

    public List<Map<String, Object>> mbsa0040_doSearchDT(Map<String, String> param) {
        return mbsa0040_Mapper.mbsa0040_doSearchDT(param);
    }

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0040_doSaveHD(List<Map<String, Object>> gridDatas) throws Exception {

		Map<String, Object> param = new HashMap<String, Object>();

		for (Map<String, Object> gridData : gridDatas) {

		    String tmplNum = String.valueOf(gridData.get("TMPL_NUM"));

		    if(EverString.nullToEmptyString(tmplNum).equals("") || EverString.nullToEmptyString(tmplNum).equals("null")) {
                String newKey = mbsa0040_Mapper.getNewKey(gridData);
                gridData.put("TMPL_NUM", newKey);
                mbsa0040_Mapper.mbsa0040_doInsertHD(gridData);
            }
		    else {
				mbsa0040_Mapper.mbsa0040_doUpdateHD(gridData);
            }
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0040_doDeleteHD(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {

			mbsa0040_Mapper.mbsa0040_doDeleteHD(gridData);

			mbsa0040_Mapper.mbsa0040_doDeleteDT(gridData);
		}
		return msg.getMessage("0017");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0040_doSaveDT(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mbsa0040_Mapper.mbsa0040_doMergeDT(gridData);
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0040_doDeleteDT(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mbsa0040_Mapper.mbsa0040_doDeleteTempSq(gridData);
		}
		return msg.getMessage("0017");
	}

}