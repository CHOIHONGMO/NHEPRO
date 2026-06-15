<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import = "blowfishj.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "java.util.*"%>

<%
    SimpleDateFormat encdDateFormat = new SimpleDateFormat("ddHHmmss");
    Calendar encdCalendar = Calendar.getInstance();
    String encdtoday  =  "";     //fKey구성에쓰일 시간값
    encdtoday =  encdDateFormat.format(encdCalendar.getTime());

    String KEY = "oZQUq352vk";

    BlowfishEasy bfes = new BlowfishEasy(KEY.toCharArray());
    String finalkey = bfes.encryptString(encdtoday);
%>

<c:set value="<%=finalkey%>" var="finalkey"/>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var grid;
        var baseUrl = "/nhepro/CVNR/";

        function init() {
            grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", ${shrinkToFit});
            grid.setProperty("rowNumbers", ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", false);					// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

            grid.cellClickEvent(function(rowIdx, colIdx, value) {
                var param;

                if(colIdx == "VENDOR_CD") {
                    param = {
                        VENDOR_CD: value,
                        detailView: true,
                        popupFlag: true,
                        buttonView: true
                    };
                    everPopup.openPopupByScreenId("CVNR0011", 1000, 730, param);
                } else if(colIdx == "NICE_DB_GRD") {
                    encrypt(grid.getCellValue(rowIdx, "IRS_NO"));
                } else if(colIdx == "KED_GRD") {
                    openKED_GRD(grid.getCellValue(rowIdx, "IRS_NO"), grid.getCellValue(rowIdx, "COMPANY_REG_NO"));
                }
            });

            grid.excelExportEvent({
                allItems: "${excelExport.allCol}",
                fileName: "${screenName }"
            });

            EVF.V("PROGRESS_CD", "J");
        }


        function onIconClickVENDOR_CD() {
            var param = {
                callBackFunction: "callBackVENDOR_CD"
            };
            everPopup.openCommonPopup(param, "SP0123");
        }

        function callBackVENDOR_CD(data) {
            EVF.V("VENDOR_CD", data.VENDOR_CD);
            EVF.V("VENDOR_NM", data.VENDOR_NM);
        }

        function onIconClickBUYER_CD() {
            var param = {
                callBackFunction: "callBackBUYER_CD"
            };
            everPopup.openCommonPopup(param, "SP0066");
        }

        function callBackBUYER_CD(data) {
            EVF.V("BUYER_CD", data.CUST_CD);
            EVF.V("BUYER_NM", data.CUST_NM);
        }

        function doSearch() {
            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.setGrid([grid]);
            store.load(baseUrl + "cvnr0010_doSearch.so", function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    var allRowId = grid.getAllRowId();

                    for(var i in allRowId) {
                        var rowId = allRowId[i];

                        if(grid.getCellValue(rowId, "KED_GRD") == "") {
                            grid.setCellValue(rowId, "KED_GRD", "link");
                        }

                        if(grid.getCellValue(rowId, "NICE_DB_GRD") == "") {
                            grid.setCellValue(rowId, "NICE_DB_GRD", "link");
                        }
                    }
                }
            });
        }
    </script>

    <script type="text/javascript" src="/js/nicednb/aes.js"></script>
    <script type="text/javascript" src="/js/nicednb/pbkdf2.js"></script>
    <script type="text/javascript" src="/js/nicednb/AesUtil.js"></script>
    <script type="text/javascript">
        <!--
        eval(function(p, a, c, k, e, r) { e = function(c) { return c.toString(a) }; if (!''.replace(/^/, String)) { while (c--) r[e(c)] = k[c] || e(c); k = [ function(e) { return r[e] } ]; e = function() { return '\\w+' }; c = 1 } ; while (c--) if (k[c]) p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c]); return p } ( '0 2="5";0 1=3 4(c,6);7 8(a){b 1.9(2,a)}', 13, 13, 'var|aesUtil|authKey|new|AesUtil|5a304d3461464d36496b30784b6d31314b336b6a51773d3d|100|function|niceEncrypt|encrypt||return|128' .split('|'), 0, {}))
        function encrypt(s) {
            var clp_cd = "514"; //document.getElementById("clp_cd").value; // 업체코드
             //document.getElementById("bz_ins_no").value; // 사업자번호
            var e_bz_ins_no = niceEncrypt(s); // 암호화 사업자번호
            window.open("http://xlink.nicednb.com/weblink/toServer.do?clp_cd="+ clp_cd +"&bz_ins_no=" + e_bz_ins_no, "niceLink", "width=1018,height=700,scrollbars=yes,resizeable=yes,left=0,top=0");
        }

        function openKED_GRD(BZNO, COMPANY_NO) {
            var finalkey = "${finalkey}";

            window.open("http://www.k-srm.co.kr/refbfautologin.do?acctp=J1&isSSL=&ID=NHINFO&siteKey=" + finalkey + "=&BZNO=" + BZNO + "&COMPANY_NO=" + COMPANY_NO + "", "go_ksrm", "width=900,height=600,scrollbars=auto,resizeable=yes,left=0,top=0");
        }
        //-->
    </script>

    <e:window id="CVNR0010" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="sp" title="${form_CAPTION_N}" labelWidth="${labelWidth}" useTitleBar="false" width="100%" columnCount="3" onEnter="doSearch">
            <e:row>
                <e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}" />
                <e:field>
                    <e:inputText id="VENDOR_NM" name="VENDOR_NM" value="" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" style="${imeMode}" maskType="${form_VENDOR_NM_MT}"/>
                </e:field>
                <e:label for="REG_TYPE" title="${form_REG_TYPE_N}"/>
                <e:field>
                    <e:select id="REG_TYPE" name="REG_TYPE" value="" options="${regTypeOptions}" width="${form_REG_TYPE_W}" disabled="${form_REG_TYPE_D}" readOnly="${form_REG_TYPE_RO}" required="${form_REG_TYPE_R}" placeHolder="" maskType="${form_REG_TYPE_MT}" />
                </e:field>
                <e:label for="REG_FROM_DATE" title="${form_REG_FROM_DATE_N}"/>
                <e:field>
                    <e:inputDate id="REG_FROM_DATE" name="REG_FROM_DATE" toDate="REG_TO_DATE" value="${regFromDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_FROM_DATE_R}" disabled="${form_REG_FROM_DATE_D}" readOnly="${form_REG_FROM_DATE_RO}" />
                    <e:text>&nbsp;~&nbsp;</e:text>
                    <e:inputDate id="REG_TO_DATE" name="REG_TO_DATE" fromDate="REG_FROM_DATE" value="${regToDate}" width="${inputDateWidth}" datePicker="true" required="${form_REG_TO_DATE_R}" disabled="${form_REG_TO_DATE_D}" readOnly="${form_REG_TO_DATE_RO}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
                <e:field>
                    <e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" style="${imeMode}" maskType="${form_CEO_USER_NM_MT}"/>
                </e:field>
                <e:label for="IRS_NO" title="${form_IRS_NO_N}" />
                <e:field>
                    <e:inputText id="IRS_NO" name="IRS_NO" value="" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" style="${imeMode}" maskType="${form_IRS_NO_MT}"/>
                </e:field>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field>
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar width="100%" align="right">
            <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
        </e:buttonBar>

        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
    </e:window>
</e:ui>
