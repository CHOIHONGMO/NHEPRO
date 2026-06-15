<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>


<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

	    var grid;
		var baseUrl = "/nhepro/CCBR/";
		
	    function init() {

	        grid = EVF.C("grid");

	        grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			grid.setProperty('singleSelect', false);					// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false);		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
			// ======================그리드 합계 구하기=======================
		    var val = {"visible": true, "count": 1, "height": 15};
		    grid.setProperty('footerVisible', val);

		    var footer = {
		          "styles": {
		              "textAlignment": "center",
		              "fontBold": true,
		              "fontFmaily": "Nanum Gothic",
		          },
		          "text": "합   계"
		    };
		    grid.setRowFooter("CORP_NO", footer);

		    var distVal = {
		          "styles": {
		              "textAlignment": "far",
		              "numberFormat" : "#,###.###",
		              "fontFmaily": "Nanum Gothic",
		              "paddingRight": 5,
		              "fontBold": true
		          },
		          "expression": ["sum"],
		          "groupExpression": "sum"
		    };
		    
		    var buyerCd = EVF.V("BUYER_CD");
		  	if(buyerCd == 'C08761'){ // 운영 파트너스 고객사코드
    		//if(buyerCd == 'C05861'){ // 개발 파트너스 고객사코드
			    grid.setRowFooter("COST", distVal);
			    grid.setRowFooter("VAT", distVal);
    		} else {
    			grid.setRowFooter("PY_COST", distVal);
			    grid.setRowFooter("PY_VAT", distVal);   
    		}
		    
    		if(buyerCd == 'C08761'){ // 운영 파트너스 고객사코드
    		//if(buyerCd == 'C05861'){ // 개발 파트너스 고객사코드	
    			grid.hideCol('BRC', true);
				grid.hideCol('DEPT_NM', true);
				grid.hideCol('CONT_AMT', true);
				grid.hideCol('CONT_TYPE', true);
				grid.hideCol('PY_BUYER_CD', true);
				grid.hideCol('PY_BUYER_CD_NM', true);
				grid.hideCol('PY_BUYER_CD_CNT', true);
				grid.hideCol('PY_COST', true);
				grid.hideCol('PY_VAT', true);
    		} else {
    			grid.hideCol('CONT_USER_ID', true);
				grid.hideCol('CONT_USER_NM', true);
				grid.hideCol('CONT_DEPT_CD', true);
				grid.hideCol('CONT_DEPT_NM', true);
    		}
    		
    		setType();
		}
        
        function setType() {
        	EVF.C('PY_COST_SUM').setStyle("color:blue;font-weight:bold;");
        	EVF.C('PY_VAT_SUM').setStyle("color:blue;font-weight:bold;");
        	EVF.C('PY_AMT').setStyle("color:blue;font-weight:bold;");
        }
        
	    function doSearch() {

	    	var store = new EVF.Store();
			if(!store.validate()) { return; }

	        store.setGrid([grid]);
	        store.load(baseUrl + 'ccbr0010_doSearch.so', function() {
	        	if(grid.getRowCount() == 0){
	            	EVF.alert("${msg.M0002 }");
	            } else {
	            	EVF.V("PY_COST_SUM", Number(this.getParameter("pyCostSum")));
	            	EVF.V("PY_VAT_SUM", Number(this.getParameter("pyVatSum")));
	            	EVF.V("PY_AMT", Number(this.getParameter("pyAmt")));
	            }
	        });
	    }

    </script>
	<e:window id="CCBR0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
		<e:inputHidden id='BUYER_CD' name="BUYER_CD" value="${ses.companyCd}" />
		<e:searchPanel id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="STD_QUARTER" title="${form_STD_QUARTER_N}"/>
                <e:field>
                	<e:select id="STD_YEAR" name="STD_YEAR" value="${STD_YEAR}" options="${stdYearOptions}" width="35%" disabled="${form_STD_YEAR_D}" readOnly="${form_STD_YEAR_RO}" required="${form_STD_YEAR_R}" placeHolder="선택" maskType="${form_STD_YEAR_MT}" />
                    <e:text>년도</e:text>
                    <e:select id="STD_QUARTER" name="STD_QUARTER" value="" options="${stdQuarterOptions}" width="60%" disabled="${form_STD_QUARTER_D}" readOnly="${form_STD_QUARTER_RO}" required="${form_STD_QUARTER_R}" placeHolder="선택" maskType="${form_STD_QUARTER_MT}" />
                </e:field>
				<e:label for="" title=""/>
				<e:field> </e:field>
			</e:row>
		</e:searchPanel>
		
		<e:buttonBar id="buttonBar" align="right" width="100%" title="계약수수료청구금액">
			<e:button id="doSearch" name="doSearch" label="${doSearch_N }" disabled="${doSearch_D }" visible="${doSearch_V}" onClick="doSearch" />
		</e:buttonBar>
		
		<e:searchPanel id="sp" title="" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="" >
			<e:row>
				<e:label for="PY_COST_SUM" title="${form_PY_COST_SUM_N}" />
				<e:field>
					<e:inputNumber id="PY_COST_SUM" name="PY_COST_SUM" value="${form.PY_COST_SUM}" width="${form_PY_COST_SUM_W}" maxValue="${form_PY_COST_SUM_M}" decimalPlace="${form_PY_COST_SUM_NF}" disabled="${form_PY_COST_SUM_D}" readOnly="${form_PY_COST_SUM_RO}" required="${form_PY_COST_SUM_R}" onNumberKr="${form_PY_COST_SUM_KR}" currencyText="${form_PY_COST_SUM_CT}"/>
				</e:field>
				<e:label for="PY_VAT_SUM" title="${form_PY_VAT_SUM_N}" />
				<e:field>
					<e:inputNumber id="PY_VAT_SUM" name="PY_VAT_SUM" value="${form.PY_VAT_SUM}" width="${form_PY_VAT_SUM_W}" maxValue="${form_PY_VAT_SUM_M}" decimalPlace="${form_PY_VAT_SUM_NF}" disabled="${form_PY_VAT_SUM_D}" readOnly="${form_PY_VAT_SUM_RO}" required="${form_PY_VAT_SUM_R}" onNumberKr="${form_PY_VAT_SUM_KR}" currencyText="${form_PY_VAT_SUM_CT}"/>
				</e:field>
				<e:label for="PY_AMT" title="${form_PY_AMT_N}" />
				<e:field>
					<e:inputNumber id="PY_AMT" name="PY_AMT" value="${form.PY_AMT}" width="${form_PY_AMT_W}" maxValue="${form_PY_AMT_M}" decimalPlace="${form_PY_AMT_NF}" disabled="${form_PY_AMT_D}" readOnly="${form_PY_AMT_RO}" required="${form_PY_AMT_R}" onNumberKr="${form_PY_AMT_KR}" currencyText="${form_PY_AMT_CT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<e:buttonBar id="itemBtnBar" align="right" width="100%" title="계약수수료 내역" />
		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>