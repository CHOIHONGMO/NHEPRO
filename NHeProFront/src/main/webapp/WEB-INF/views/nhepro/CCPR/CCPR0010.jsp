<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid;
		var baseUrl = "/nhepro/CCPR/CCPR0010";

		var custNm = "${param.CUST_NAME}";
    	var custCd = "${param.CUST_CODE}";
    	
		function init() {
			grid  = EVF.C("grid");
            
			grid.setProperty("shrinkToFit", true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]

			
			grid.cellClickEvent(function (rowIdx, colId, value) {
				
				switch (colId) {
				case 'SUBCUST_NAME':
						if(value != '') {
							var data = grid.getRowValue(rowIdx);
							data.rowIdx = "${param.rowIdx}";
							
							var selectedData = JSON.stringify(data);
							
							console.log("selectedData"+selectedData)
							
							if(${param.ModalPopup == true}){
				                parent['${param.callBackFunction}'](selectedData);
				            }else{
				                opener['${param.callBackFunction}'](selectedData);
				            }
						    doClose();
						}
                    
					break;
				}
			});
			
			getCust();
			
		}//init 종료
		
		// Search
		function doSearch() {
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;
			
			store.setGrid([grid]);
			store.load(baseUrl + "/ccpr0010_doSearch.so", function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert("${msg.M0002}");
				}
			});
		}
		
		function doChoose() {
			
			if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var selectedData = grid.getSelRowValue();
	        if( grid.isEmpty( selectedData) ) { return ; }
	        
	        if(${param.ModalPopup == true}){
                parent['${param.callBackFunction}'](selectedData);
            }else{
                opener['${param.callBackFunction}'](selectedData);
            }
	        
		    doClose();
	    }
		
		function doClose() {
            EVF.closeWindow();
        }
		
		var k = 0;

        function getCust() {
        	EVF.C('CUST_NAME').setValue(custNm);
        }        
	</script>

	<e:window id="CCPR0010" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        
		<e:searchPanel id="form" title="${msg.M9999}" columnCount="2" labelWidth="${labelWidth}" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="CUST_NAME" title="${form_CUST_NAME_N}" />
				<e:field>
					<e:inputText id="CUST_NAME" name="CUST_NAME" value="" width="${form_CUST_NAME_W}" maxLength="${form_CUST_NAME_M}" disabled="${form_CUST_NAME_D}" readOnly="${form_CUST_NAME_RO}" required="${form_CUST_NAME_R}" style="${imeMode}" maskType="${form_CUST_NAME_MT}"/>
				</e:field>
				<e:label for="SUBCUST_NAME" title="${form_SUBCUST_NAME_N}" />
				<e:field>
					<e:inputText id="SUBCUST_NAME" name="SUBCUST_NAME" value="" width="${form_SUBCUST_NAME_W}" maxLength="${form_SUBCUST_NAME_M}" disabled="${form_SUBCUST_NAME_D}" readOnly="${form_SUBCUST_NAME_RO}" required="${form_SUBCUST_NAME_R}" style="${imeMode}" maskType="${form_SUBCUST_NAME_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		
        <e:buttonBar id="buttonBar" align="right" width="100%">
          <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
          <!--<e:button id="doChoose" name="doChoose" label="${doChoose_N}" onClick="doChoose" disabled="${doChoose_D}" visible="${doChoose_V}"/>-->
        </e:buttonBar>
		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />
	</e:window>
</e:ui>

