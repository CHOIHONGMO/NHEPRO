package com.st_ones.eversrm.master.user;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

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
 * @File Name : MTUA0011_Mapper.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Repository
public interface MTUA0011_Mapper {

	/**
	 * 화면명 : 사용자정보 팝업
	 * 처리내용 : 사용자정보를 조회한다.
	 * 경로 : 팝업
	 */
	List<Map<String, Object>> mtua0011_doSearch(Map<String, String> param);

}