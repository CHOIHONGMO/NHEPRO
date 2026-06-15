package com.st_ones.eversrm.manager.org.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.org.MOGA0020_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0020Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MOGA0020_Service")
public class MOGA0020_Service extends BaseService {

	@Autowired private MessageService msg;
	@Autowired
	MOGA0020_Mapper moga0020_mapper;

	/**
	 * 화면명 : 회사단위
	 * 처리내용 : 시스템에서 사용 할 회사 단위를 관리하는 화면.
	 * 경로 : 시스템관리 > 조직관리 > 회사단위
	 */
	public List<Map<String, Object>> selectCompany(Map<String, String> param) {
		return moga0020_mapper.selectCompany(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String saveCompany(Map<String, String> formData) throws Exception {

		int transCnt;
		formData.put("TABLE_NM", "STOCOGCM");
		int check = moga0020_mapper.checkCompanyExists(formData);

		if (check > 0) {
			transCnt = moga0020_mapper.updateCompany(formData);
		} else {
			transCnt = moga0020_mapper.insertCompany(formData);
		}

		if (transCnt < 1) {
			throw new NoResultException(msg.getMessageForService(this, "exception_msg"));
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String deleteCompany(Map<String, String> formData) throws Exception {
		formData.put("TABLE_NM", "STOCOGCM");
		moga0020_mapper.deleteCompany(formData);
		return msg.getMessage("0017");
	}

}