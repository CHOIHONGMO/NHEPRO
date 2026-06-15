package com.st_ones.eversrm.manager.system.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.eversrm.manager.system.MSYA0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSYA0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "msya0010_Service")
public class MSYA0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private MSYA0010_Mapper msya0010_Mapper;

	/**
	 * 화면명 : 공통팝업현황
	 * 처리내용 : 시스템에 등록된 공통팝업(싱글/멀티), 콤보박스들을 조회하는 화면
	 * 경로 : 시스템관리 > 시스템 > 공통팝업현황
	 */
	@AuthorityIgnore
	public List<Map<String, Object>> doSearch(Map<String, String> param) {
		return msya0010_Mapper.getComboList(param);
	}

}