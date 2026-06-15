package com.st_ones.common.util.service;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.util.LargeTextMapper;

/**  
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며, 
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>  
 * @File Name : LargeTextCLOB.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Component
public class LargeTextCLOB implements LargeText {

	@Autowired private LargeTextMapper largeTextMapper;
	
	//2022.07.12 기존 NVL처리 하여 조회하던 쿼리 실행시 임시테이블 용량 초과 오류로 인하여 
	//해당 컬럼 값의 여부 판단을 선 처리 후 값이 있는 경우 해당 컬럼 조회 없는 경우 공백처리
	public String get(Map<String, String> map) throws Exception {
		String contentsYN = "";
		String contents = "";
		if(map.size() > 0 && StringUtils.isNotEmpty(map.get("TEXT_NUM"))) {
			contentsYN = largeTextMapper.selectLargeTextYN(map);
			if(contentsYN.equals("Y")) {
				contents = largeTextMapper.selectLargeText(map);
			} else {
				contents = "";
			}
		}
		return contents;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void insert(Map<String, String> map) {
		largeTextMapper.insertLargeText(map);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void update(Map<String, String> map) {
		largeTextMapper.updateLargeText(map);
	}

	// LargeText Select For Mail
	public String selectMailContents(Map<String, String> map) throws Exception {
		String contents = "";
		if(map.size() > 0 && StringUtils.isNotEmpty(map.get("TEXT_NUM"))) {
			contents = largeTextMapper.selectMailContents(map);
		}
		return contents;
	}

	// LargeText Insert For Mail
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void insertMailContents(Map<String, String> map) {
		largeTextMapper.insertMailContents(map);
	}

}