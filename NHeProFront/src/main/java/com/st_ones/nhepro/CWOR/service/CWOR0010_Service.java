package com.st_ones.nhepro.CWOR.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.ApprovalException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.eApproval.service.EApprovalService;
import com.st_ones.nhepro.CWOR.CWOR0010_Mapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CWOR0010_Service.java
 * @date 2020. 03. 04.
 * @version 1.0
 * @see
 */

@Service(value = "cwor0010_Service")
public class CWOR0010_Service extends BaseService {

	@Autowired private MessageService msg;

	@Autowired private LargeTextService largeTextService;

	@Autowired private EApprovalService eApprovalService;

	@Autowired private CWOR0010_Mapper cwor_Mapper;

    /**
     * 화면명 : 결재함
     * 처리내용 : 로그인한 사용자에게 상신된 결제문서들을 조회/승인/반려할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재함
     */
	public List<Map<String, Object>> cwor0010_doSearch(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0010_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cwor0010_doApproval(List<Map<String, Object>> gridDatas) throws Exception {
		String rtnMsg = "";
		for(Map<String, Object> gridData : gridDatas) {
			Map<String, String> appParam = new HashMap<String, String>();
			appParam.put("BUYER_CD", String.valueOf(gridData.get("BUYER_CD")));
			appParam.put("APP_DOC_NUM", String.valueOf(gridData.get("APP_DOC_NUM")));
			appParam.put("APP_DOC_CNT", String.valueOf(gridData.get("APP_DOC_CNT")));
			appParam.put("DOC_TYPE", String.valueOf(gridData.get("DOC_TYPE")));
			appParam.put("SIGN_STATUS", "E");
			appParam.put("SIGN_RMK", "");
			rtnMsg = eApprovalService.approve(appParam);
			appParam.clear();
		}
		return rtnMsg; 
	}

	/**
	 * 화면명 : 결재요청상세
	 * 처리내용 : 선택한 결제요청문서의 상세 정보를 조회하는 화면.
	 * 경로 : Popup
	 */
	public String selectMySignStatus(Map<String, String> param) {
		return cwor_Mapper.selectMySignStatus(param);
	}

	public Map<String, String> cwor0011_doSearchHeader(Map<String, String> approvalInfoKey) throws Exception {
		
		String authType = EverString.nullToEmptyString(approvalInfoKey.get("AUTH_TYPE"));
        System.out.println("=====================> " + authType);
        
		// 2021.07.26 계약체결현황 > 감사화면에서 오는 경우 제외
		int authorizedUserCount = 0;
        if (StringUtils.isEmpty(authType) || !"VIEW".equals(authType)) {
        	authorizedUserCount = cwor_Mapper.getAuthorizedCount(approvalInfoKey);
	        if (authorizedUserCount < 1) {
				throw new ApprovalException("결재라인에 존재하지 않는 사용자입니다.");
			}
        }
        
		Map<String, String> infoHeader = cwor_Mapper.cwor0011_doSearchHeader(approvalInfoKey);
		String splitString = largeTextService.selectLargeText(infoHeader.get("CONTENTS_TEXT_NUM"));
		infoHeader.put("DOC_CONTENTS", splitString);
		return infoHeader;
	}

	public List<Map<String, Object>> cwor0011_doSearchDetail(Map<String, String> formData) throws Exception {
		return cwor_Mapper.cwor0011_doSearchDetail(formData);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void cwor0011_documentRead(Map<String, String> param) throws Exception {

		String updateFlag = EverString.nullToEmptyString(cwor_Mapper.getUpdateFlag(param));
		if(updateFlag.equals("Y")) {
			cwor_Mapper.cwor0011_documentRead(param);
		}
	}
	
	/**
	 * 화면명 : 결재요청상세
	 * 처리내용 : 선택한 결제요청문서 결재 문서유형이 "ESTM(예정가격)인 경우 해당 입찰의 예가등록 팝업을 오픈
	 * 경로 : Popup
	 */
	public List<Map<String, Object>> cwor0011_doSearchESTM(Map<String, String> param) throws Exception {
		
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		
		rtnList = cwor_Mapper.cwor0011_doSearchESTM(param);
		return rtnList;
	}

	/**
	 * 화면명 : 결재자리스트
	 * 처리내용 : 선택한 결제요청문서의 결재자 정보를 조회하는 화면.
	 * 경로 : Popup
	 */
	public List<Map<String, Object>> cwor0012_selectPathPopup(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0012_selectPathPopup(param);
	}

	/**
	 * 화면명 : 결재완료함
	 * 처리내용 : 로그인한 사용자가 승인/반려한 결제문서들을 조회할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재함 > 결재완료함
	 */
	public List<Map<String, Object>> cwor0020_doSearch(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0020_doSearch(param);
	}
	
	/**
     * 화면명 : 부서(팀)결재완료함
     * 처리내용 : 로그인한 사용자가 팀내 결재건은 전체 조회 할 수 있는 화면
     * 경로 : 고객사 > 전자결재 > 전자결재 > 부터(팀)결재완료함
     */
	public List<Map<String, Object>> cwor0060_doSearch(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0060_doSearch(param);
	}

	/**
	 * 화면명 : 결재상신함
	 * 처리내용 : 로그인한 사용자가 상신한 결제문서들을 조회/상신취소할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재상신함
	 */
	public List<Map<String, Object>> cwor0030_doSearch(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0030_doSearch(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cwor0030_doCancel(List<Map<String, Object>> gridDatas) throws Exception {

		for(Map<String, Object> gridData : gridDatas) {
			Map<String, String> appParam = new HashMap<String, String>();
			appParam.put("BUYER_CD", String.valueOf(gridData.get("BUYER_CD")));
			appParam.put("APP_DOC_NUM", String.valueOf(gridData.get("APP_DOC_NUM")));
			appParam.put("APP_DOC_CNT", String.valueOf(gridData.get("APP_DOC_CNT")));
			appParam.put("DOC_TYPE", String.valueOf(gridData.get("DOC_TYPE")));
			appParam.put("SIGN_STATUS", String.valueOf(gridData.get("SIGN_STATUS")));
			eApprovalService.cancelApprovalProcess(appParam);
		}
		return msg.getMessage("0061");
	}

    /**
     * 화면명 : 결재경로관리
     * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 조회/등록/삭제할 수 있는 화면.
     * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리
     */
    public List<Map<String, Object>> cwor0040_doSearch(Map<String, String> param) throws Exception {
        return cwor_Mapper.cwor0040_doSearch(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cwor0040_doDelete(List<Map<String, Object>> gridDatas) throws Exception {
        for(Map<String, Object> gridData : gridDatas) {
            cwor_Mapper.deletePath(gridData);
            cwor_Mapper.deletePathDetail(gridData);
        }
        return msg.getMessage("0017");
    }

	/**
	 * 화면명 : 결재경로등록
	 * 처리내용 : 로그인한 사용자가 결재상신시 사용할 경로를 등록/수정할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 결재경로등록 (팝업)
	 */
	public List<Map<String, Object>> cwor0041_doSearchDT(Map<String, String> param) throws Exception {
		return cwor_Mapper.cwor0041_doSearchDT(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String cwor0041_doSave(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		String saveType = formData.get("saveType");
		String pathNum = formData.get("PATH_NUM");
		String mainPathFlag = formData.get("MAIN_PATH_FLAG");

		if(saveType.equals("R")) {
			pathNum = cwor_Mapper.getPathNo(formData);
			formData.put("PATH_NUM", pathNum);
			cwor_Mapper.insertPath(formData);
		}
		else {
			cwor_Mapper.updatePath(formData);
		}

		cwor_Mapper.deleteLULP(formData);
		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("PATH_NUM", pathNum);
			cwor_Mapper.insertPathDetail(gridData);
		}

		if(EverString.nullToEmptyString(mainPathFlag).equals("on")) {
            cwor_Mapper.updateOtherPathToNormal(formData);
        }
		return msg.getMessage("0031");
	}

	/**
	 * 화면명 : 나의결재경로
	 * 처리내용 : 로그인한 사용자가 등록한 경로를 조회/선택할 수 있는 화면.
	 * 경로 : 고객사 > 전자결재 > 전자결재 > 결재경로관리 > 나의결재경로 (팝업)
	 */
	public List<Map<String, Object>> cwor0042_doSearch(Map<String, String> param) {
		return cwor_Mapper.cwor0042_doSearch(new HashMap<String, String>(param));
	}

	/**
	 * 화면명 : 결재요청
	 * 처리내용 : 결재상신을 위해 결재내용, 결재자 등을 지정하는 화면.
	 * 경로 : 고객사 > 업무화면 > 결재요청
	 */
	public List<Map<String, Object>> cwor0050_userSearch(Map<String, String> param) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		if(EverString.nullToEmptyString(userInfo.getRelatYn()).equals("0")) {
			rtnList = cwor_Mapper.cwor0050_userSearchAll(param);
		} else {
			rtnList = cwor_Mapper.cwor0050_userSearchMy(param);
		}
		return rtnList;
	}

	public List<Map<String, Object>> cwor0050_doSearchDecideArbitrarily(Map<String, Object> param) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		String inCustCd = PropertiesManager.getString("eversrm.default.inCustCd");
		String custCd = userInfo.getCompanyCd();

		// DB에서 가져온 결재자/합의자/참조자 List
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		// view에서 전결규정을 array로 입력할 경우 콤마 단위로 달라 쓸수 있어 콤마로 split처리 하여 loop 돌림
		// 전결규정의 우선순위는 array의 순서의 오름차순으로 적용됨
		String bizClsArr1[] = String.valueOf(param.get("BIZ_CLS1")).split(",", -1);
		String bizClsArr2[] = String.valueOf(param.get("BIZ_CLS2")).split(",", -1);
		String bizClsArr3[] = String.valueOf(param.get("BIZ_CLS3")).split(",", -1);

		int rowIdx = 0;
		for(int i = 0, arrCnt = bizClsArr1.length; i < arrCnt; i++) {

			param.put("BIZ_CLS1", bizClsArr1[i]);
			param.put("BIZ_CLS2", bizClsArr2[i]);
			param.put("BIZ_CLS3", bizClsArr3[i]);
			param.put("CUST_CD", custCd);
			param.put("BIZ_AMT", ((bizClsArr1[i].equals("02") && bizClsArr2[i].equals("03") && bizClsArr3[i].equals("06")) ? param.get("BIZ_RATE") : param.get("BIZ_AMT")));

			// Parameter로 전달받은 해당 문서의 전결규정에 대한 결재, 합의라인 코드를 가져온다.
			Map<String, String> lineData = cwor_Mapper.getAppLineCd(param);
			if (lineData != null) {
				String bizCls1 = bizClsArr1[i];
				String bizCls2 = bizClsArr2[i];
				String bizCls3 = bizClsArr3[i];
				String appLineCd = lineData.get("APP_LINE");
				String agrLineCd = lineData.get("AGR_LINE");
				// 조회된 결재, 합의라인 코드의 결재자/합의자/참조자들을 가져온다.
				List<Map<String, Object>> tmpList = setAppLines(inCustCd, custCd, bizCls1, bizCls2, bizCls3, appLineCd, agrLineCd, param);
				for(int t = 0; t < tmpList.size(); t++) {
					rtnList.add(rowIdx, tmpList.get(t));
					rowIdx++;
				}
			}
		}

		// LVL를 기준으로 부서장 -> 전결라인의 결재자 -> 합의자 -> 참조자 순으로 순서를 바꾼다.
		Collections.sort(rtnList, new Comparator<Map<String, Object>>() {
			@Override
			public int compare(Map<String, Object> first, Map<String, Object> second) {
			Double firstVal = Double.parseDouble(String.valueOf(first.get("LVL")));
			Double secondVal = Double.parseDouble(String.valueOf(second.get("LVL")));
			return secondVal.compareTo(firstVal);
			}
		});

		// 중첩된 결재자를 제외시킨 후, 최종 결재자/합의자/참조자 List를 Return 한다.
		int idxTrans = 0;
		List<Map<String, Object>> transList = new ArrayList<Map<String, Object>>();
		if(rtnList.size() > 0) {
			for(int t = 0; t < rtnList.size(); t++) {
				Map<String, Object> rtnMapO = rtnList.get(t);
				int sameCnt = 0;
				for(int p = 0; p < transList.size(); p++) {
					Map<String, Object> rtnMapL = transList.get(p);
					if(String.valueOf(rtnMapO.get("SIGN_USER_ID")).equals(String.valueOf(rtnMapL.get("SIGN_USER_ID")))) {
						sameCnt++;
					}
				}
				if(sameCnt == 0) {
					transList.add(idxTrans, rtnMapO);
					idxTrans++;
				}
			}
		}
		return transList;
	}

	public List<Map<String, Object>> setAppLines(String inCustCd, String custCd, String bizCls1, String bizCls2, String bizCls3, String appLineCd, String agrLineCd, Map<String, Object> sParam) throws Exception {

		String reqUserId = (String)sParam.get("REQ_USER_ID");

		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(">>>>>>>>>>>>> appLineCd : " + appLineCd);
		System.out.println(">>>>>>>>>>>>> agrLineCd : " + agrLineCd);
		System.out.println(">>>>>>>>>>>>> bizCls1 : " + bizCls1);
		System.out.println(">>>>>>>>>>>>> bizCls2 : " + bizCls2);
		System.out.println(">>>>>>>>>>>>> bizCls3 : " + bizCls3);
		System.out.println(">>>>>>>>>>>>> inCustCd : " + inCustCd);
		System.out.println(">>>>>>>>>>>>> custCd : " + custCd);
		System.out.println(">>>>>>>>>>>>> reqUserId : " + reqUserId);
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

		/*	01	대표이사		02	경영지원실장		03	인사총무팀장
			04	구매팀장		05	본부장			06	전략팀장
			07	부서장
			08	구매팀장, 경영지원실장
			09	구매팀장, 경영지원실장, 대표이사

		custCd = session's CompanyCd
		inCustCd = "C00007" [운영사-내부구매]

		[ 전결 ]
		custCd가 "1000"(운영사)인 경우, 전결라인은 MP030.TEXT1을 순서대로 return 한다.
		custCd가 "C00007"(운영사-내부구매)인 경우, 전결라인은 MP030.TEXT2를 순서대로 return 한다.
		그 이외의 경우에는 null을 return하여 행추가 후, 상신하도록 한다.

		[ 합의/참조 ]
		custCd가 "1000"(운영사) 또는 "C00007"(운영사-내부구매)인 경우, 합의/참조 라인은 STOCDMLD의 값을 순서대로 return 한다.
		그 이외의 경우에는 null을 return하여 행추가 후, 상신하도록 한다. */

		int addIdx = 0;
		List<Map<String, Object>> rtnLines = new ArrayList<Map<String, Object>>();

		// 합의/참조라인에 대한 결재자를 가져온다.
		Map<String, Object> aParam = new HashMap<String, Object>();
		aParam.put("CUST_CD", custCd);
		aParam.put("CODE", agrLineCd);
		aParam.put("BIZCLS1", bizCls1);
		aParam.put("REF_CD", bizCls1 + bizCls2 + bizCls3);
		aParam.put("REF_BIZ_AMT", ((bizCls1.equals("02") && bizCls2.equals("03") && bizCls3.equals("06")) ? sParam.get("BIZ_RATE") : sParam.get("BIZ_AMT")));

		List<Map<String, Object>> agrLine = cwor_Mapper.getAgrLines(aParam);
		if (agrLine.size() > 0) {
			for (Map<String, Object> agrData : agrLine) {
				Map<String, Object> tmpMap = new HashMap<String, Object>();
				tmpMap.put("DOC_SQ", "");
				tmpMap.put("SIGN_REQ_TYPE", agrData.get("SIGN_REQ_TYPE"));
				tmpMap.put("SIGN_PATH_SQ", addIdx + 1);
				tmpMap.put("SIGN_USER_ID", agrData.get("SIGN_USER_ID"));
				tmpMap.put("SIGN_USER_NM", agrData.get("SIGN_USER_NM"));
				tmpMap.put("SIGN_USER_NM_$TP", agrData.get("SIGN_USER_NM"));
				tmpMap.put("SIGN_USER_NM_IMG", agrData.get("SIGN_USER_NM_IMG"));
				tmpMap.put("POSITION_NM", agrData.get("POSITION_NM"));
				tmpMap.put("DEPT_NM", agrData.get("DEPT_NM"));
				tmpMap.put("DEPT_CD", agrData.get("DEPT_CD"));
				tmpMap.put("DUTY_NM", agrData.get("DUTY_NM"));
				tmpMap.put("CHECK_FLAG", "");
				tmpMap.put("LVL", agrData.get("SIGN_REQ_TYPE").equals("CC") ? "1" : "2"); // 2 : 합의자, 1 : 참조자
				tmpMap.put("DECIDE_FLAG", "Y"); // 화면에서 삭제할 수 없도록 하는 Flag 값.
				rtnLines.add(addIdx, tmpMap);
				addIdx++;
			}
		}

		// 결재라인에 대한 결재자를 가져온다.
		List<Map<String, Object>> tmpLines = new ArrayList<Map<String, Object>>();
		Map<String, String> param = new HashMap<String, String>();
		param.put("CUST_CD", custCd);
		param.put("CODE", appLineCd);
		param.put("REG_USER_ID", reqUserId);

		if(custCd.equals("1000")) {
			// 운영사의 결재자는 'MP030'의 TEXT1에서 전결라인 결재자를 가져온다.
			tmpLines = cwor_Mapper.getAppLinesOperator(param);
		}
		else if(custCd.equals(inCustCd)) {

			// 내부고객사의 결재자 중 '부서장'은 'MP030'의 TEXT2에 정의되어있지 않다.
			// 따라서, Parameter로 받은 reqUserId를 기준으로 해당 부서의 부서장을 가져온다.
			if(!reqUserId.equals("")) {
				Map<String, Object> tmpMap = cwor_Mapper.getAppLinesTeamLeader(param);
				if(tmpMap != null) {
					tmpMap.put("SIGN_PATH_SQ", addIdx + 1);
					tmpMap.put("CHECK_FLAG", "");
					tmpMap.put("LVL", "4"); // 4 : 부서장
					tmpMap.put("DECIDE_FLAG", "Y"); // 화면에서 삭제할 수 없도록 하는 Flag 값.
					rtnLines.add(addIdx, tmpMap);
					addIdx++;
				}
			}
			// 내부고객사의 결재자는 'MP030'의 TEXT2에서 전결라인 결재자를 가져온다.
			tmpLines = cwor_Mapper.getAppLinesInCust(param);
		}
		
		if(tmpLines.size() > 0) {
			for(int t = 0; t < tmpLines.size(); t++) {
				Map<String, Object> tmpMap = tmpLines.get(t);
				tmpMap.put("SIGN_PATH_SQ", addIdx + 1);
				tmpMap.put("CHECK_FLAG", "");
				tmpMap.put("LVL", "3"); // 3 : 전결라인에 있는 결재자
				tmpMap.put("DECIDE_FLAG", "Y"); // 화면에서 삭제할 수 없도록 하는 Flag 값.
				rtnLines.add(addIdx, tmpMap);
				addIdx++;
			}
		}
		
		return rtnLines;
	}

	public List<Map<String, Object>> cwor0050_doSearchSync(Map<String, Object> param) throws Exception {

		String user_ids = (String)param.get("USER_IDS");
		
		StringTokenizer st = new StringTokenizer(user_ids,",");
		ArrayList al = new ArrayList();
		int tokenIdx = 1;
		while(st.hasMoreElements())  {

			Map<String,String> map = new HashMap<String,String>();

			String tokenStr = st.nextToken();
			StringTokenizer dataA = new StringTokenizer(tokenStr,"#");
			map.put("SIGN_TYPE", dataA.nextToken());
			map.put("USER_ID", dataA.nextToken());
			map.put("SIGN_PATH_SQ", String.valueOf(tokenIdx++));
			al.add(map);
		}
		param.put("list", al);
		return cwor_Mapper.doSearchSync(param);
	}

	public List<Map<String, Object>> cwor0050_doSelectMyPath(HashMap<String, String> approvalPathKey) {
		return cwor_Mapper.cwor0050_doSelectMyPath(approvalPathKey);
	}

	public List<Map<String, Object>> cwor0050_getCust(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = cwor_Mapper.cwor0050_getCust(param);
		return rtnList;
	}
	
	public List<Map<String, Object>> cwor0050_getCustCd(Map<String, String> param) throws Exception {

		List<Map<String, Object>> rtnList = cwor_Mapper.cwor0050_getCustCd(param);
		return rtnList;
	}

}

