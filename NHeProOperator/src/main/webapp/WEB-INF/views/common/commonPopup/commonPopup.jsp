<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid = {};
		var baseUrl = '/common/popup/commonPopup/';

		function init() {

			grid = EVF.C("${searchCondition.commonId }");
			var id = grid.getColId(0);

			grid.setProperty('panelVisible', false);
			grid.setColFontColor(id, "#0000FF");
			grid.setColFontUnderline(id, true);
			grid.setColCursor(id, 'pointer');

			if ('${autoSearchFlag}' === '1') {
				doSearch();
			}
			if ('${typeCode}' != 'SP') {
				EVF.C('Choose').setVisible(true);
			}
			if ('${typeCode}' == 'SP') {
				grid.showCheckBar(true);
				EVF.C('Choose').setVisible(false);
			}

			grid.cellClickEvent(function(rowIdx, colIdx, value, iRow, iCol) {

				var rowData = '', selectedData = {};

				if (colIdx == 'multiSelect') { return; }

				//rowData = grid.getColType(grid.getColIndex(celname));
				//if(rowData == "imagetext") {
				if(colIdx == id) {

					if ('${typeCode}' != 'SP') {
						grid.checkRow( rowIdx, true );
					} else {
						<!-- var rowIds = grid.jsonToArray(rowIdx).value; -->
						<!-- var selectedData = grid.getRowValue(rowIds[0]); -->

						selectedData = grid.getRowValue(rowIdx);
						for(var key in selectedData) {
							if('${ses.superUserFlag}' != '1') {
								if (key.indexOf('_$TP') > 0) {
									var decId = key.substr(0, key.indexOf('_$TP'));
									if(selectedData[key] != null && selectedData[key] != "") {
										selectedData[decId] = selectedData[key];
									}
									delete selectedData[key];
								}
							}
							if(key.indexOf('_HIDDEN') > 0) {
								var decId = key.substr(0, key.indexOf('_HIDDEN'));
								if(selectedData[key] != null && selectedData[key] != "") {
									selectedData[decId] = selectedData[key];
								}
								delete selectedData[key];
							}
						}

						if('${param.rowIdx}' != '') {
							selectedData.rowIdx = Number('${param.rowIdx}');
							selectedData.rowIdx = Number('${param.rowIdx}');
						} else if('${param.rowIdx}' != ''){
							selectedData.rowIdx = Number('${param.rowIdx}');
							selectedData.rowIdx = Number('${param.rowIdx}');
						}

						parent['${param.callBackFunction}'](selectedData);
						doClose();
					}
				}
			});

			grid.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			$('select').val("${st_default }");

			grid.setProperty('shrinkToFit', true);
			// realGrid일 경우 multiselect 여부를 지정하지 않을 경우 default 값은 multiselect 이다.
			if('${typeCode}' == 'SP') {
				grid.setProperty('multiselect', false);
			} else {
				grid.setProperty('multiselect', true);
			}

//			var startX = 0;
//			var startY = 0;
//			var startIframeX = 0;
//			var startIframeY = 0;
//            $('.e-window-container-header-wrapper').mousedown(function(e) {
//                startX = e.screenX;
//                startY = e.screenY;
//                var modalPopup = $('iframe.e-modalwindow', parent.document);
//                startIframeX = Number(modalPopup.css('left').replace('px', ''));
//                startIframeY = Number(modalPopup.css('top').replace('px', ''));
//			}).mousemove(function(e) {
//                if(e.which == 1 || e.buttons == 1) {
//                    var modalPopup = $('iframe.e-modalwindow', parent.document);
//                    modalPopup.css('left', startIframeX+(e.screenX-startX));
//                    modalPopup.css('top', startIframeY+(e.screenY-startY));
//				}
//			}).mouseleave(function(e) {
//                $(this).css('cursor', 'default');
//            }).mouseover(function(e) {
//                $(this).css('cursor', 'move');
//            }).css({userSelect:'none'});
		}

		function doInit() {

			var resetData = {};
			resetData.rowIdx = '${param.rowIdx}';
			if (resetData.rowIdx == '') resetData.rowIdx = '${param.rowIdx}';
			resetData.rowIdx = '${param.rowIdx}';
			if (resetData.rowIdx == '') resetData.rowIdx = '${param.rowIdx}';

			var colCount = grid.getColId().length;
			for(var i = 0; i < colCount; i++ ) {
				var colId = grid.getColId(i);
				var colType = grid.getColType(i);
				switch(colType) {
					case 'imagetext':
						resetData[colId] = {"text": "", value: ""};
						break;
					case 'text':
						resetData[colId] = "";
						break;
					default:
						resetData[colId] = "";
				}
			}
			parent['${param.callBackFunction}'](resetData);
			doClose();
		}

		function doSearch() {

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.setParameter('parameters', "${parameters }");
			store.load(baseUrl + 'doSearch.so', function() {
				if(grid.getRowCount() == 0){
					EVF.alert("${msg.M0002 }");
				}
			});
		}

		function doChoose() {

            var selectedData = grid.getSelRowValue();
            if( grid.isEmpty( selectedData) ) { return ; }

			parent['${param.callBackFunction}'](selectedData, '${param.rowIdx}');
			doClose();
		}

		function doClose() {
			EVF.closeWindow();
		}

	</script>

	<e:window id="commonPopup" onReady="init" initData="${initData}" title="${empty param.title ? commonDesc : param.title} ${isDev ? param.COMMON_ID : ''}" margin="1px 5px">
		<c:forEach items="${searchConditionList}" var="searchCondition" varStatus="status">
			<c:set var="totalCount" value="${status.count}"/>
		</c:forEach>

		<e:searchPanel id="form" columnCount="${totalCount}" labelWidth="120" useTitleBar="false">
			<e:row>
				<c:forEach items="${searchConditionList}" var="searchCondition" varStatus="status">
					<e:label for="st_${searchCondition.id}" title="${searchCondition.label}" />
					<c:choose>
						<c:when test="${totalCount % 2 == 1 and status.last}">
							<e:field>
								<e:select id="st_${searchCondition.id}" name="st_${searchCondition.id}" disabled="" readOnly="" required="" options="${searchTerms }" value="${st_default }" width="${everMultiWidth }" visible="${everMultiVisible }" />
								<e:inputText  id="${searchCondition.id}" style="ime-mode:inactive" disabled="" readOnly="" required="" maxLength="1000" name="${searchCondition.id}" width="100%" value="" onEnter="doSearch" />
							</e:field>
						</c:when>
						<c:otherwise>
							<e:field>
								<e:select id="st_${searchCondition.id}" name="st_${searchCondition.id}" disabled="" readOnly="" required="" options="${searchTerms }" value="${st_default }" width="${everMultiWidth }" visible="${everMultiVisible }" />
								<e:inputText id="${searchCondition.id}" disabled="" readOnly="" required="" maxLength="1000" name="${searchCondition.id}" width="100%" value="" style="${imeMode}" onEnter="doSearch" />
							</e:field>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<e:inputHidden id="commonId" name="commonId" value="${searchCondition.commonId }"/>
			</e:row>
		</e:searchPanel>
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="Choose" name="Choose" label="${Choose_N }" disabled="${Choose_D }" onClick="doChoose" visible="${Choose_V }" />

			<e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
			<e:button id="Init" name="Init" label="${Init_N }" disabled="${Init_D }" onClick="doInit" />
			<%--<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />--%>
		</e:buttonBar>

		<e:gridPanel gridType="${_gridType}" id="${searchCondition.commonId }" name="${searchCondition.commonId }" width="100%" height="fit" readOnly="${param.detailView}"/>
	</e:window>
</e:ui>