package com.st_ones.common.util.service;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.service.BaseService;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : LargeTextService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */

@Service(value = "largeTextService")
public class LargeTextService extends BaseService {

	@Autowired private DocNumService docNumService;
	@Autowired LargeTextCLOB largeTextCLOB;
	@Autowired LargeTextSplitString largeTextSplitString;
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String saveLargeText(String textNo, String contents) throws Exception{

		Map<String, String> map = new HashMap<String, String>();
		map.put("TEXT_NUM", textNo);
		return saveLargeText(textNo, contents, map);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String saveLargeText(String textNo, String contents, Map<String, String> signMap) throws Exception{

		Map<String, String> map = new HashMap<String, String>();
		map.put("RICH_TEXT_EDIT", contents);
		// 2021.02.23 내용에 대한 전자인증값이 존재하는 경우 저장
		if( signMap != null && signMap.size() > 0 ) {
			map.put("TEXT_SIGN_CONTENTS", signMap.get("TEXT_SIGN_CONTENTS"));
			map.put("VID_RANDOM", signMap.get("VID_RANDOM"));
			map.put("IRS_NUM", signMap.get("IRS_NUM"));
		}
		
		if (EverString.isEmpty(textNo)) {
			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			textNo = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "TN");
			map.put("TEXT_NUM", textNo);
			getLargeTextHandler().insert(map);
		} else {
			map.put("TEXT_NUM", textNo);
			getLargeTextHandler().update(map);
		}
		return textNo;
	}

	@SuppressWarnings("finally")
	public String selectLargeText(String textNo) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		map.put("TEXT_NUM", textNo);
		
		String text = "";
		try {
			text = getLargeTextHandler().get(map);
		} catch (IllegalAccessException ex) {
			System.out.println(ex.getMessage());
			return "";
		} catch (InvocationTargetException ex) {
			System.out.println(ex.getMessage());
			return "";
		}
        return text.replaceAll("&#37;", "%").replaceAll("&#39;", "\'");
	}

	private LargeText getLargeTextHandler() throws Exception {

		LargeText largeText = null;
		final String largeTextServiceMode = PropertiesManager.getString("eversrm.system.largeTextService");
		if(largeTextServiceMode.equals("clob")){
			largeText = largeTextCLOB;
		} else if(largeTextServiceMode.equals("splitString")){
			largeText = largeTextSplitString;
		} else {
			throw new EverException("unknown largeTextService Mode");
		}
		return largeText;
	}

	public String selectTXTD(String textNo) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<String, String>();
		map.put("TEXT_NUM", textNo);
		
		String text = "";
		try {
			text = getLargeTextHandler().get(map);
		} catch (IllegalAccessException ex) {
			System.out.println(ex.getMessage());
			return "";
		} catch (InvocationTargetException ex) {
			System.out.println(ex.getMessage());
			return "";
		}
		return text;
	}

	// LargeText Insert For Mail
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String saveMailContents(String contents) throws Exception{

		Map<String, String> map = new HashMap<String, String>();
		
		// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
		String textNo = docNumService.getDocNumber(PropertiesManager.getString("eversrm.default.company.code"), "TN");
		map.put("MAIL_CONTENTS", contents);

		map.put("TEXT_NUM", textNo);
		largeTextCLOB.insertMailContents(map);
		return textNo;
	}

	// LargeText Select For Mail
	public String selectMailContents(String textNo) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		map.put("TEXT_NUM", textNo);
		
		String text = "";
		try {
			text = largeTextCLOB.selectMailContents(map);
		} catch (IllegalAccessException ex) {
			System.out.println(ex.getMessage());
			return "";
		} catch (InvocationTargetException ex) {
			System.out.println(ex.getMessage());
			return "";
		}
		return text;
	}

}