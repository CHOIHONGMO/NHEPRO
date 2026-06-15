package com.st_ones.common.util.clazz;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.service.UtilService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.everf.serverside.util.clazz.SessionIgnore;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : AuthCheckAndLogging.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Aspect
public class AuthCheckAndLogging {

	@Autowired UtilService utilService;
	@Autowired private MessageService msg;

	public void afterMethod(JoinPoint joinPoint, List retVal) throws Exception {
		
		if (retVal == null || retVal.size() == 0) return;
		String methodName = joinPoint.getSignature().getName();
		
		// 2021.11.05 개인정보 및 직무권한 화면에 대해 조회시 로그 기록
		// cctr0120_doSearch : 고객사 > 계약관리 > 개인근로계약 > 개인근로자현황
		// ccur0030_doSearch : 고객사 > 관리자 > 사용자관리 > 사용자현황
		// ccur0021_selectMappingUser_add : 고객사 > 관리자 > 조직관리 > 직무별사용자맵핑
		// ccur0022_selectTaskPersonInCharge : 고객사 > 관리자 > 조직관리 > 직무별사용자현황
		if( "ccur0030_doSearch".equals(methodName)
				|| "cctr0120_doSearch".equals(methodName)
				|| "ccur0021_selectMappingUser_add".equals(methodName) )
		{
			String packageName = joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName();
			if (packageName.equals("com.st_ones.eversrm.system.code.service.MBSA0020Service.getSTOCCODEByCodeType")) return;
			
			// joinPiont 의 값을 받아온다.
			Map<String, String> argMap = new HashMap<>();
			Object[] arguments = joinPoint.getArgs();
			if ( arguments.length > 0 &&  arguments[0] instanceof Map) {
				Iterator<String> mapItor = ((Map<String, Object>) arguments[0]).keySet().iterator();
				while (mapItor.hasNext()) {
					String key = mapItor.next();
					String value = "";
					if (((Map<String, Object>) arguments[0]).get(key) instanceof String) {
						value = (String) ((Map<String, Object>) arguments[0]).get(key);
					} else {
						value = ((Map<String, Object>) arguments[0]).get(key) == null ? "" : ((Map<String, Object>) arguments[0]).get(key).toString();
					}
					argMap.put(key, value);
				}
			}
			argMap.put("packageName", packageName);
			argMap.put("retVal", retVal.toString());
			
			List<Map<String, String>> result = utilService.getCheckCnt(argMap);
			if(result.size() > 0) {
				result.get(0).putAll(argMap);
			}
			
			logging(joinPoint, result);
		}
	}

	public void beforeMethod(JoinPoint joinPoint) throws Exception {

		String packageName = joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName();
		if (packageName.equals("com.st_ones.eversrm.system.code.service.MBSA0020Service.getSTOCCODEByCodeType")) return;

		// joinPiont 의 값을 받아온다.
		Map<String, String> argMap = new HashMap<>();
		Object[] arguments = joinPoint.getArgs();
		if ( arguments.length > 0 &&  arguments[0] instanceof Map) {
			Iterator<String> mapItor = ((Map<String, Object>) arguments[0]).keySet().iterator();
			while (mapItor.hasNext()) {
				String key = mapItor.next();
				String value = "";
				if (((Map<String, Object>) arguments[0]).get(key) instanceof String) {
					value = (String) ((Map<String, Object>) arguments[0]).get(key);
				} else {
					value = ((Map<String, Object>) arguments[0]).get(key) == null ? "" : ((Map<String, Object>) arguments[0]).get(key).toString();
				}
				argMap.put(key, value);
			}
		}
		argMap.put("packageName", packageName);
		
		List<Map<String, String>> result = utilService.getCheckCnt(argMap);
		if(result.size() > 0) {
			result.get(0).putAll(argMap);
		}
		logging(joinPoint, result);
		
		if(ignoreAuthCheck((MethodSignature) joinPoint.getSignature())) return;
		
		// # false : Not Check, true : Check
		if(PropertiesManager.getString("eversrm.auth.button.apply.flag").equals("true")) {
			if(packageName.indexOf("com.st_ones.eversrm.SUMMARY") == -1
					&& packageName.indexOf("com.st_ones.batch") == -1
					&& packageName.indexOf("com.st_ones.common") == -1
					&& packageName.indexOf("com.st_ones.nosession") == -1
					&& packageName.indexOf("com.st_ones.siis.scheduler") == -1) {
				if (result.size() == 0) {
					throw new NoResultException(PropertiesManager.getString("eversrm.system.developmentFlag").equals("true") ? msg.getMessage("0008") + " (" + packageName + ")" : msg.getMessage("0008")); // You do not have authority.
				}
			}
		}
	}

	private void logging(JoinPoint joinPoint, List<Map<String, String>> result) throws Exception {
		
		String screenId, actionCode, jobDesc, actionNm, jobContents;
		Boolean maskApproval;
		if(result.size() > 0){
			screenId = result.get(0).get("SCREEN_ID");
			actionCode = result.get(0).get("ACTION_CD");
			jobDesc = actionCode + " of [" + screenId + "] - " + result.get(0).get("SCREEN_URL");
			jobContents = result.get(0).get("retVal");
			maskApproval = Boolean.valueOf(result.get(0).get("maskApproval"));
		}
		else {
			screenId = "unknown";
			actionCode = "unknown";
			jobDesc = "action did not registered";
			jobContents = "unknown";
			maskApproval = null;
		}
		
		if (screenId.equals("unknown")) {
			return;
		}
		
		String methodName = joinPoint.getSignature().getName();
		String moduleName = joinPoint.getSignature().getDeclaringTypeName();
		if (maskApproval) {
			Map<String, String> resultMap = result.get(0);
			if (actionCode.toUpperCase().indexOf("SEARCH") > -1) {
				resultMap.put("SCREEN_CRUD", "C");
			} else if (actionCode.toUpperCase().indexOf("DEL") > -1) {
				resultMap.put("SCREEN_CRUD", "D");
			} else if (actionCode.toUpperCase().indexOf("INS") > -1) {
				resultMap.put("SCREEN_CRUD", "I");
			} else if (actionCode.toUpperCase().indexOf("UPDATE") > -1) {
				resultMap.put("SCREEN_CRUD", "U");
			} else if (actionCode.toUpperCase().indexOf("SAVE") > -1) {
				resultMap.put("SCREEN_CRUD", "M");
			} else {
				resultMap.put("SCREEN_CRUD", "");
			}
			
			// 파라미터값만 비고에 넣기 위해 파싱 작업
            Set<String> keySet = resultMap.keySet();
            String rmk = "";
            for (String key : keySet) {
                String value = resultMap.get(key);
				if (!("PACKAGE_NM".equals(key) || "_screenId".equals(key) ||
						"packageName".equals(key) || "ACTION_NM".equals(key) ||
						"SCREEN_URL".equals(key) || "SCREEN_ID".equals(key) ||
						"maskApproval".equals(key) || "ACTION_CD".equals(key) ||
						"SCREEN_CRUD".equals(key))) {
					if (StringUtils.isNotEmpty(value)) {
						rmk += key + ": " + value + ", ";
					}
				}
            }
			resultMap.put("RMK", rmk.substring(0, rmk.length() - 2));
			utilService.logForMaskJob(resultMap);
		}
		
		utilService.logForJob(methodName, moduleName, screenId, actionCode, jobDesc, jobContents, "G", "", "", "","");
	}

	@SuppressWarnings("unchecked")
	private boolean ignoreAuthCheck(MethodSignature methodSignagure) throws UserInfoNotFoundException {
		if(!PropertiesManager.getBoolean("eversrm.auth.button.apply.flag", true)) return true; // 해당 프로퍼티 값을 false 로 설정 한 경우 권한 체크 하지 않음.
		if(methodSignagure.getMethod().isAnnotationPresent(SessionIgnore.class)) return true;
		if(methodSignagure.getMethod().isAnnotationPresent(AuthorityIgnore.class)) return true;
		if(methodSignagure.getDeclaringType().isAnnotationPresent(SessionIgnore.class)) return true;
		if(methodSignagure.getDeclaringType().isAnnotationPresent(AuthorityIgnore.class)) return true;
		return UserInfoManager.getUserInfo().getUserId().equals("VIRTUAL");
	}
}
