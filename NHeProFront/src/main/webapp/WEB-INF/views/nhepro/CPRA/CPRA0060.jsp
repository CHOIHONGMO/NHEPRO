<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String devFlag = PropertiesManager.getString("eversrm.system.developmentFlag"); %>

<c:set var="devFlag" value="<%=devFlag%>" />
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript" src="/js/ever-math.js"></script>
	<script>

	    var grid1,grid2,grid3,grid4,grid5,grid6;
		var baseUrl = "/nhepro/CPRA/";

		function init() {
<c:if test="${param.MNT_YN != 'Y' && param.MNT_YN != 'O' && param.MNT_YN != 'Z'}">
			grid1 = EVF.C("grid1");
			grid2 = EVF.C("grid2");
			grid3 = EVF.C("grid3");

			grid1.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid1.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid1.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid1.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid1.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid1.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid1.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid1.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid2.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid2.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid2.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid2.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid2.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid2.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid2.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid2.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid3.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid3.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid3.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid3.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid3.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid3.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid3.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid3.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]



            grid1.setColGroup([
            	{
                "groupName": '사업추진일정',
                "columns": [ "BZ_TIMELINE_SDAY", "BZ_TIMELINE_EDAY"]
	            }
            	,{
                    "groupName": '소요금액(원)',
                    "columns": [ "C_DET_ESTIMATE_AMOUNT", "A_DET_ESTIMATE_AMOUNT", "B_DET_ESTIMATE_AMOUNT", "F_DET_ESTIMATE_AMOUNT", "E_DET_ESTIMATE_AMOUNT", "TOTAL_DET_ESTIMATE_AMOUNT"]
    	         }
            	,{
                    "groupName": '계약규정/준칙',
                    "columns": [ "CM_PROVISION", "CM_SAYU"]
    	         }
            	]
            );

            grid2.setColGroup([
            	{
                "groupName": 'H/W, S/W, 기타',
                "columns": [ "MAF_COMP", "LICEN_TYPE", "AM_CNT", "AM_CNT_DANWI"]
	            }
            	/* ,{
                    "groupName": '개발비(M/M)',
                    "columns": [ "FRT_CLS_MM", "MID_CLS_MM", "HIG_CLS_MM", "SPC_CLS_MM", "TOT_TUIB_GONGSU"]
    	         } */
            	,{
                    "groupName": '개발비(M/M)',
                    "columns": [ "CLS_GRADE", "TOT_TUIB_GONGSU"]
    	         }
            	,{
                    "groupName": '소요금액(원)',
                    "columns": [ "C_ESTIMATE_AMOUNT", "A_ESTIMATE_AMOUNT", "B_ESTIMATE_AMOUNT", "F_ESTIMATE_AMOUNT", "E_ESTIMATE_AMOUNT", "ESTIMATE_AMOUNT"]
    	         }
            	,{
                    "groupName": '예산정보',
                    "columns": [ "BDGT_BUSEO_NM", "PAY_BUSEO_NM"]
    	         }

            	]
            );

			doSearch1();
			doSearch2();
			doSearch3();
</c:if>
<c:if test="${param.MNT_YN == 'Y' ||param.MNT_YN == 'O' ||param.MNT_YN == 'Z'}">
			grid4 = EVF.C("grid4");
			grid5 = EVF.C("grid5");
			grid6 = EVF.C("grid6");

			grid4.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid4.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid4.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid4.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid4.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid4.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid4.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid4.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid5.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid5.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid5.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid5.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid5.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid5.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid5.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid5.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid6.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid6.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid6.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid6.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid6.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid6.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid6.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid6.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]


            grid4.setColGroup([
            	{
                "groupName": '계약규정/준칙',
                "columns": [ "CM_PROVISION", "CM_SAYU"]
	            }
            	]
            );



			doSearch4();
			doSearch5();
			doSearch6();
</c:if>
		}

		function doClose() {
			EVF.closeWindow();
		}



		function doSearch1() {
			var store = new EVF.Store(); store.setGrid([grid1]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid1.so", function () {});
		}
		function doSearch2() {
			var store = new EVF.Store(); store.setGrid([grid2]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid2.so", function () {});
		}
		function doSearch3() {
			var store = new EVF.Store(); store.setGrid([grid3]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid3.so", function () {});
		}
		function doSearch4() {
			var store = new EVF.Store(); store.setGrid([grid4]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid4.so", function () {});
		}
		function doSearch5() {
			var store = new EVF.Store(); store.setGrid([grid5]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid5.so", function () {});
		}
		function doSearch6() {
			var store = new EVF.Store(); store.setGrid([grid6]);
			store.load(baseUrl + "/CPRA0060/CPRA0060_doSearchGrid6.so", function () {});
		}



	</script>

	<e:window id="CPRA0060" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
<c:if test="${param.MNT_YN == 'Y' ||param.MNT_YN == 'O' ||param.MNT_YN == 'Z'}">
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">IT Portal 정보 (유지보수)</div>
    </div>
</c:if>
<c:if test="${param.MNT_YN != 'Y' && param.MNT_YN != 'O' && param.MNT_YN != 'Z'}">
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">IT Portal 정보 (물품/용역)</div>
    </div>
</c:if>
    	<e:searchPanel id="form" labelWidth="105" labelAlign="${labelAlign}" columnCount="3" onEnter="doSearch" useTitleBar="false">
			<e:row>
				<e:label for="CM_REQ_ID" title="${form_CM_REQ_ID_N}" />
				<e:field>
				<e:inputText id="CM_REQ_ID" name="CM_REQ_ID" value="${form.CM_REQ_ID}" width="100%" maxLength="${form_CM_REQ_ID_M}" disabled="${form_CM_REQ_ID_D}" readOnly="${form_CM_REQ_ID_RO}" required="${form_CM_REQ_ID_R}" style="${imeMode}" maskType="${form_CM_REQ_ID_MT}"/>
				</e:field>
				<e:label for="OFFICE_DOCU_NUM" title="${form_OFFICE_DOCU_NUM_N}" />
				<e:field>
				<e:inputText id="OFFICE_DOCU_NUM" name="OFFICE_DOCU_NUM" value="${form.OFFICE_DOCU_NUM}" width="100%" maxLength="${form_OFFICE_DOCU_NUM_M}" disabled="${form_OFFICE_DOCU_NUM_D}" readOnly="${form_OFFICE_DOCU_NUM_RO}" required="${form_OFFICE_DOCU_NUM_R}" style="${imeMode}" maskType="${form_OFFICE_DOCU_NUM_MT}"/>
				</e:field>
				<e:label for="BZ_PART_NM" title="${form_BZ_PART_NM_N}" />
				<e:field>
				<e:inputText id="BZ_PART_NM" name="BZ_PART_NM" value="${form.BZ_PART_NM}" width="100%" maxLength="${form_BZ_PART_NM_M}" disabled="${form_BZ_PART_NM_D}" readOnly="${form_BZ_PART_NM_RO}" required="${form_BZ_PART_NM_R}" style="${imeMode}" maskType="${form_BZ_PART_NM_MT}"/>
				</e:field>
			</e:row>
<c:if test="${param.MNT_YN == 'Y' ||param.MNT_YN == 'O' ||param.MNT_YN == 'Z'}">
			<e:row>
				<e:label for="MNT_TYPE" title="${form_MNT_TYPE_N}" />
				<e:field colSpan="5">
				<e:inputText id="MNT_TYPE" name="MNT_TYPE" value="${form.MNT_TYPE}" width="500%" maxLength="${form_MNT_TYPE_M}" disabled="${form_MNT_TYPE_D}" readOnly="${form_MNT_TYPE_RO}" required="${form_MNT_TYPE_R}" style="${imeMode}" maskType="${form_MNT_TYPE_MT}"/>
				</e:field>
			</e:row>
</c:if>
	    </e:searchPanel>
<c:if test="${param.MNT_YN != 'Y' && param.MNT_YN != 'O' && param.MNT_YN != 'Z'}">
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">계약체결내용</div>
    </div>
    	<e:gridPanel id="grid1" name="grid1" height="150px" gridType="${_gridType}" readOnly="${param.detailView}"/>
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">표준물품명세서</div>
    </div>
		<e:gridPanel id="grid2" name="grid2" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">견적서</div>
    </div>
		<e:gridPanel id="grid3" name="grid3" height="150px" gridType="${_gridType}" readOnly="${param.detailView}"/>
</c:if>
<c:if test="${param.MNT_YN == 'Y' ||param.MNT_YN == 'O' ||param.MNT_YN == 'Z'}">
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">계약체결내용</div>
    </div>
		<e:gridPanel id="grid4" name="grid4" height="150px" gridType="${_gridType}" readOnly="${param.detailView}"/>
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">표준물품명세서</div>
    </div>
		<e:gridPanel id="grid5" name="grid5" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>
    <div style="padding-bottom: 3px; padding-top: 5px;">
        <div class="e-title-bullet-h1" style="padding-bottom: 1px;"></div><div class="e-title-text">견적서</div>
    </div>
		<e:gridPanel id="grid6" name="grid6" height="150px" gridType="${_gridType}" readOnly="${param.detailView}"/>

</c:if>
	</e:window>
</e:ui>