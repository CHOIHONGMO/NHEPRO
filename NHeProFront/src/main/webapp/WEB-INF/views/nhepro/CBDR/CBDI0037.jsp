<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

        var grid;
		var baseUrl = "/nhepro/CBDR/";
		var firstNegotiatorFlag;

	    function init() {

            grid = EVF.C("grid");
            
        	var bidStatus = "${formData.BID_STATUS}";
        	var contType2 = "${formData.CONT_TYPE2}";
        	
            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                
            	// 기술평가 첨부파일
                if(colIdx == "TECH_ATT_FILE_CNT") {
                	if( value == 0 ) return;
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'TECH_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'BID',
						detailView: true
					};
					everPopup.fileAttachPopup(param);
                }
                
            	// 기술협상 첨부파일
                if(colIdx == "NEGO_ATT_FILE_CNT") {
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'NEGO_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setNegoFileAttach',
						bizType: 'BID',
						detailView: bidStatus=='2500'?true:false
					};
					everPopup.fileAttachPopup(param);
                }
                
            	// 추가 첨부파일
                if(colIdx == "ETC_ATT_FILE_CNT") {
					var param = {
						attFileNum: grid.getCellValue(rowIdx, 'ETC_ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setEtcFileAttach',
						bizType: 'BID',
						detailView: bidStatus=='2500'?true:false
					};
					everPopup.fileAttachPopup(param);
                }
                
                if(colIdx == "TECH_RMK") {
                	if( value == "" ) return;
					var param = {
							callbackFunction: 'setRMK',
							title: "기술평가비고",
							message: grid.getCellValue(rowIdx, 'TECH_RMK'),
							rowIdx: rowIdx
						};
					everPopup.commonTextView(param);
                }
                
                if(colIdx == "NEGO_RMK") {
					var param = {
							callbackFunction: 'setNEGORMK',
							title: "기술협상내역",
							message: grid.getCellValue(rowIdx, 'NEGO_RMK'),
							rowIdx: rowIdx
						};
					if( bidStatus == "2500" ) {
						everPopup.commonTextView(param);
					} else {
						everPopup.commonTextInput(param);
					}
                }
                
                if(colIdx == "ETC_RMK") {
					var param = {
							callbackFunction: 'setETCRMK',
							title: "추가내역",
							message: grid.getCellValue(rowIdx, 'ETC_RMK'),
							rowIdx: rowIdx
						};
					if( bidStatus == "2500" ) {
						everPopup.commonTextView(param);
					} else {
						everPopup.commonTextInput(param);
					}
                }
            });

            grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', true);                 	// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			
            grid.setColGroup([
				{
                    "groupName": '기술평가내역',
                    "columns": ['TECH_SCORE', 'PRC_SCORE', 'SUM_SCORE', 'TECH_ATT_FILE_CNT', 'TECH_RMK']
                }
				,{
                    "groupName": '기술협상내역 등록',
                    "columns": ['NEGO_ATT_FILE_CNT', 'NEGO_RMK']
                }
				,{
                    "groupName": '추가정보 등록',
                    "columns": ['ETC_ATT_FILE_CNT', 'ETC_RMK']
                }
            ],50);
            
         	// 업체선정완료인 경우 저장 비활성화
            if( bidStatus == "2500" ) {
            	EVF.C('doSave').setDisabled(true);
            	
            	EVF.C('NEGO_START_DATE').setReadOnly(true);
       	        EVF.C('NEGO_END_DATE').setReadOnly(true);
            } else {
            	EVF.C('doSave').setDisabled(false);
            	
            	if( contType2 == "NE" ) { // 협상에 의한 낙찰자 선정
	            	EVF.C('NEGO_START_DATE').setReadOnly(false);
	       	        EVF.C('NEGO_END_DATE').setReadOnly(false);
            	} else {
	            	EVF.C('NEGO_START_DATE').setReadOnly(true);
	       	        EVF.C('NEGO_END_DATE').setReadOnly(true);
            	}
            }
            
            doSearch();
        }
		
        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.load(baseUrl + 'cbdi0034_doSearchVendorVO.so', function() {
            	
				firstNegotiatorFlag = this.getParameter("firstNegotiatorFlag");
                if(grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                }
                else {
					var rowIds = grid.getAllRowId();
					if(firstNegotiatorFlag == "N") {
						for (var i in rowIds) {
							if (grid.getCellValue(rowIds[i], 'BID_STATUS') == "100" || grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {
								grid.setCellValue(rowIds[i], 'BID_STATUS', "200");
								grid.setCellValue(rowIds[i], 'ORI_BID_STATUS', "200");
								grid.setCellReadOnly(rowIds[i], 'PRC_SCORE', false);
								break;
							}
						}
					} else {
						for (var i in rowIds) {
                            grid.setCellReadOnly(rowIds[i], 'PRC_SCORE', false);
						}
					}
					
                    for (var i in rowIds) {
                        if (grid.getCellValue(rowIds[i], 'BID_STATUS') == "300") {
                            grid.setCellFontColor(rowIds[i],  'VENDOR_NM', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'VENDOR_NM', true);
                            grid.setCellFontColor(rowIds[i],  'SUM_SCORE', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'SUM_SCORE', true);
                            grid.setCellFontColor(rowIds[i],  'BID_STATUS', "#ff0000");
                            grid.setCellFontWeight(rowIds[i], 'BID_STATUS', true);
                        }
                    }
					
                    // 기술평가 첨부파일
                    grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
                    
                    // 기술협상 첨부파일
                    grid.setColIconify("NEGO_RMK", "NEGO_RMK", "comment", false);
                    
                    // 추가 첨부파일
                    grid.setColIconify("ETC_RMK", "ETC_RMK", "comment", false);
                }
            });
        }
		
        // 기술협상결과 등록
        function doSave() {
			
			var store = new EVF.Store();
			if(!store.validate()) return;
			//if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            
            EVF.confirm("${msg.M0021}", function () {
				store.doFileUpload(function() {
					store.setGrid([grid]);
					store.getGridData(grid, 'sel');
					store.load(baseUrl + '/cbdi0037_doSave.so', function () {
						
						var buyerCd = this.getParameter('BUYER_CD');
						var bidNum  = this.getParameter('BID_NUM');
						var bidCnt  = this.getParameter('BID_CNT');
						var voteCnt = this.getParameter("VOTE_CNT");
						var param = {
	        					'BUYER_CD'     : buyerCd,
	        					'BID_NUM'      : bidNum,
	        					'BID_CNT'      : bidCnt,
	        					'VOTE_CNT'     : voteCnt,
	        	                'popupFlag'    : true,
	        	                'detailView'   : false
	        	            };
						
						EVF.alert(this.getResponseMessage(), function () {
							location.href = baseUrl + 'CBDI0037/view.so?' + $.param(param);
						});
					});
				});
			});
		}
        
        // 기술평가 첨부파일
        function setFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'TECH_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'TECH_ATT_FILE_NUM', fileId);
        }
        
     	// 기술협상 첨부파일
        function setNegoFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'NEGO_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'NEGO_ATT_FILE_NUM', fileId);
        }
        
     	// 추가 첨부파일
        function setEtcFileAttach(rowIdx, fileId, fileCnt) {
        	grid.setCellValue(rowIdx, 'ETC_ATT_FILE_CNT', fileCnt);
            grid.setCellValue(rowIdx, 'ETC_ATT_FILE_NUM', fileId);
        }
		
        // 기술평가 비고
        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "TECH_RMK", data.message);
            grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
        }
        
        // 기술협상 비고
        function setNEGORMK(data) {
            grid.setCellValue(data.rowIdx, "NEGO_RMK", data.message);
            grid.setColIconify("NEGO_RMK", "NEGO_RMK", "comment", false);
        }
        
        // 추가 비고
        function setETCRMK(data) {
            grid.setCellValue(data.rowIdx, "ETC_RMK", data.message);
            grid.setColIconify("ETC_RMK", "ETC_RMK", "comment", false);
        }

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="CBDI0037" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${formData.PR_BUYER_CD}" />
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
        <e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
        <e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
        <e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />

        <e:buttonBar id="buttonBar" align="right" width="100%" title="입찰공고 정보">
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </e:buttonBar>

		<e:searchPanel id="form" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:text> ${formData.ANN_NO } </e:text>
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}"/>
				<e:field>
					<e:text> ${formData.ANN_DATE } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.ANN_ITEM } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CONT_TYPE_TXT" title="${form_CONT_TYPE_TXT_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.CONT_TYPE_TXT } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_USER_NM" title="${form_BID_USER_NM_N}"/>
				<e:field colSpan="3">
					<e:text> ${formData.BID_USER_NM } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>
		
		<e:buttonBar id="buttonBar1" title="종합낙찰제 결과" align="right" width="100%">
			<e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
		</e:buttonBar>
		
		<c:if test="${formData.CONT_TYPE2 eq 'NE'}">
			<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
				<e:row>
					<e:label colSpan="3" for="NEGO_START_DATE" title="${form_NEGO_START_DATE_N}"/>
					<e:field>
						<e:inputDate id="NEGO_START_DATE" name="NEGO_START_DATE" toDate="NEGO_END_DATE" value="${formData.NEGO_START_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_NEGO_START_DATE_R}" disabled="${form_NEGO_START_DATE_D}" readOnly="${form_NEGO_START_DATE_RO}" />
						<e:text> ~ </e:text>
						<e:inputDate id="NEGO_END_DATE" name="NEGO_END_DATE" fromDate="NEGO_START_DATE" value="${formData.NEGO_END_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_NEGO_END_DATE_R}" disabled="${form_NEGO_END_DATE_D}" readOnly="${form_NEGO_END_DATE_RO}" />
					</e:field>
				</e:row>
			</e:searchPanel>
		</c:if>
		
        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>

