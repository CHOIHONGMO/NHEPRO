package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUB0020_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
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
 * @File Name : MAUB0020Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUB0020_Service")
public class MAUB0020_Service extends BaseService {

	/* @formatter:off */
	@Autowired MAUB0020_Mapper maub0020_mapper;

	@Autowired MessageService msg;

	/**
	 * 화면명 : 메뉴/버튼 권한설정 이력
	 * 처리내용 : 직무에 대하여 메뉴 접근/버튼 사용 권한을 매핑한 이력을 조회하는 화면
	 * 경로 : 시스템관리 > 권한 > 메뉴/버튼 권한설정 이력
	 */
	public List<Map<String, Object>> doSearch_MenuHistory(Map<String, String> param) throws Exception {
		Map<String, Object> fParam = new HashMap<String,Object>();
		fParam.putAll(param);

		if(EverString.isNotEmpty(param.get("CTRL_NM"))) {
			fParam.put("CTRL_NM_LIST", Arrays.asList(param.get("CTRL_NM").split(",")));
		}

		return maub0020_mapper.doSearch_MenuHistory(fParam);
	}

	public List<Map<String, Object>> doSearch_ButtonHistory(Map<String, String> param) throws Exception {
		Map<String, Object> fParam = new HashMap<String,Object>();
		fParam.putAll(param);

		if(EverString.isNotEmpty(param.get("CTRL_NM"))) {
			fParam.put("CTRL_NM_LIST", Arrays.asList(param.get("CTRL_NM").split(",")));
		}
		return maub0020_mapper.doSearch_ButtonHistory(fParam);
	}

}