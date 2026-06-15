<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/SPOR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid._gvo.setCheckBar({showAll: false});

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "multiSelect") {
                    if(value == "1") {
                        grid.checkEqualRow(["PO_NUM", "PAY_CNT"], [grid.getCellValue(rowIdx, "PO_NUM"), grid.getCellValue(rowIdx, "PAY_CNT")]);
                    } else {
                        grid.checkNotEqualRow(["PO_NUM", "PAY_CNT"], [grid.getCellValue(rowIdx, "PO_NUM"), grid.getCellValue(rowIdx, "PAY_CNT")]);
                    }
                } else if(colIdx == "PO_NUM") {
                    param = {
                        callbackFunction: "",
                        PO_NUM: value,
                        BUYER_CD: grid.getCellValue(rowIdx, "BUYER_CD"),
                        detailView: true,
                        buttonView: false
                    };
                    everPopup.openPopupByScreenId("SPOR0011", 1200, 750, param);
                } else if(colIdx == "CTRL_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "CTRL_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "CTRL_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                } else if(colIdx == "INSPECT_USER_NM") {
                    param = {
                        callbackFunction: "",
                        USER_TYPE: grid.getCellValue(rowIdx, "INSPECT_USER_TYPE"),
                        USER_ID: grid.getCellValue(rowIdx, "INSPECT_USER_ID"),
                        detailView: true
                    };
                    // everPopup.openPopupByScreenId("MTUA0011", 600, 190, param);
                }
            });

            EVF.C("SEL_DATE").removeOption("DUE");
            EVF.C("SEL_DATE").removeOption("DUEQ");
            EVF.C("SEL_DATE").removeOption("INV");
            EVF.C("SEL_DATE").removeOption("REG");
            EVF.C("SEL_DATE").removeOption("REQI");
            EVF.C("SEL_DATE").removeOption("INVI");
            EVF.C("SEL_DATE").removeOption("AP");
            EVF.V("SEL_DATE", "PO");
            
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
		    grid.setRowFooter("BUYER_DEPT_NM", footer);

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
		    grid.setRowFooter("INS_AMT", distVal);
		    grid.setRowFooter("PAY_AMT", distVal);
		    // ===========================================================
		    
		    // 2021.01.20 자동조회 추가
		    doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.setParameter("SEL_DATE", $("#SEL_DATE").val());
            store.load(baseUrl + "spor0050_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    grid.setColMerge(["PO_CREATE_DATE","PO_CREATE_TYPE", "PO_NUM", "SUBJECT", "PO_AMT"]);
                }
            });
        }

        function doCreate() {
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (grid.getSelRowCount() > 1) { return EVF.alert("${SPOR0050_003}"); }

            var gridSel = [];
            var selRowValue = grid.getSelRowValue();
            for(var k in selRowValue) {
                var BUYER_CD = selRowValue[k].BUYER_CD;
                var DEPT_CD  = selRowValue[k].DEPT_CD;
                var PO_NUM   = selRowValue[k].PO_NUM;
                var PO_SQ    = selRowValue[k].PO_SQ;
                var PAY_CNT  = selRowValue[k].PAY_CNT;
                var PO_DATE  = selRowValue[k].PO_CREATE_DATE;
                var PO_CREATE_TYPE  = selRowValue[k].PO_CREATE_TYPE;
                var CONT_NUM = selRowValue[k].CONT_NUM;
                var CONT_CNT = selRowValue[k].CONT_CNT;
                var CONT_REQ_CD  = selRowValue[k].CONT_REQ_CD;
                var B_CONT_START_DATE  = selRowValue[k].B_CONT_START_DATE;
                var CONT_START_DATE  = selRowValue[k].CONT_START_DATE;
                var B_CONT_END_DATE  = selRowValue[k].B_CONT_END_DATE;
                var CONT_END_DATE  = selRowValue[k].CONT_END_DATE;
                var INSPECT_USER_COMPANY = selRowValue[k].INSPECT_USER_COMPANY;
				
                gridSel.push({
                    BUYER_CD: BUYER_CD,
                    DEPT_CD : DEPT_CD,
                    PO_NUM  : PO_NUM,
                    PO_SQ   : PO_SQ,
                    PAY_CNT : PAY_CNT,
                    PO_DATE : PO_DATE,
                    PO_CREATE_TYPE : PO_CREATE_TYPE,
                    CONT_NUM : CONT_NUM,
                    CONT_CNT : CONT_CNT,
                    CONT_REQ_CD : CONT_REQ_CD,
                    B_CONT_START_DATE : B_CONT_START_DATE,
                    CONT_START_DATE : CONT_START_DATE,
                    B_CONT_END_DATE : B_CONT_END_DATE,
                    CONT_END_DATE : CONT_END_DATE,
                    INSPECT_USER_COMPANY : INSPECT_USER_COMPANY
                });
            }
			
            // 2021.08.18
            // 발주일자 2021.09.01 이전의 발주건은 지급차수에 상관없이 검수요청이 가능하도록 함
            // 이전의 검수요청되지 않은 지급차수가 있는 경우 alert창 띄우기
            // 발주일자 2021.09.01 이후의 발주건은 기존과 같은 로직으로 처리
            // 2022.06.02
            // 농협은행 IT부문이 중앙회에 계약의뢰한건의 검수요청을 수기로 작성진행 중 5월분부터 시스템에서 검수요청 
            // 발주일자 2022.05.01 이전의 발주건은 지급차수에 상관없이 검수요청이 가능하도록 함
            // 발주일자 2022.05.01 이후의 발주건은 기존과 같은 로직으로 처리
            // 2023.03.21
            // 농협은행, 농협중앙회 보안기획팀 수기로 발주관리 이후 전자구매시스템 사용 
            // 발주일자 2023.04.01 이전의 발주건은 지급차수에 상관없이 검수요청이 가능하도록 함
            // 발주일자 2023.04.01 이후의 발주건은 기존과 같은 로직으로 처리
            var curPayCnt = 0;
            var allRowValue = grid.getAllRowValue();

        	if((gridSel[0].CONT_REQ_CD == '20') &&(gridSel[0].PO_CREATE_TYPE == 'DRAFT')){
        		
        		if((gridSel[0].B_CONT_START_DATE == gridSel[0].CONT_START_DATE) && (gridSel[0].B_CONT_END_DATE == gridSel[0].CONT_END_DATE) ){
        			for(var i in allRowValue) {
    	                //if( (allRowValue[i].PO_NUM == gridSel[0].PO_NUM) && (allRowValue[i].PAY_CNT < gridSel[0].PAY_CNT) ) {
    	                if( (allRowValue[i].PO_NUM == gridSel[0].PO_NUM) ) {	
    	                	if("C00066" == INSPECT_USER_COMPANY || "C00068" == INSPECT_USER_COMPANY || "C00007" == INSPECT_USER_COMPANY) {
    	                		if (gridSel[0].PO_DATE < '20230401') {
        	                   		curPayCnt++;
        	                   		break;
        	                   	} else {
        	                   		var store = new EVF.Store();
        		                	store.setGrid([grid]);
        		                    store.getGridData(grid, 'sel');
        		                    store.load(baseUrl + "spor0050_doIvhCheck.so", function() {
        		                    	var payCnt = this.getParameter('PAY_CNT');
        		                    	if((gridSel[0].PAY_CNT - 1) != payCnt){
        		                    		return EVF.alert("${SPOR0050_004}");
        		                    	}	
        		                    });
        	                   	}	                		
    	                	} else {
    	                		if (gridSel[0].PO_DATE < '20210901') {
        	                   		curPayCnt++;
        	                   		break;
        	                   	} else {
        	                   		var store = new EVF.Store();
        		                	store.setGrid([grid]);
        		                    store.getGridData(grid, 'sel');
        		                    store.load(baseUrl + "spor0050_doIvhCheck.so", function() {
        		                    	var payCnt = this.getParameter('PAY_CNT');
        		                    	if((gridSel[0].PAY_CNT - 1) != payCnt){
        		                    		return EVF.alert("${SPOR0050_004}");
        		                    	}	
        		                    });
        	                   	}
    	                	}
    	                } 
    	            }
        		} else {
        			for(var i in allRowValue) {
    	                if( (allRowValue[i].PO_NUM == gridSel[0].PO_NUM) && (allRowValue[i].PAY_CNT < gridSel[0].PAY_CNT) ) {
    	                   	if("C00066" == INSPECT_USER_COMPANY || "C00068" == INSPECT_USER_COMPANY || "C00007" == INSPECT_USER_COMPANY) {
    	                		if (gridSel[0].PO_DATE < '20230401') {
    		                   		curPayCnt++;
    		                   		break;
    		                   	}else {
    		                    	return EVF.alert("${SPOR0050_004}");
    		                   	}	                		
    	                	} else {
    	                		if (gridSel[0].PO_DATE < '20220501') {
    		                   		curPayCnt++;
    		                   		break;
    		                   	}else {
    		                    	return EVF.alert("${SPOR0050_004}");
    		                   	}
    	                	}
    	                }
    	            }
        		}
        	}else{
        		for(var i in allRowValue) {
	                if( (allRowValue[i].PO_NUM == gridSel[0].PO_NUM) && (allRowValue[i].PAY_CNT < gridSel[0].PAY_CNT) ) {
	                	if("C00066" == INSPECT_USER_COMPANY || "C00068" == INSPECT_USER_COMPANY || "C00007" == INSPECT_USER_COMPANY) {
	                		if (gridSel[0].PO_DATE < '20230401') {
		                   		curPayCnt++;
		                   		break;
		                   	}else {
		                    	return EVF.alert("${SPOR0050_004}");
		                   	}	                		
	                	} else {
	                		if (gridSel[0].PO_DATE < '20220501') {
		                   		curPayCnt++;
		                   		break;
		                   	}else {
		                    	return EVF.alert("${SPOR0050_004}");
		                   	}
	                	}
	                }
	            }
        	}
            
            var param = {
                    callbackFunction: "",
                    gridSel: JSON.stringify(gridSel),
                    detailView: false,
                    buttonView: true
                };
            
            if (curPayCnt > 0) {
            	EVF.confirm("${SPOR0050_005}", function () {
                    everPopup.openPopupByScreenId("SPOI0051", 1200, 870, param);
                });
            }
            else {
                everPopup.openPopupByScreenId("SPOI0051", 1200, 870, param);
            }
        }
    </script>

    <e:window id="SPOR0050" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="VENDOR_REJECT_RMK" name="VENDOR_REJECT_RMK"/>
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="SEL_DATE" title="">
                    <e:select id="SEL_DATE" name="SEL_DATE" value="" options="${selDateOptions}" width="${form_SEL_DATE_W}" disabled="${form_SEL_DATE_D}" readOnly="${form_SEL_DATE_RO}" required="${form_SEL_DATE_R}" placeHolder="" usePlaceHolder="false" maskType="${form_SEL_DATE_MT}" />
                </e:label>
                <e:field>
                    <e:inputDate id="FROM_DATE" name="FROM_DATE" toDate="TO_DATE" value="${FROM_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_FROM_DATE_R}" disabled="${form_FROM_DATE_D}" readOnly="${form_FROM_DATE_RO}" />
                    <e:text> ~ </e:text>
                    <e:inputDate id="TO_DATE" name="TO_DATE" fromDate="FROM_DATE" value="${TO_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_TO_DATE_R}" disabled="${form_TO_DATE_D}" readOnly="${form_TO_DATE_RO}" />
                </e:field>
                <e:label for="PO_NUM" title="${form_PO_NUM_N}" />
                <e:field>
                    <e:inputText id="PO_NUM" name="PO_NUM" value="" width="${form_PO_NUM_W}" maxLength="${form_PO_NUM_M}" disabled="${form_PO_NUM_D}" readOnly="${form_PO_NUM_RO}" required="${form_PO_NUM_R}" style="${imeMode}" maskType="${form_PO_NUM_MT}"/>
                </e:field>
                <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
                <e:field>
                    <e:inputText id="SUBJECT" name="SUBJECT" value="" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
            <e:button id="doCreate" name="doCreate" label="${doCreate_N}" onClick="doCreate" disabled="${doCreate_D}" visible="${doCreate_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
