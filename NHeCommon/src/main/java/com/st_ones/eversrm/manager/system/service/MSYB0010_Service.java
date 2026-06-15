package com.st_ones.eversrm.manager.system.service;

import java.util.Map;

import javax.transaction.TransactionRolledbackException;

import com.st_ones.eversrm.manager.screen.MSRA0030_Mapper;
import com.st_ones.eversrm.manager.screen.service.MSRA0030_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.eversrm.manager.system.MSYB0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MSYB0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "msyb0010_Service")
public class MSYB0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private MSYB0010_Mapper msyb0010_Mapper;

	@Autowired private MSRA0030_Mapper msra0030_Mapper;

	@Autowired private MSRA0030_Service msra0030_Service;

	/**
	 * 화면명 : 공통팝업관리
	 * 처리내용 : 시스템에서 사용할 공통팝업(싱글/멀티), 콤보박스들을 관리하는 화면.
	 * 경로 : 시스템관리 > 시스템 > 공통팝업관리
	 */
	@AuthorityIgnore
	public Map<String, String> getComboDetailInfo(Map<String, String> param) {
		return msyb0010_Mapper.getComboDetailInfo(param);
	}

	@AuthorityIgnore
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doSaveCommonCodeSql(Map<String, String> param) throws Exception {

		param.put("SQL_TEXT", EverString.rePreventSqlInjection(param.get("SQL_TEXT")));

		int chk = msyb0010_Mapper.checkCommonCodeSql(param);
		if (chk > 0) {
			msyb0010_Mapper.updateCommonCodeSql(param);
		} else {
			msyb0010_Mapper.insertCommonCodeSql(param);
		}
		removeCache(param.get("COMMON_ID"));

		return msg.getMessage("0001");
	}

	private void removeCache(String commonId) {
		getLog().info("Removing Common Combo Caches");
//		STOCCMPCComboCache.removeData(commonId);
//		STOCCMPCPopupCache.removeData(commonId);
	}

	@AuthorityIgnore
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String  doDeleteCommonCodeSql(Map<String, String> param) throws Exception {

		msyb0010_Mapper.deleteCommonCodeSql(param);
		removeCache(param.get("COMMON_ID"));
		return msg.getMessage("0017");
	}

	@AuthorityIgnore
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = TransactionRolledbackException.class)
	public void doVerifyCommonCodeSql(Map<String, String> param) throws Exception {
		msyb0010_Mapper.verifyCommonCodeSql(param);
		throw new TransactionRolledbackException("it should be rollback!");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class, timeout = -1)
	public void multiLanguageCommonPopupDoSave(Map<String, Object> gridData) throws Exception {

		int chk = msyb0010_Mapper.checkCommonMulg(gridData);

		if (chk > 0) {
			msra0030_Mapper.msra0031_doUpdate(gridData);
		} else {
			msra0030_Mapper.msra0031_doInsert(gridData);
		}
		msra0030_Service.removeMulgCache(gridData);
	}

}