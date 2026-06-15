package com.st_ones.eversrm.manager.org.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.org.MOGA0030_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0030Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MOGA0030_Service")
public class MOGA0030_Service extends BaseService {

	@Autowired private MessageService msg;
	@Autowired LargeTextService largeTextService;
	@Autowired MOGA0030_Mapper moga0030_mapper;

	/**
	 * 화면명 : 조직관리 (Grid)
	 * 처리내용 : 조직(부서)을 조회/관리한다.
	 * 경로 : 시스템관리 > 조직관리 > 조직관리 (Grid)
	 */
	public List<Map<String, Object>> MOGA0030_doSearch(Map<String, String> param) {
		return moga0030_mapper.MOGA0030_doSearch(param);
	}

	public List<Map<String, Object>> MOGA0030_doSearch_parent(Map<String, String> param) {
		return moga0030_mapper.MOGA0030_doSearch_parent(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String MOGA0030_doSave(Map<String, String> formData, List<Map<String, Object>> gridList) throws Exception {

		int checkCnt;
		for(Map<String, Object> gridData : gridList) {
			// 부서코드 중복체크
			gridData.put("CUST_CD", formData.get("CUST_CD"));
			checkCnt = moga0030_mapper.existsOPDP(gridData);
			if (checkCnt > 0) {
				throw new Exception("이미 등록된 부서코드가 존재합니다.");
			}
		}

		for(Map<String, Object> gridData : gridList) {
			gridData.put("CUST_CD", formData.get("CUST_CD"));
			gridData.put("DEPT_TYPE", formData.get("DEPT_TYPE_RADIO"));
			gridData.put("LVL", formData.get("LVL"));
			gridData.put("DIVISION_YN", formData.get("DIVISION_YN"));
			moga0030_mapper.MOGA0030_mergeData(gridData);
		}
		return msg.getMessage("0031");
	}

}