package com.st_ones.eversrm.manager.org.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.config.service.EverConfigService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.org.MOGA0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0010Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MOGA0010_Service")
public class MOGA0010_Service extends BaseService {

	@Autowired private EverConfigService everConfigService;

	@Autowired private MessageService msg;

	@Autowired MOGA0010_Mapper moga0010_mapper;

	/**
	 * 화면명 : GATE 단위
	 * 처리내용 : 시스템에서 사용 할 Gate 단위를 관리하는 화면.
	 * 경로 : 시스템관리 > 조직관리 > GATE 단위
	 */
	public List<Map<String, Object>> selectGate(Map<String, String> param) 	{
		return moga0010_mapper.selectGate(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String saveGate(Map<String, String> formData) throws Exception {

		int check = moga0010_mapper.checkGateUnitExists(formData);

		formData.put("TABLE_NM", "STOCOGHU");

		if (check > 0) {
			moga0010_mapper.updateGate(formData);
		} else {
			moga0010_mapper.insertGate(formData);
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String deleteGate(Map<String, String> formData) throws Exception {

		formData.put("TABLE_NM", "STOCOGHU");
		moga0010_mapper.deleteGate(formData);
		return msg.getMessage("0017");
	}

}