package com.st_ones.eversrm;

import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
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
 * @File Name : DashboardService.java
 * @date 2013. 07. 22.
 * @version 1.0
 */
@Service(value = "dashboardService")
public class DashboardService {

    @Autowired DashboardMapper dashboardMapper;

	public List<Map<String, Object>> doNotice(Map<String, String> param) throws Exception {
    	return dashboardMapper.doNotice(param);
    }

    public List<Map<String, Object>> doFaq(Map<String, String> param) throws Exception {
    	return dashboardMapper.doFaq(param);
    }

    public List<Map<String, Object>> doQna(Map<String, String> param) throws Exception {
    	return dashboardMapper.doQna(param);
    }

	public List<Map<String, Object>> doNewgrid(Map<String, String> param) throws Exception {
		return dashboardMapper.doNewgrid(param);
	}

	public List<Map<String, Object>> doBggrid(Map<String, String> param) throws Exception {
		return dashboardMapper.doBggrid(param);
	}

    /**
     * 대시보드 데이터를 가져오는 메서드입니다.
     * 왼쪽트리메뉴의 메뉴명과 동일한 메뉴명을 getTableHtml()의 2번쨰 파라미터에 넘겨야 데이터 클릭 시 해당 메뉴가 새로운 탭으로 열립니다.
     * @param division
     * @return
     */
	public String getTodo(String division) {

		Map<String, String> paramMap = new HashMap<String, String>();
		StringBuilder html = new StringBuilder();
		if(StringUtils.equals(division, "1")) {
			html = getTableHtml(html, "AP","전자결제", "CWOR0010",
					new String[]{"결재대기 현황", dashboardMapper.summary01(paramMap), "결재상태 : 결재중"}
			);
		} else if(StringUtils.equals(division, "2")) {
			html = getTableHtml(html,  "AP","전자결제", "CWOR0030",
					new String[]{"결재상신 현황", dashboardMapper.summary02(paramMap), "결재상신함, 결재상태 : 결재중"}
			);
		} else if(StringUtils.equals(division, "3")) {
			html = getTableHtml(html, "BI","기준정보", "CITR0030",
					new String[]{"품목승인대기 현황", dashboardMapper.summary03(paramMap), "품목등록승인현황, 진행상태 : 등록완료 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "4")) {
			html = getTableHtml(html, "BI","기준정보", "CITR0020",
					new String[]{"품목등록신청 현황", dashboardMapper.summary04(paramMap), "품목등록신청현황, 진행상태 : 등록완료 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "5")) {
			html = getTableHtml(html, "BI","기준정보", "CVNR0010",
					new String[]{"신규업체대기 현황", dashboardMapper.summary05(paramMap), "신규업체대기현황, 진행상태 : 가입요청"}
			);
		} else if(StringUtils.equals(division, "6")) {
			paramMap.put("ANN_DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("ANN_DATE_TO", EverDate.getDate());
			html = getTableHtml(html, "PR","구매관리", "CBDR0050_A",
					new String[]{"나의 예정가격 미확정 현황", dashboardMapper.summary06(paramMap), "예정가격 확정상태 : 미확정"}
			);
		} else if(StringUtils.equals(division, "11")) {
			html = getTableHtml(html, "PR","구매관리", "CPRR0030",
					new String[]{"구매의뢰진행 현황", dashboardMapper.summary11(paramMap), "구매의뢰진행현황 : ALL"}
			);
		} else if(StringUtils.equals(division, "12")) {
			html = getTableHtml(html, "PR","구매관리", "CPRA0040",
					new String[]{"구매의뢰 담당자 지정대기 현황", dashboardMapper.summary12(paramMap), "담당자 지정 : 미지정"}
			);
		} else if(StringUtils.equals(division, "13")) {
			html = getTableHtml(html, "PR","구매관리", "CRQR0010",
					new String[]{"[수의계약] 견적 현황", dashboardMapper.summary13(paramMap), "견적현황, 진행상태 : 선정완료 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "14")) {
			paramMap.put("ANN_DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("ANN_DATE_TO", EverDate.getDate());
			html = getTableHtml(html, "PR","구매관리", "CBDI0010",
				new String[]{"[입찰] 입찰공고 현황", dashboardMapper.summary14(paramMap), "입찰공고 : ALL"}
			);
		} else if(StringUtils.equals(division, "15")) {
			paramMap.put("APP_END_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("APP_END_TO", EverDate.addDateMonth(EverDate.getDate(), 1));
			html = getTableHtml(html, "PR","구매관리", "CBDI0020",
				new String[]{"[입찰] 입찰등록 현황", dashboardMapper.summary15(paramMap), "입찰등록 : ALL"}
			);
		} else if(StringUtils.equals(division, "16")) {
			paramMap.put("APP_END_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("APP_END_TO", EverDate.getDate());
			html = getTableHtml(html, "PR","구매관리", "CBDR0030",
				new String[]{"[입찰] 입찰진행 현황", dashboardMapper.summary16(paramMap), "입찰진행 : ALL"}
			);
		} else if(StringUtils.equals(division, "17")) {
			paramMap.put("ANN_DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("ANN_DATE_TO", EverDate.getDate());
			paramMap.put("TO_DO", "TODO");
			html = getTableHtml(html, "PR","구매관리", "CBDR0050",
				new String[]{"예정가격 현황", dashboardMapper.summary17(paramMap), "예정가격, 진행상태 : 확정 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "18")) {
			paramMap.put("END_DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("END_DATE_TO", EverDate.getDate());
			html = getTableHtml(html, "PR","구매관리", "CBDR0060",
				new String[]{"선정품의대기 현황", dashboardMapper.summary18(paramMap), "선정품의대기목록 : ALL"}
			);
		} else if(StringUtils.equals(division, "21")) {
			html = getTableHtml(html, "SM","계약관리", "CCTR0020",
				new String[]{"계약대기 현황", dashboardMapper.summary21(paramMap), "계약대기현황 : ALL"}
			);
		} else if(StringUtils.equals(division, "22")) {
			html = getTableHtml(html, "SM","계약관리", "CCTR0050_A",
				new String[]{"계약체결진행 현황", dashboardMapper.summary22(paramMap), "계약체결진행현황 : ALL"}
			);
		} else if(StringUtils.equals(division, "31")) {
			html = getTableHtml(html, "OM","발주관리", "CPOR0020",
					new String[]{"발주미접수 현황", dashboardMapper.summary31(paramMap), "발주현황, 진행상태 : 미접수"}
					);
		} else if(StringUtils.equals(division, "32")) {
			html = getTableHtml(html, "OM","발주관리", "CPOR0050",
					new String[]{"전체검수대기 현황", dashboardMapper.summary32(paramMap), "전체검수대기 현황, 진행상태 : 요청완료, 반려"}
					);
		} else if(StringUtils.equals(division, "33")) {
			html = getTableHtml(html, "OM","발주관리", "CPOR0070",
					new String[]{"부분검수대기 현황", dashboardMapper.summary33(paramMap), "부분검수대기 현황, 진행상태 : 검수요청, 반송"}
					);
		} else if(StringUtils.equals(division, "34")) {
			html = getTableHtml(html, "OM","발주관리", "CAPR0010",
					new String[]{"대금지급대기 현황", dashboardMapper.summary34(paramMap), "대금지급 현황, 진행상태 : 지급요청"}
					);
		} else if(StringUtils.equals(division, "41")) {
			html = getTableHtml(html, "MP","My Page", "SETR0040",
					new String[]{"고객의 소리(VOC)", dashboardMapper.summary41(paramMap), "VOC : 조치완료 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "51")) {
			html = getTableHtml(html, "PR","구매관리", "SRQR0010",
					new String[]{"견적 현황", dashboardMapper.summary51(paramMap), "제출상태 : 마감 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "52")) {
			html = getTableHtml(html, "PR","구매관리", "SRQR0020",
					new String[]{"견적선정결과대기 현황", dashboardMapper.summary52(paramMap), "선정여부 : 선정대기"}
			);
		} else if(StringUtils.equals(division, "53")) {
			paramMap.put("ANN_DATE_FROM", EverDate.addDateMonth(EverDate.getDate(), -1));
			paramMap.put("ANN_DATE_TO", EverDate.addDateMonth(EverDate.getDate(), 1));
			html = getTableHtml(html, "PR","구매관리", "SBDR0010",
					new String[]{"참가 가능한 입찰 현황", dashboardMapper.summary53(paramMap), "참가 가능한 입찰 현황 : 미신청"}
			);
		} else if(StringUtils.equals(division, "54")) {
			html = getTableHtml(html, "PR","구매관리", "SCTR0010",
					new String[]{"계약진행 현황", dashboardMapper.summary54(paramMap), "진행상태 : 계약체결완료 제외한 전부"}
			);
		} else if(StringUtils.equals(division, "61")) {
			html = getTableHtml(html, "OM","발주관리", "SPOR0010",
					new String[]{"발주접수 현황", dashboardMapper.summary61(paramMap), "발주접수 현황 : ALL"}
			);
		} else if(StringUtils.equals(division, "62")) {
			html = getTableHtml(html, "OM","발주관리", "SPOR0020",
					new String[]{"발주진행 현황", dashboardMapper.summary62(paramMap), "발주진행 현황 : 미정의"}
			);
		} else if(StringUtils.equals(division, "63")) {
			html = getTableHtml(html, "OM","발주관리", "SPOR0040",
					new String[]{"부분검수요청 현황", dashboardMapper.summary63(paramMap), "부분검수요청 현황 : 검수요청, 반송"}
			);
		} else if(StringUtils.equals(division, "64")) {
			html = getTableHtml(html, "OM","발주관리", "SPOR0060",
					new String[]{"검수요청 현황", dashboardMapper.summary64(paramMap), "검수요청 현황 : 요청완료, 반려"}
			);
		} else if(StringUtils.equals(division, "65")) {
			html = getTableHtml(html, "OM","발주관리", "SAPR0020",
					new String[]{"대금지급 현황", dashboardMapper.summary65(paramMap), "대금지급 현황 : 지급요청"}
			);
		}
		return html.toString();
	}

	private StringBuilder getTableHtml(StringBuilder html, String moduleType, String moduleTypeTitle, String screenId, String[]... detail) {

        StringBuilder itemHtml = new StringBuilder();
        for (String[] dtl : detail) {
            // count += Integer.parseInt(dtl[1]);
            itemHtml.append("<p class=\"title\">")
					.append(dtl[0])
					.append("</p><p class=\"total\">") 
					//.append("<a href=\"javascript:top.fetchLeftMenu('"+moduleType+"'); top.pageRedirectByScreenId('"+screenId+"');\">")
					.append("<a href=\"javascript:top.fetchLeftMenu('"+moduleType+"'); onClick=pageRedirectByScreen('"+screenId+"');\">")
					.append(ContStringUtil.toPositionalNumber(dtl[1])+"건")
					.append("</a>")
					.append("</p><p class=\"desc\">")
					.append(dtl[2])
					.append("</p>");
        }

		return itemHtml;
	}

	// 공급사 대쉬보드의 관리현황 건수
	public Map<String, String> mypageTypeB(Map<String, String> param) throws Exception {
		Map<String, String> rtn = dashboardMapper.mypageTypeB(param);
		return rtn;
	}

	// 공급사 대쉬보드의 관리현황 건수
	public Map<String, String> mypageTypeS(Map<String, String> param) throws Exception {

		Map<String, String> dashBoardMap = dashboardMapper.mypageTypeS(param);

		param.put("PARAM_FROM_DATE", param.get("FROM_DATE").substring(0, 6));
		param.put("PARAM_TO_DATE", param.get("TO_DATE").substring(0, 6));
		Map<String, String> salesMap = dashboardMapper.getSalesDataS(param);

		Map<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.putAll(dashBoardMap);
		if(salesMap != null) {
			rtnMap.putAll(salesMap);
		}
		return rtnMap;
	}

	// 고객사 대쉬보드의 관리현황 건수
	public Map<String, String> mypageTypeC(Map<String, String> param) throws Exception {
		return dashboardMapper.mypageTypeC(param);
	}

	// 고객사 대쉬보드의 취급품목(품목분류조회)
	public List<Map<String, String>> getItemClsList(Map<String, String> param) throws Exception {
		return dashboardMapper.getItemClsList(param);
	}

    public List<Map<String, Object>> doMygrid(Map<String, String> param) throws Exception {
		return dashboardMapper.doMygrid(param);
    }

    public List<Map<String, Object>> doOpGrid1(Map<String, String> param) throws Exception {
	    return dashboardMapper.doOpGrid1(param);
    }

    public List<Map<String, Object>> doOpGrid2(Map<String, String> param) throws Exception {
        return dashboardMapper.doOpGrid2(param);
    }

    public List<Map<String, Object>> doOpGrid3(Map<String, String> param) throws Exception {
        return dashboardMapper.doOpGrid3(param);
    }

    public List<Map<String, Object>> doOpGrid4(Map<String, String> param) throws Exception {
        return dashboardMapper.doOpGrid4(param);
    }

    public List<Map<String, Object>> doOpGrid5(Map<String, String> param) throws Exception {
        return dashboardMapper.doOpGrid5(param);
    }

    public String getScreenId(Map<String, String> param) {
		return dashboardMapper.getScreenId(param);
    }
    
    //2021.04.15 화면 권한에 따른 메인화면 대쉬보드 건수 클릭 시 접근권한 제어 추가 
    public Map<String, String> getScreen(Map<String, String> params) throws Exception {
		String sslFlag = PropertiesManager.getString("ever.ssl.use.flag");
		params.put("SSL_FLAG", sslFlag);
		return dashboardMapper.getScreen(params);
	}
}
