package com.st_ones.nhepro.OSYR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.OSYR.OSYR0010_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : OSYR0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "osyr0010_Service")
public class OSYR0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private OSYR0010_Mapper osyr0010_mapper;

    /**
     * 화면명 : 회사단위
     * 처리내용 : 시스템에서 사용 할 회사 단위를 관리하는 화면.
     * 경로 : 운영사 > 조직관리 > 조직관리 > 회사단위
     */
	public List<Map<String, Object>> osyr0010_selectCompany(Map<String, String> param) {
		return osyr0010_mapper.osyr0010_selectCompany(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String osyr0010_saveCompany(Map<String, String> formData) throws Exception {

		int transCnt;
		int check = osyr0010_mapper.checkCompanyExists(formData);

		if (check > 0) {
			transCnt = osyr0010_mapper.updateCompany(formData);
		} else {
			transCnt = osyr0010_mapper.insertCompany(formData);
		}

		if (transCnt < 1) {
			throw new NoResultException(msg.getMessageForService(this, "exception_msg"));
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String osyr0010_deleteCompany(Map<String, String> formData) throws Exception {
		osyr0010_mapper.deleteCompany(formData);
		return msg.getMessage("0017");
	}

}