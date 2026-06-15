package com.st_ones.eversrm.manager.basic.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.basic.MBSA0030_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBSA0030_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "mbsa0030_Service")
public class MBSA0030_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private MBSA0030_Mapper mbsa0030_Mapper;

	/**
	 * 화면명 : 휴일관리
	 * 처리내용 : System에서 사용하는 휴일(Working Day)을 등록/관리한다.
	 * 경로 : 시스템관리 > 기본정보 > 휴일관리
	 */
	public List<Map<String, Object>> mbsa0030_doSearch(Map<String, String> param) {

		Map<String, Object> fParam = new HashMap<String, Object>(param);
		Map<String, Object> fParamAll = new HashMap<String, Object>(param);
		List<Map<String, Object>> search_form_list = new ArrayList<Map<String, Object>>();

		if(EverString.isNotEmpty(param.get("YEAR"))) { fParamAll.put("sYEAR", Arrays.asList(param.get("YEAR").split(","))); }
		if(EverString.isNotEmpty(param.get("MONTH"))) { fParamAll.put("sMONTH", Arrays.asList(param.get("MONTH").split(","))); }
		if(EverString.isNotEmpty(param.get("HOLYDAY_TYPE"))) { fParamAll.put("sHOLYDAY_TYPE", Arrays.asList(param.get("HOLYDAY_TYPE").split(","))); }

		search_form_list.add(fParamAll);

		fParam.put("SEARCH_FORM_LIST", search_form_list);

		return mbsa0030_Mapper.mbsa0030_doSearch(fParam);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0030_doSave(List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {
			int checkID = mbsa0030_Mapper.mbsa0030_doCheck(gridData);
			if (checkID > 0) {
				throw new Exception(msg.getMessage("0034")); // 이미 등록된 정보가 있습니다.
			}
			mbsa0030_Mapper.mbsa0030_doSave(gridData);
		}
		return msg.getMessage("0031");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String mbsa0030_doDelete(List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {
			mbsa0030_Mapper.mbsa0030_doDelete(gridData);
		}
		return msg.getMessage("0017");
	}

}
