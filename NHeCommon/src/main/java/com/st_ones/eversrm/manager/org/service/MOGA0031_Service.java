package com.st_ones.eversrm.manager.org.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.org.MOGA0031_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MOGA0031Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MOGA0031_Service")
public class MOGA0031_Service extends BaseService {

	@Autowired private MessageService msg;
	@Autowired LargeTextService largeTextService;
	@Autowired MOGA0031_Mapper moga0031_mapper;

	/**
	 * 화면명 : 조직관리 (Tree)
	 * 처리내용 : 조직(부서)을 조회/관리한다.
	 * 경로 : 시스템관리 > 조직관리 > 조직관리2 (Tree)
	 */
	public List<Map<String, Object>> MOGA0031_doSelect_deptTree(Map<String, String> param){

		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultList = moga0031_mapper.MOGA0031_doSelect_deptTree(param);

		for (Map<String, Object> data : resultList) {
			String userNm =  EverString.nullToEmptyString(data.get("TEAM_LEADER_USER_NM"));
			if(!userNm.equals("")){
				data.put("TEAM_LEADER_USER_NM", userNm.substring(0,1) + "*" + userNm.substring(2));
			}
			returnList.add(data);
		}
		return returnList;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String MOGA0031_doSave_tree(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {
		for(Map<String, Object> rowData : gridDatas) {
			rowData.put("CUST_CD", formData.get("CUST_CD"));
			moga0031_mapper.MOGA0031_updateDEPTData(rowData);
		}
		return msg.getMessage("0031");
	}

}