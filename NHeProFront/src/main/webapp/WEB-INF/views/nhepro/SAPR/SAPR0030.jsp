<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	    
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	 <script type="text/javascript">
	        
	    var grid;
	    var baseUrl = "/nhepro/SAPR/";

	    function init() {
	        grid = EVF.C("grid");
	        
		    grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
		    grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
		    grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		    grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		    grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		    grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		    grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', false); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.cellClickEvent(function(rowIdx, colIdx, value) {
				var param = null;

				switch (colIdx) {
					case "PAY_ATT_FILE_NUM_CNT":
						param = {
	                        attFileNum: grid.getCellValue(rowIdx, "PAY_ATT_FILE_NUM"),
	                        rowIdx: rowIdx,
	                        callBackFunction: "callbackPAY_ATT_FILE_NUM_CNT",
	                        bizType: "AD",
	                        detailView: true
	                    };
	                    everPopup.fileAttachPopup(param);
						break;
						
					case "PAY_ACC_NM":
						
						var data = grid.getRowValue(rowIdx);
						var selectedData = JSON.stringify(data);

			            opener['${param.callBackFunction}'](selectedData);
			            doClose();
						break;	
				}
			});
			
			doSearchVNAP();

	    }
	    
	    function doSearchVNAP() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "sapr0030_doSearchVNAP.so", function() {
            	if(grid.getRowCount() > 0) {
            		grid.setColIconify("PAY_ATT_FILE_NUM_CNT", "PAY_ATT_FILE_NUM_CNT", "file", false);
                }
            });
        }
	    
	    function doClose() {
			EVF.closeWindow();
		}
	    
    </script>
    
	<e:window id="SAPR0030" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		
		<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${param.VENDOR_CD}"/>
		
		<e:buttonBar align="right" width="100%">
			<e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>