<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

    	var baseUrl = "/eversrm/manager/org/";
    	var grid = {};
    	var saveCd;

		function init() {
			grid = EVF.C('grid');

            grid.setProperty('shrinkToFit', ${shrinkToFit});		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);		            // [선택] 컬럼의 사용여부를 지정한다. [true/false]

			grid.cellClickEvent(function(rowid, celname, value, iRow, iCol) {
				if(celname == "BUYER_CD") {
					setFormData(rowid);
	            }
			});

            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

			doSearch();
        }

        function doSearch() {

        	var store = new EVF.Store();
        	store.setGrid([grid]);
            store.load(baseUrl + 'companyUnit/selectCompany.so', function() {
                if(grid.getRowCount() == 0){
                	EVF.alert("${msg.M0002 }");
                } else {
                	if (saveCd != null) {
                		var rowIds = grid.jsonToArray(grid.getAllRowId()).value;
                		for (var i = 0, length = rowIds.length; i < length; i++) {
	                        if (grid.getCellValue(rowIds[i], "BUYER_CD") == saveCd) {
	                            setFormData(rowIds[i]);
	                            return;
	                        }
	                    }
	                }
                	setFormData(0);
                }
            });
        }

        function doSave() {

	        var store = new EVF.Store();
	        if(!store.validate()) return;

				EVF.confirm("${msg.M0021 }", function() {
                    saveCd = EVF.V('buyerCd');
                    var store = new EVF.Store();
                    if(!store.validate()) return;

                    store.load(baseUrl + 'companyUnit/saveCompany.so', function(){
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });
        }

		function doDelete() {

			//if (formUtil.validHandler(['form'], "${msg.M0054 }")) {

				EVF.confirm("${msg.M0013 }", function() {
                    saveCd = null;
                    var store = new EVF.Store();
                    store.load(baseUrl + 'companyUnit/deleteCompany.so', function(){
                        EVF.alert(this.getResponseMessage());
                        doSearch();
                    });
                });

	        //}
	    }

        function clearForm() {
	        EVF.confirm("${msg.M0029}", function() {
                EVF.V('gateCd', "");
                EVF.V('buyerCd', "");
                EVF.V('langCd', "");
                EVF.V('buyerNm', "");
                EVF.V('buyerNmEng', "");
                EVF.V('countryCd', "");
                EVF.V('cityNm', "");
                EVF.V('zipCd', "");
                EVF.V('irsNum', "");
                EVF.V('address', "");
                EVF.V('addressEng', "");
                EVF.V('telNum', "");
                EVF.V('faxNum', "");
                EVF.V('ceoUserNm', "");
                EVF.V('ceoUserNmEng', "");
                EVF.V('businessType', "");
                EVF.V('industryType', "");
                EVF.V('foundationDate', "");
                EVF.V('cur', "");
                EVF.V('companyRegNum', "");
                EVF.V('dunsNum', "");
                EVF.V('gmtCd', "");
                EVF.V('regDate', "");
                EVF.V('regUserId', "");
                EVF.V('gateCdOri', "");
                EVF.V('buyerCdOri', "");
                EVF.V('GATE_CD_ORI', "");
                EVF.V('BUYER_CD_ORI', "");
                EVF.V('ACCOUNT_UNIT_CD', "");
                EVF.V('ZIP_CD_5', "");
                EVF.V('USE_FLAG', true);
                EVF.V('GW_USE_FLAG', false);
            });
        }
        function setFormData(rowid) {
 			EVF.V('gateCd', grid.getCellValue(rowid, "GATE_CD"));
			EVF.V('buyerCd', grid.getCellValue(rowid, "BUYER_CD"));
			EVF.V('langCd', grid.getCellValue(rowid, "LANG_CD"));
			EVF.V('buyerNm', grid.getCellValue(rowid, "BUYER_NM"));
			EVF.V('buyerNmEng', grid.getCellValue(rowid, "BUYER_NM_ENG"));
			EVF.V('countryCd', grid.getCellValue(rowid, "COUNTRY_CD"));
			EVF.V('cityNm', grid.getCellValue(rowid, "CITY_NM"));
			EVF.V('zipCd', grid.getCellValue(rowid, "ZIP_CD"));
			EVF.V('irsNum', grid.getCellValue(rowid, "IRS_NUM"));
			EVF.V('address', grid.getCellValue(rowid, "ADDR"));
			EVF.V('addressEng', grid.getCellValue(rowid, "ADDR_ENG"));
			EVF.V('telNum', grid.getCellValue(rowid, "TEL_NUM"));
			EVF.V('faxNum', grid.getCellValue(rowid, "FAX_NUM"));
			EVF.V('ceoUserNm', grid.getCellValue(rowid, "CEO_USER_NM"));
			EVF.V('ceoUserNmEng', grid.getCellValue(rowid, "CEO_USER_NM_ENG"));
			EVF.V('businessType', grid.getCellValue(rowid, "BUSINESS_TYPE"));
			EVF.V('industryType', grid.getCellValue(rowid, "INDUSTRY_TYPE"));
			EVF.V('foundationDate', grid.getCellValue(rowid, "FOUNDATION_DATE"));
			EVF.V('cur', grid.getCellValue(rowid, "CUR"));
			EVF.V('companyRegNum', grid.getCellValue(rowid, "COMPANY_REG_NUM"));
			EVF.V('dunsNum', grid.getCellValue(rowid, "DUNS_NUM"));
			EVF.V('gmtCd', grid.getCellValue(rowid, "GMT_CD"));
			EVF.V('regDate', grid.getCellValue(rowid, "REG_DATE"));
			EVF.V('regUserId', grid.getCellValue(rowid, "REG_USER_NM"));
			EVF.V('gateCdOri', grid.getCellValue(rowid, "GATE_CD"));
			EVF.V('buyerCdOri', grid.getCellValue(rowid, "BUYER_CD_ORI"));
			EVF.V('GATE_CD_ORI', grid.getCellValue(rowid, "GATE_CD_ORI"));
			EVF.V('BUYER_CD_ORI', grid.getCellValue(rowid, "BUYER_CD_ORI"));
			EVF.V('ACCOUNT_UNIT_CD', grid.getCellValue(rowid, "ACCOUNT_UNIT_CD"));
			EVF.V('ZIP_CD_5', grid.getCellValue(rowid, "ZIP_CD_5"));
			if (grid.getCellValue(rowid, "USE_FLAG") == 'Y') {
				EVF.C('USE_FLAG').setChecked(true);
			} else {
				EVF.C('USE_FLAG').setChecked(false);
			}
			if (grid.getCellValue(rowid, "GW_USE_FLAG") == '1') {
				EVF.C('GW_USE_FLAG').setChecked(true);
			} else {
				EVF.C('GW_USE_FLAG').setChecked(false);
			}
		}

		function searchZipCode() {

        	var url = '/eversrm/manager/system/MSYB0020/view.so';
        	var param = {
            	callBackFunction: "setZipCode",
                modalYn: false
        	};
            everPopup.openWindowPopup(url, 700, 600, param, 'searchZip');
        }
        function setZipCode(data) {
        	EVF.V("zipCd", data.ZIP_CD);
			EVF.V("ZIP_CD_5", data.ZIP_CD_5);
        	EVF.V("address", data.ADDR);
        }

    </script>
    <e:window id="MOGA0020" onReady="init" initData="${initData}" title="${fullScreenName}" icon="icon-blue-document-table" breadCrumbs="${breadCrumb }">
    	<e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" icon="search" label="${Search_N }" disabled="${Search_D }" onClick="doSearch" />
            <e:button id="Save" name="Save"  label="${Save_N }" disabled="${Save_D }" onClick="doSave" />
            <e:button id="Delete" name="Delete" icon="delete-row" label="${Delete_N }" disabled="${Delete_D }" onClick="doDelete" />
            <e:button id="Clear" name="Clear" icon="add-row" label="${Clear_N }" disabled="${Clear_D }" onClick="clearForm" />
        </e:buttonBar>

    	<e:panel id="leftPanel" height="fit" width="35%">
    		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="98%" height="fit" readOnly="${param.detailView}"/>
    	</e:panel>

    	<e:panel id="rightPanel" height="fit" width="65%">
		<e:searchPanel id="form" title="${form_caption_form_N}" useTitleBar="false" labelWidth="${labelWidth}" width="100%" columnCount="2">
	        <e:row>
                <e:label for="gateCd" title="${form_gateCd_N}"></e:label>
                <e:field colSpan="3">
 					<e:select id="gateCd" width="100%" name="gateCd" options="${gatecdOptions}" required="${form_gateCd_R }" disabled="${form_gateCd_D }" readOnly="${form_gateCd_RO }" value="${st_default}"></e:select>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="buyerCd" title="${form_buyerCd_N}"></e:label>
                <e:field>
					<e:inputText id="buyerCd" style='ime-mode:inactive' name="buyerCd" width="100%" maxLength="${form_buyerCd_M }" required="${form_buyerCd_R }" readOnly="${form_buyerCd_RO }" disabled="${form_buyerCd_D}" visible="${form_buyerCd_V}" ></e:inputText>
                </e:field>
                <e:label for="langCd" title="${form_langCd_N}"></e:label>
                <e:field>
 					<e:select id="langCd" name="langCd" width="100%" options="${languageCdList}" required="${form_langCd_R }" disabled="${form_langCd_D }" readOnly="${form_langCd_RO }" value="${st_default}"></e:select>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="buyerNm" title="${form_buyerNm_N}"></e:label>
                <e:field>
					<e:inputText id="buyerNm" name="buyerNm" style="${imeMode}" width="100%" maxLength="${form_buyerNm_M }" required="${form_buyerNm_R }" readOnly="${form_buyerNm_RO }" disabled="${form_buyerNm_D}" visible="${form_buyerNm_V}" ></e:inputText>
                </e:field>
                <e:label for="buyerNmEng" title="${form_buyerNmEng_N}"></e:label>
                <e:field>
					<e:inputText id="buyerNmEng" style='ime-mode:inactive' name="buyerNmEng" width="100%" maxLength="${form_buyerNmEng_M }" required="${form_buyerNmEng_R }" readOnly="${form_buyerNmEng_RO }" disabled="${form_buyerNmEng_D}" visible="${form_buyerNmEng_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="countryCd" title="${form_countryCd_N}"></e:label>
                <e:field>
 					<e:select id="countryCd" name="countryCd" width="100%" options="${countryCdList}" required="${form_countryCd_R }" disabled="${form_countryCd_D }" readOnly="${form_countryCd_RO }" value="${st_default}"></e:select>
                </e:field>
                <e:label for="cityNm" title="${form_cityNm_N}"></e:label>
                <e:field>
					<e:inputText id="cityNm" style="${imeMode}" name="cityNm" width="100%" maxLength="${form_cityNm_M }" required="${form_cityNm_R }" readOnly="${form_cityNm_RO }" disabled="${form_cityNm_D}" visible="${form_cityNm_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="zipCd" title="${form_zipCd_N}"></e:label>
                <e:field>
					<e:search id="zipCd" name="zipCd" width="100%" onIconClick="searchZipCode" maxLength="${form_zipCd_M }" required="${form_zipCd_R }" readOnly="${form_zipCd_RO }" disabled="${form_zipCd_D}" visible="${form_zipCd_V}" />
					<e:inputHidden id="ZIP_CD_5" name="ZIP_CD_5" />
                </e:field>
                <e:label for="irsNum" title="${form_irsNum_N}"></e:label>
                <e:field>
					<e:inputText id="irsNum" name="irsNum" width="100%" maxLength="${form_irsNum_M }" required="${form_irsNum_R }" readOnly="${form_irsNum_RO }" disabled="${form_irsNum_D}" visible="${form_irsNum_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="address" title="${form_address_N}"></e:label>
                <e:field>
					<e:inputText id="address" style="${imeMode}" name="address" width="100%" maxLength="${form_address_M }" required="${form_address_R }" readOnly="${form_address_RO }" disabled="${form_address_D}" visible="${form_address_V}" ></e:inputText>
                </e:field>
                <e:label for="addressEng" title="${form_addressEng_N}"></e:label>
                <e:field>
					<e:inputText id="addressEng" style='ime-mode:inactive' name="addressEng" width="100%" maxLength="${form_addressEng_M }" required="${form_addressEng_R }" readOnly="${form_addressEng_RO }" disabled="${form_addressEng_D}" visible="${form_addressEng_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="telNum" title="${form_telNum_N}"></e:label>
                <e:field>
					<e:inputText id="telNum" name="telNum" width="100%" maxLength="${form_telNum_M }" required="${form_telNum_R }" readOnly="${form_telNum_RO }" disabled="${form_telNum_D}" visible="${form_telNum_V}" ></e:inputText>
                </e:field>
                <e:label for="faxNum" title="${form_faxNum_N}"></e:label>
                <e:field>
					<e:inputText id="faxNum" name="faxNum" width="100%" maxLength="${form_faxNum_M }" required="${form_faxNum_R }" readOnly="${form_faxNum_RO }" disabled="${form_faxNum_D}" visible="${form_faxNum_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="ceoUserNm" title="${form_ceoUserNm_N}"></e:label>
                <e:field>
					<e:inputText id="ceoUserNm" style="${imeMode}" name="ceoUserNm" width="100%" maxLength="${form_ceoUserNm_M }" required="${form_ceoUserNm_R }" readOnly="${form_ceoUserNm_RO }" disabled="${form_ceoUserNm_D}" visible="${form_ceoUserNm_V}" ></e:inputText>
                </e:field>
                <e:label for="ceoUserNmEng" title="${form_ceoUserNmEng_N}"></e:label>
                <e:field>
					<e:inputText id="ceoUserNmEng" style='ime-mode:inactive' name="ceoUserNmEng" width="100%" maxLength="${form_ceoUserNmEng_M }" required="${form_ceoUserNmEng_R }" readOnly="${form_ceoUserNmEng_RO }" disabled="${form_ceoUserNmEng_D}" visible="${form_ceoUserNmEng_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="businessType" title="${form_businessType_N}"></e:label>
                <e:field>
					<e:inputText id="businessType" style="${imeMode}" name="businessType" width="100%" maxLength="${form_businessType_M }" required="${form_businessType_R }" readOnly="${form_businessType_RO }" disabled="${form_businessType_D}" visible="${form_businessType_V}" ></e:inputText>
                </e:field>
                <e:label for="industryType" title="${form_industryType_N}"></e:label>
                <e:field>
					<e:inputText id="industryType" style="${imeMode}"  name="industryType" width="100%" maxLength="${form_industryType_M }" required="${form_industryType_R }" readOnly="${form_industryType_RO }" disabled="${form_industryType_D}" visible="${form_industryType_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="foundationDate" title="${form_foundationDate_N}"/>
                <e:field>
                    <e:inputDate id="foundationDate" name="foundationDate" value="${form.foundationDate}" width="${inputDateWidth}" datePicker="true" required="${form_foundationDate_R}" disabled="${form_foundationDate_D}" readOnly="${form_foundationDate_RO}" />
                </e:field>
                <e:label for="cur" title="${form_cur_N}"></e:label>
                <e:field>
 					<e:select id="cur" name="cur" width="100%" options="${curOptions}" required="${form_cur_R }" disabled="${form_cur_D }" readOnly="${form_cur_RO }" value="${st_default}" ></e:select>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="companyRegNum" title="${form_companyRegNum_N}"></e:label>
                <e:field>
					<e:inputText id="companyRegNum" name="companyRegNum" width="100%" maxLength="${form_companyRegNum_M }" required="${form_companyRegNum_R }" readOnly="${form_companyRegNum_RO }" disabled="${form_companyRegNum_D}" visible="${form_companyRegNum_V}" ></e:inputText>
                </e:field>
                <e:label for="dunsNum" title="${form_dunsNum_N}"></e:label>
                <e:field>
					<e:inputText id="dunsNum" name="dunsNum" width="100%" maxLength="${form_dunsNum_M }" required="${form_dunsNum_R }" readOnly="${form_dunsNum_RO }" disabled="${form_dunsNum_D}" visible="${form_dunsNum_V}" ></e:inputText>
                </e:field>
	        </e:row>
	        <e:row>
                <e:label for="gmtCd" title="${form_gmtCd_N}"></e:label>
                <e:field>
 					<e:select id="gmtCd" name="gmtCd" width="100%" options="${gmtCdList}" required="${form_gmtCd_R }" disabled="${form_gmtCd_D }" readOnly="${form_gmtCd_RO }" value="${st_default}" ></e:select>
                </e:field>
				<e:label for="GW_USE_FLAG" title="${form_GW_USE_FLAG_N}"/>
				<e:field>
                    <e:check id='GW_USE_FLAG' name="GW_USE_FLAG" value="1" checked="${form.GW_USE_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_GW_USE_FLAG_R }' disabled='${form_GW_USE_FLAG_D }' visible='${form_GW_USE_FLAG_V }' />
				</e:field>
	        </e:row>
	        <e:row>
				<e:label for="USE_FLAG" title="${form_USE_FLAG_N}"/>
				<e:field colSpan="3">
                    <e:check id='USE_FLAG' name="USE_FLAG" value="1" checked="${form.USE_FLAG eq '1' ? 'true' : 'false'}" width='${inputTextWidth }' required='${form_USE_FLAG_R }' disabled='${form_USE_FLAG_D }' visible='${form_USE_FLAG_V }' />
				</e:field>
	        </e:row>
	        <e:row>
                <e:label for="regDate" title="${form_regDate_N}"></e:label>
                <e:field>
					<e:inputText id="regDate" name="regDate" width="${inputTextWidth }" maxLength="${form_regDate_M }" required="${form_regDate_R }" readOnly="${form_regDate_RO }" disabled="${form_regDate_D}" visible="${form_regDate_V}" ></e:inputText>
                </e:field>
                <e:label for="regUserId" title="${form_regUserId_N}"></e:label>
                <e:field>
					<e:inputText id="regUserId" name="regUserId" width="${inputTextWidth }" maxLength="${form_regUserId_M }" required="${form_regUserId_R }" readOnly="${form_regUserId_RO }" disabled="${form_regUserId_D}" visible="${form_regUserId_V}" ></e:inputText>
					<e:inputHidden id="gateCdOri" name="gateCdOri"/>
					<e:inputHidden id="buyerCdOri" name="buyerCdOri"/>
					<e:inputHidden id="GATE_CD_ORI"   name="GATE_CD_ORI"/>
					<e:inputHidden id="BUYER_CD_ORI"   name="BUYER_CD_ORI"/>
					<e:inputHidden id="ACCOUNT_UNIT_CD"   name="ACCOUNT_UNIT_CD"/>
                </e:field>
	        </e:row>
		</e:searchPanel>
	    </e:panel>

    </e:window>
</e:ui>