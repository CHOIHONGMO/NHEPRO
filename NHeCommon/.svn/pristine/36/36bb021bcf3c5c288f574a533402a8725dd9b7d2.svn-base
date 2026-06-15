package com.st_ones.eversrm.manager.org.service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.org.MOGA0032_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
 * @File Name : MOGA0032Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MOGA0032_Service")
public class MOGA0032_Service extends BaseService {

	@Autowired MOGA0032_Mapper moga0032_mapper;

	/**
	 * 화면명 : 팀검색
	 * 처리내용 : 시스템에 등록된 팀(부서)를 조회하는 팝업 화면.
	 * 경로 : 팝업
	 */
	public List<Map<String, Object>> MOGA0032_doSelect_deptTree(Map<String, String> param) throws Exception {
		return moga0032_mapper.MOGA0032_doSelect_deptTree(param);
	}

}