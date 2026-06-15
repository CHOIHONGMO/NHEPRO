<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

<c:if test="${sslFlag == false}">
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
</c:if>

<c:if test="${sslFlag == true}">
	<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
</c:if>

    <script>

    	var gridStreet = {};
    	var gridDistrict = {};
    	var baseUrl = "/eversrm/manager/system/";
    	var langCode = "${langCd }";

    	var streetTap = true;
    	var districtTap = false;

		function init() {

            var checkFlag = true;

            if(${useDaumApi}) {
                var element = document.getElementById('daum_postcode_frame');
                new daum.Postcode({
                    oncomplete: function(data) {
                        var fullAddr = ''; // 최종 주소 변수
                        var extraAddr = ''; // 조합형 주소 변수

                        // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                            fullAddr = data.roadAddress;

                        } else { // 사용자가 지번 주소를 선택했을 경우(J)
                            fullAddr = data.jibunAddress;
                        }

                        // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                        if(data.userSelectedType === 'R'){
                            //법정동명이 있을 경우 추가한다.
                            if(data.bname !== ''){
                                extraAddr += data.bname;
                            }
                            // 건물명이 있을 경우 추가한다.
                            if(data.buildingName !== ''){
                                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                            }
                            // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                            fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                        }

                        var zip_cd6 = data['postcode1']+data['postcode2'];
                        var zip_cd5 = data['zonecode'];

                        var param = {
                            "ZIP_CD": zip_cd6 == "" ? zip_cd5 : zip_cd6,
                            "ADDR": fullAddr,
                            "ZIP_CD_5": data['zonecode'],
                            "rowId": '${param.rowId}'
                        };

                        <%-- 다음API 사용 시 iframe을 사용하므로 parent는 항상 존재하기 때문에
                             parent에 setZipCode 함수가 존재하는 지를 확인해야한다. --%>
                        if (parent['${param.callBackFunction}']) {
                            parent['${param.callBackFunction}'](param);
                            new EVF.ModalWindow().close(null);
                        } else if(opener) {
                            opener['${param.callBackFunction}'](param);
                            doClose();
                        }
                    },
                    onresize : function(size) {
                        $('#__daum__layer_1').css('height', '94%');
                        $('.popup_foot').css('height', '30px !important');
//
//                        if(checkFlag) {
//                            $('#__daum__layer_1').remove();
//                            checkFlag = false;
//                        }
                    },
                    width : '100%',
                    height : '100%'
                }).embed(element);

            } else {
                gridStreet = EVF.C('gridStreet');
                gridDistrict = EVF.C('gridDistrict');
                gridStreet.setProperty('shrinkToFit', true);
                gridDistrict.setProperty('shrinkToFit', true);
                gridStreet.setProperty('multiselect', false);
                gridDistrict.setProperty('multiselect', false);

                gridStreet.cellClickEvent(function (rowid, celname, value, iRow, iCol) {

                    var selectedData = gridStreet.getRowValue(rowid);

                    if ('${param.modalYn}' == 'true') {
                        parent['${param.callBackFunction}'](selectedData);
                        new EVF.ModalWindow().close(null);
                    } else {
                        opener['${param.callBackFunction}'](selectedData);
                        doClose();
                    }
                });
                gridDistrict.cellClickEvent(function (rowid, celname, value, iRow, iCol) {
                    var selectedData = gridDistrict.getRowValue(rowid);
                    if ('${param.modalYn}' == 'true') {
                        parent['${param.callBackFunction}'](selectedData);
                        new EVF.ModalWindow().close(null);
                    } else {
                        opener['${param.callBackFunction}'](selectedData);
                        doClose();
                    }
                });
                gridStreet.excelExportEvent({
                    allItems : "${excelExport.allCol}",
                    fileName : "${screenName }"
                });
                gridDistrict.excelExportEvent({
                    allItems : "${excelExport.allCol}",
                    fileName : "${screenName }"
                });

                <%-- EVF.C("conditionStreet").setOptions([{text:"읍/면/동", value:"1"},{text:"거리명", value:"2"},{text:"빌딩명/상세빌딩명", value:"3"}]); --%>
                EVF.V("conditionStreet", "1");
            }
        }

        function doSearchByStreet() {

			//if (streetTap) {
				if (EVF.V('streetName') == '') {
	                return EVF.alert('${BADV_020_001}' + "${form_captionStreet_N }");
	            }
	        	var store = new EVF.Store();
	        	store.setGrid([gridStreet]);
	            store.load(baseUrl + 'MSYB0020/doSearchByStreet.so', function() {
	                if(gridStreet.getRowCount() == 0){
	                	EVF.alert("${msg.M0002 }");
	                }
	            });
	        //}
        }

		function doSearchByDistrict() {

			//if (districtTap) {
				//if (EVF.V('streetNameByDistrict') == '') {
	            //    EVF.alert('${BADV_020_001}' + "${form_streetName_N }");
				if (EVF.V('districtName') == '') {
	                return EVF.alert('${BADV_020_001}' + "${form_captionDistrist_N }");
	            }
	            EVF.V('streetNameByDistrict', EVF.V('districtName'));

	        	var store = new EVF.Store();
	        	store.setGrid([gridDistrict]);
	            store.load(baseUrl + 'MSYB0020/doSearchByDistrict.so', function() {
	                if(gridDistrict.getRowCount() == 0){
	                	EVF.alert("${msg.M0002 }");
	                }
	            });
	        //}
        }

        $(document.body).ready(function() {
	    	$('#e-tabs').height( ($('.ui-layout-center').height()-30) ).tabs(
    			{
                    activate: function(event, ui) {
                        <%-- 이 부분을 해줘야 탭을 변경했을 때 그리드가 제대로 display 된다. --%>
                        $(window).trigger('resize');
                    }
                }
	    	);
    		$('#e-tabs').tabs('option', 'active', 0);
    		getContentTab('1');
		});

	    function getContentTab(uu) {
			if (uu == '1') {
				window.scrollbars = true;
			}
			if (uu == '2') {
				window.scrollbars = true;
			}
		}

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="MSYB0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

       	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="close" name="close" label="Close" disabled="false" onClick="doClose" />
        </e:buttonBar>

        <c:if test="${not useDaumApi}">
            <div id="e-tabs" class="e-tabs">
                <ul>
                    <li><a href="#ui-tabs-2" onclick="getContentTab('2');">${form_captionDistrist_N }</a></li>
                    <li><a href="#ui-tabs-1" onclick="getContentTab('1');">${form_captionStreet_N }</a></li>
                </ul>
                <div id="ui-tabs-1">
                    <e:searchPanel id="formS" onEnter="doSearchByStreet" title="${form_captionStreet_N}" labelWidth="200" columnCount="1" useTitleBar="false">
                        <e:row>
                            <e:field>
                                <e:select id="conditionStreet" name="conditionStreet" options="${conditionstreetOptions }" placeHolder="${placeHolder }" disabled="${form_conditionStreet_D }" width="100%" required="${form_conditionStreet_R }" readOnly="${form_conditionStreet_RO }"></e:select>
                            </e:field>
                            <e:field>
                                <e:inputText id="streetName" name="streetName" width="100%" maxLength="${form_streetName_M }" required="${form_streetName_R }" readOnly="${form_streetName_RO }" disabled="${form_streetName_D}" visible="${form_streetName_V}" ></e:inputText>
                            </e:field>
                        </e:row>
                    </e:searchPanel>

                    <e:buttonBar id="buttonBarS" align="right" width="100%">
                        <e:button id="SearchByStreet" name="SearchByStreet" label="${SearchByStreet_N }" disabled="${SearchByStreet_D }" onClick="doSearchByStreet" />
                        <e:button id="CloseS" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
                    </e:buttonBar>

                    <e:gridPanel gridType="${_gridType}" id="gridStreet" name="gridStreet" width="100%" height="fit" readOnly="${param.detailView}"/>

                </div>

                <div id="ui-tabs-2">
                    <e:searchPanel id="formD" onEnter="doSearchByDistrict" title="${form_captionDistrist_N}" labelWidth="200" columnCount="1" useTitleBar="false">
                        <e:row>
                            <e:label for="districtName" title="${form_districtName_N}"></e:label>
                            <e:field>
                                <e:inputText id="districtName" name="districtName" width="100%" maxLength="${form_districtName_M }" required="${form_districtName_R }" readOnly="${form_districtName_RO }" disabled="${form_districtName_D}" visible="${form_districtName_V}" ></e:inputText>
                                <e:inputHidden id="streetNameByDistrict" name="streetNameByDistrict"></e:inputHidden>
                            </e:field>
                        </e:row>
                    </e:searchPanel>

                    <e:buttonBar id="buttonBarD" align="right" width="100%">
                        <e:button id="SearchByDistrict" name="SearchByDistrict" label="${SearchByDistrict_N }" disabled="${SearchByDistrict_D }" onClick="doSearchByDistrict" />
                        <e:button id="CloseD" name="Close" label="${Close_N }" disabled="${Close_D }" onClick="doClose" />
                    </e:buttonBar>

                    <e:gridPanel gridType="${_gridType}" id="gridDistrict" name="gridDistrict" width="100%" height="fit" readOnly="${param.detailView}"/>

                </div>
            </div>
        </c:if>
        <c:if test="useDaumApi">
            <iframe id="daum_postcode_frame" style="display: block;" height="90%"></iframe>
        </c:if>
    </e:window>
</e:ui>