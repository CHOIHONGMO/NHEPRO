package com.st_ones.eversrm.manager.auth.service;

import java.util.List;
import java.util.Map;

import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0050_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MAUA0050Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0050_Service")
public class MAUA0050_Service extends BaseService {

	@Autowired MessageService msg;

	@Autowired MAUA0050_Mapper maua0050_mapper;

	/**
	 * 화면명 : 부서-서식 Role 매핑
	 * 처리내용 : 부서에서 사용하는 서식 Role을 매핑/관리하는 화면.
	 * 경로 : 시스템관리 > 권한 > 부서-서식 Role 매핑
	 */
	public List<Map<String, Object>> MAUA0050_doSearch(Map<String, String> param) {
		return maua0050_mapper.MAUA0050_doSearch(param);
	}

	public String MAUA0050_doSave(List<Map<String, Object>> gridData, Map<String, String> formData) throws Exception {

		for (Map<String, Object> datum : gridData) {
			datum.put("BUYER_CD", formData.get("BUYER_CD"));
			maua0050_mapper.MAUA0050_doSave(datum);
		}
		return msg.getMessage("0031");
	}

	public String MAUA0050_doDelete(List<Map<String, Object>> gridData) throws Exception {

		for (Map<String, Object> datum : gridData) {
			maua0050_mapper.MAUA0050_doDelete(datum);
		}
		return msg.getMessage("0017");
	}

}