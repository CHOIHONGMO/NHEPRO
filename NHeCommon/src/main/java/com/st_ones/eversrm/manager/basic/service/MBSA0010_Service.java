package com.st_ones.eversrm.manager.basic.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.basic.MBSA0010_Mapper;
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
 * @File Name : MBSA0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MBSA0010_Service")
public class MBSA0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private DocNumService docNumService;

	@Autowired private MBSA0010_Mapper mbsa0010_mapper;

	/**
	 * 화면명 : 문서번호
	 * 처리내용 : 시스템에서 사용 할 문서번호의 채번룰을 관리하는 화면.
	 * 경로 : 시스템관리 > 기본정보 > 문서번호
	 */
	public List<Map<String, Object>> doSearch(Map<String, String> param) {
		return mbsa0010_mapper.doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSave(List<Map<String, Object>> gridDatas) throws Exception {

		int checkCnt = 0;

		for (Map<String, Object> gridData : gridDatas) {

			checkCnt = mbsa0010_mapper.checkDocType(gridData);

			if (checkCnt == 0) {
				mbsa0010_mapper.doInsert(gridData);
			} else {
				mbsa0010_mapper.doUpdate(gridData);
			}
		}
		return msg.getMessage("0001");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doDelete(List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			mbsa0010_mapper.doDelete(gridData);
		}
		return msg.getMessage("0017");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doTest(List<Map<String, Object>> gridDatas) throws Exception {

		String newNum = "";

		for (Map<String, Object> gridData : gridDatas) {
			newNum = docNumService.getDocNumber(String.valueOf(gridData.get("COMPANY_CD")), String.valueOf(gridData.get("DOC_TYPE")));
		}
		return newNum;
	}

}