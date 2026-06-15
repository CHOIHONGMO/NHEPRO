<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	    
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	 <script type="text/javascript">
	        
	    var grid;
	    var baseUrl = "/nhepro/CITI/CITI0010/";

	    function init() {

	        grid = EVF.C("grid");
		    grid.setProperty('shrinkToFit', true);					// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
		    grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
		    grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
		    grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
		    grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
		    grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
		    grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			grid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.cellClickEvent(function(rowIdx, colIdx, value) {
				var param = null;

				switch (colIdx) {
					case "ITEM_REQ_RMK":
						param = {
							title: "추가사양",
							message: grid.getCellValue(rowIdx, 'ITEM_REQ_RMK'),
							callbackFunction: 'setItemRmk',
							rowIdx: rowIdx,
							detailView : false
						};
						var url = '/common/popup/common_text_input/view.so';
						everPopup.openModalPopup(url, 500, (param.detailView == true ? 300 : 320), param);
						break;

					case "IMG_UUID":
						param = {
							bizType: 'IMG',
							attFileNum: grid.getCellValue(rowIdx, 'IMG_UUID'),
							callBackFunction: 'setImageUuid',
							rowIdx: rowIdx,
							detailView: false,
							closeFlag: true
						};
						everPopup.fileAttachPopup(param);
						break;

					case "ATTACH_FILE_NO":
						param = {
							bizType: 'RE',
							attFileNum: grid.getCellValue(rowIdx, 'ATTACH_FILE_NO'),
							callBackFunction: 'setAttachFileNo',
							rowIdx: rowIdx,
							detailView: false,
							closeFlag: true
						};

						everPopup.fileAttachPopup(param);
						break;
				}
			});

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
            });
			
			grid.addRowEvent(function() {
                grid.addRow([{
                	UNIT_CD: "EA"
                }]);
            });
			
			grid.delRowEvent(function() {
				if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
				grid.delRow();
			});

			//grid.excelExportEvent({
			//	allItems : "${excelExport.allCol}",
			//	fileName : "${screenName }"
			//});
			
			//grid.excelImportEvent({
            //    'append': false
            //}, function (msg, code) {
            //    if (code) {
            //        grid.checkAll(true);
            //    }
            //});

		    grid.setColIconify("ITEM_REQ_RMK", "ITEM_REQ_RMK", "detail", true);
		    grid.setColIconify("IMG_UUID", "IMG_UUID", "detail", true);
		    grid.setColIconify("ATTACH_FILE_NO", "ATTACH_FILE_NO", "detail", true);
	    }

	    function setItemRmk(data) {
	    	if(!EVF.isEmpty(data.message)) {
				grid.setCellValue(data.rowIdx, 'ITEM_REQ_RMK', data.message);
	    	}
		}
	    
	    function setImageUuid(rowIdx, uuid, fileCount) {
	    	if(fileCount > 0) {
				grid.setCellValue(rowIdx, 'IMG_UUID', uuid);
	    	}
		}
	    
	    function setAttachFileNo(rowIdx, uuid, fileCount) {
	    	if(fileCount > 0) {
				grid.setCellValue(rowIdx, 'ATTACH_FILE_NO', uuid);
	    	}
		}

	    function doRequest() {
			if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
	    	
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

            // 전화번호 Validation 체크
			for(var i in grid.getSelRowId()) {
			    var selRow = grid.getRowValue(i);

			    if(selRow.PIC_USER_TEL_NUM != "") {
				    var validParam = EVF.maskValid(selRow.PIC_USER_TEL_NUM, "P");
				    if (!validParam.returnType) {
					    return EVF.alert(validParam.returnMsg, function() {
						    grid.setCellValue(i, "PIC_USER_TEL_NUM", "");
					    });
				    }
			    }
		    }

		    var store = new EVF.Store();
		    if(!store.validate()) { return; }
            EVF.confirm('${CITI0010_CONFIRM1}', function () {
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
				store.doFileUpload(function() {
					store.load(baseUrl + 'citi0010_doRequest.so', function() {
						EVF.alert(this.getResponseMessage());
						location.reload();
					});
				});
			});
	    }

    </script>
	<e:window id="CITI0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:buttonBar align="right" width="100%">
			<e:button id="doRequest" name="doRequest" label="${doRequest_N}" onClick="doRequest" disabled="${doRequest_D}" visible="${doRequest_V}"/>

		</e:buttonBar>
		<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>