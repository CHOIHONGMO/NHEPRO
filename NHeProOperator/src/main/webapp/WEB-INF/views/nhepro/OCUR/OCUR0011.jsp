<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var baseUrl = "/nhepro/OCUR/";
		var gridTS;

        function init() {

			gridTS = EVF.C("gridTS");

			gridTS.cellClickEvent(function(rowIdx, colIdx, value) {
				if(colIdx == "ATT_FILE_CNT") {
					var param = {
						attFileNum: gridTS.getCellValue(rowIdx, 'ATT_FILE_NUM'),
						rowIdx: rowIdx,
						callBackFunction: 'setFileAttach',
						bizType: 'OCUR',
						detailView : false
					};
					everPopup.fileAttachPopup(param);
				}
			});

			gridTS.excelExportEvent({
				allItems : "${excelExport.allCol}",
				fileName : "${screenName }"
			});

			gridTS.setProperty('shrinkToFit', true);				// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			gridTS.setProperty('rowNumbers', ${rowNumbers});		// 로우의 번호 표시 여부를 지정한다. [true/false]
			gridTS.setProperty('sortable', ${sortable});			// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			gridTS.setProperty('panelVisible', ${panelVisible});	// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			gridTS.setProperty('enterToNextRow', ${enterToNextRow});// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			gridTS.setProperty('acceptZero', ${acceptZero});		// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			gridTS.setProperty('multiSelect', false);				// [선택] 컬럼의 사용여부를 지정한다. [true/false]
			gridTS.setProperty('singleSelect', ${singleSelect});	// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]

			<%-- SUPER 유저 or B100 : 고객사담당자 or M100 : 관리자 --%>
        	if( ${!havePermission} ) {
                EVF.C('Insert').setDisabled(true);
                EVF.C('Update').setDisabled(true);
            }
			<%-- 수정 --%>
            if( !EVF.isEmpty(EVF.V("CUST_CD")) ) {
            	EVF.C('Insert').setDisabled(true);
            	EVF.C('CUST_CD').setDisabled(true);
                EVF.C('IRS_NUM').setDisabled(true);
            } else {
                EVF.C('Update').setDisabled(true);
            }
            
            onChangeCompanyType();
            
			doSearchTs();
        }

		function doSearchTs(){

			var store = new EVF.Store();
			store.setGrid([gridTS]);
			store.setParameter("CUST_CD", EVF.V("CUST_CD"));
			store.setParameter("MANAGE_CD", "${ses.manageCd}");
			store.load(baseUrl + 'ocur0011_doSearchTs.so', function() {
				if(gridTS.getRowCount() > 0){

					gridTS.checkAll(true);

					var rowIds = gridTS.getAllRowId();
					for(var i in rowIds) {
						if(gridTS.getCellValue(rowIds[i], 'REQUIRED_FLAG') == "1") {
							gridTS.setCellRequired(rowIds[i], 'ATT_FILE_CNT', true);
						}
					}
				}
			});
		}

        function doSave() {

            var btnData = this.getData().data;
            var btnMsg = (btnData == "I" ? "${msg.M0011}" : "${msg.M0012}");

			<%-- 수정시 대표자명, 우편번호, 주소, 상세주소가 변경되는 경우 History 저장. --%>
			var changeFlag = "N";
			if( !EVF.isEmpty(EVF.V("CUST_CD")) ) {
				if( everString.lrTrim(EVF.V("CEO_USER_NM_ORI")) != everString.lrTrim(EVF.V("CEO_USER_NM"))
						|| everString.lrTrim(EVF.V("HQ_ZIP_CD_ORI")) != everString.lrTrim(EVF.V("HQ_ZIP_CD"))
						|| everString.lrTrim(EVF.V("HQ_ADDR_1_ORI")) != everString.lrTrim(EVF.V("HQ_ADDR_1"))
						|| everString.lrTrim(EVF.V("HQ_ADDR_2_ORI")) != everString.lrTrim(EVF.V("HQ_ADDR_2")) ) {
					changeFlag = "Y";
				}
			}

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            <%-- 등록시 고객사는 첨부파일 필수 아님 : 20200716
			var rowIds = gridTS.getAllRowId();
			for(var i in rowIds) {
				if(gridTS.getCellValue(rowIds[i], 'REQUIRED_FLAG') == "1" && EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'ATT_FILE_NUM'))) {
					return EVF.alert(gridTS.getCellValue(rowIds[i], 'TMPL_FILE_NM') + "${OCUR0011_025}");
				}
				if(gridTS.getCellValue(rowIds[i], 'REQUIRED_FLAG') == "1" && !EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_PERIOD'))) {
					if(EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_START_DATE')) || EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_END_DATE'))) {
						return EVF.alert(gridTS.getCellValue(rowIds[i], 'TMPL_FILE_NM') + "의 " + "${OCUR0011_026}");
					}
				}
				if(!EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'ATT_FILE_NUM')) && !EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_PERIOD'))) {
					if(EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_START_DATE')) || EVF.isEmpty(gridTS.getCellValue(rowIds[i], 'VALID_END_DATE'))) {
						return EVF.alert(gridTS.getCellValue(rowIds[i], 'TMPL_FILE_NM') + "의 " + "${OCUR0011_026}");
					}
				}
				if(gridTS.getCellValue(rowIds[i], 'VALID_START_DATE') > gridTS.getCellValue(rowIds[i], 'VALID_END_DATE')) {
					return EVF.alert(gridTS.getCellValue(rowIds[i], 'TMPL_FILE_NM') + "의 " + "${OCUR0011_027}");
				}
			} --%>

            EVF.confirm(btnMsg, function () {
				store.doFileUpload(function() {
					store.setParameter("changeFlag", changeFlag);
					store.setGrid([gridTS]);
					store.getGridData(gridTS, 'sel');
					store.load(baseUrl + 'ocur0011_doSave.so', function () {
						var custCd = this.getParameter("CUST_CD");
						EVF.alert(this.getResponseMessage(), function() {
							if (!EVF.isEmpty(custCd)) {
								opener.doSearch();
								var param = {
									'CUST_CD': custCd,
									'detailView': false,
									'popupFlag': true
								};
								window.location.href = '/nhepro/OCUR/OCUR0011/view.so?' + $.param(param);
							}
						});
					});
				});
			});
        }

        function doSearchTB() {

        	if(EVF.isEmpty(EVF.V("IRS_NUM"))) {
        		return EVF.alert("${OCUR0011_028}");
			}

			var store = new EVF.Store();
			store.setParameter("IRS_NUM", EVF.V("IRS_NUM"));
			store.load(baseUrl + 'ocur0011_doSearchTB.so', function() {
				var rtnStr = this.getParameter("rtnStr");
				if(EVF.isEmpty(rtnStr) || rtnStr == "") {
					return EVF.alert("${OCUR0011_029}");
				}
				if(!EVF.isEmpty(rtnStr) && rtnStr != "") {
					var rtnJson = JSON.parse(rtnStr);
					EVF.V("CUST_NM", rtnJson.CUST_NM);
					EVF.V("COMPANY_TYPE", rtnJson.COMPANY_TYPE);
					EVF.V("RELAT_YN", rtnJson.RELAT_YN);
					EVF.V("CORP_TYPE", rtnJson.CORP_TYPE);
					EVF.V("COMPANY_REG_NUM", rtnJson.COMPANY_REG_NUM);
					EVF.V("HQ_ZIP_CD", rtnJson.HQ_ZIP_CD);
					EVF.V("HQ_ADDR_1", rtnJson.HQ_ADDR_1);
					EVF.V("HQ_ADDR_2", rtnJson.HQ_ADDR_2);
					EVF.V("CEO_USER_NM", rtnJson.CEO_USER_NM);
					EVF.V("BUSINESS_TYPE", rtnJson.BUSINESS_TYPE);
					EVF.V("INDUSTRY_TYPE", rtnJson.INDUSTRY_TYPE);
					EVF.V("TEL_NUM", rtnJson.TEL_NUM);
					EVF.V("FAX_NUM", rtnJson.FAX_NUM);
					EVF.V("CORP_TYPE", rtnJson.CORP_TYPE);
				}
			});
		}
        
        //2021.09.15 신규등록/수정 시 사업자구분 법인인경우 법인등록번호 필수입력하도록 변경
        function onChangeCompanyType(){
        	if(EVF.C("COMPANY_TYPE").getValue() == "C"){
        		EVF.C('COMPANY_REG_NUM').setRequired(true);
        	} else {
        		EVF.C('COMPANY_REG_NUM').setRequired(false);
        	}
        }

		function isIrsNum(str) {

			var checkID = [1, 3, 7, 1, 3, 7, 1, 3, 5, 1];
			var chkSum = 0;
			var c2 = "";
			var remander;

			str = str.replace(/-/gi,'');
			for (var i = 0; i <= 7; i++) {
				chkSum += checkID[i] * str.charAt(i);
			}
			c2 = "0" + (checkID[8] * str.charAt(8));
			c2 = c2.substring(c2.length - 2, c2.length);
			chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));
			remander = (10 - (chkSum % 10)) % 10 ;
			if (Math.floor(str.charAt(9)) == remander) {
				return true ; // OK!
			}
			return false;
		}

		function checkCompanyRegNum(){
			if( !isCompanyRegNum(EVF.V("COMPANY_REG_NUM")) ) {
				EVF.alert("${msg.M0174}");
				EVF.V("COMPANY_REG_NUM", "");
				EVF.C('COMPANY_REG_NUM').setFocus();
			}
		}

		function isCompanyRegNum(bubinNum) {

			var as_Biz_no= String(bubinNum);
			var isNum = true;
			var I_TEMP_SUM = 0 ;
			var I_TEMP = 0;
			var S_TEMP;
			var I_CHK_DIGIT = 0;

			if(bubinNum.length != 13) { return false; }

			for(index01 = 1; index01 < 13; index01++) {
				var i = index01 % 2;
				var j = 0;

				if(i == 1) j = 1;
				else if( i == 0) j = 2;

				I_TEMP_SUM = I_TEMP_SUM + parseInt(as_Biz_no.substring(index01-1, index01),10) * j;
			}

			I_CHK_DIGIT= I_TEMP_SUM%10 ;
			if(I_CHK_DIGIT != 0 ) I_CHK_DIGIT = 10 - I_CHK_DIGIT;

			if (as_Biz_no.substring(12,13) != String(I_CHK_DIGIT)) return false;
			return true ;
		}

		function checkTelNo() {

			var checkType = this.getData().data;
			if(checkType == "FAX_NUM") {
				if(!everString.isTel(EVF.V("FAX_NUM"))) {
					EVF.V("FAX_NUM", "");
					EVF.C('FAX_NUM').setFocus();
					EVF.alert("${msg.M0128}");
				}
			}
			if(checkType == "TEL_NUM") {
				if(!everString.isTel(EVF.V("TEL_NUM"))) {
					EVF.V("TEL_NUM", "");
					EVF.C('TEL_NUM').setFocus();
					EVF.alert("${msg.M0128}");
				}
			}
		}

		function searchZipCd() {
			var url = '/common/code/BADV_020/view.so';
			var param = {
				callBackFunction : "setZipCode",
				modalYn : false
			};
			everPopup.openWindowPopup(url, 700, 600, param);
		}

		function setZipCode(zipcd) {
			if (zipcd.ZIP_CD != "") {
				EVF.V("HQ_ZIP_CD", zipcd.ZIP_CD_5);
				EVF.V("HQ_ADDR_1", zipcd.ADD);
				EVF.C('HQ_ADDR_2').setFocus();
			}
		}

		<%-- 총자산 자동계산 (총자산 = 총부채 + 총자본) --%>
		<%-- 부채비율 자동계산 (부채총액 / 자기자본 ) * 100  소수점 1자리 --%>
		function calTotAsset() {

			var totSdept = eval(EVF.V("TOT_SDEPT")); // 총부채
			var totFund  = eval(EVF.V("TOT_FUND"));  // 총자본

			var totAsset = 0;
			if(totSdept != null && totSdept != "") { totAsset = totAsset + totSdept; }
			if(totFund  != null && totFund != "")  { totAsset = totAsset + totFund; }

			var rateSdept = 0;
			if((totSdept != null && totSdept != "") && (totFund != null && totFund != "")) {
				rateSdept = everMath.round_float((totSdept / totFund) * 100, 1);
			}

			EVF.V("TOT_ASSET", totAsset);
			EVF.V("RATE_SDEPT", rateSdept);
		}

		<%-- 유동비율 자동계산 (유동비율 = (유동자산 / 유동부채) * 100  소수점 1자리) --%>
		function calCurrRate() {

			var currAsset = eval(EVF.V("CURR_ASSET")); // 유동자산
			var currSdept = eval(EVF.V("CURR_SDEPT"));  // 유동부채

			var rateCurr = 0;
			if((currAsset != null && currAsset != "") && (currSdept != null && currSdept != "")) {
				rateCurr = everMath.round_float((currAsset / currSdept) * 100, 1);
			}

			EVF.V("RATE_CURR", rateCurr);
		}

		<%-- 관리정보 > 첨부파일 --%>
		function addAttachFile() {
			var param = {
				detailView: ${param.detailView },
				attFileNum: EVF.V("ATTACH_FILE_NUM"),
				callBackFunction: 'addAttachFileCallback',
				bizType: 'OCUR',
				fileExtension: '*'
			};
			everPopup.fileAttachPopup(param);
			// everPopup.openPopupByScreenId('commonFileAttach', 650, (param.detailView == true ? 310 : 340), param);
		}

		function addAttachFileCallback(rowIdx, fileId, fileCnt) {
			EVF.V("ATTACH_FILE_NM", fileCnt);
			EVF.V("ATTACH_FILE_NUM", fileId);
		}

		<%-- 재무정보 > 첨부파일 --%>
		function addAssetFile() {
			var param = {
				detailView: ${param.detailView },
				attFileNum: EVF.V("ASSET_FILE_NUM"),
				callBackFunction: 'addAAssetFileCallback',
				bizType: 'OCUR',
				fileExtension: '*'
			};
			everPopup.fileAttachPopup(param);
			// everPopup.openPopupByScreenId('commonFileAttach', 650, (param.detailView == true ? 310 : 340), param);
		}

		function addAAssetFileCallback(rowIdx, fileId, fileCnt) {
			EVF.V("ASSET_FILE_NM", fileCnt);
			EVF.V("ASSET_FILE_NUM", fileId);
		}

		<%-- 템플릿 다운로드 --%>
		function doTempletDown() {
			var store = new EVF.Store();
			store.setParameter('tmplNum', 'BS01_002');
			store.load(baseUrl + 'ocur0011_doTempletDown.so', function () {
			//store.load('/evermp/BS99/BS9901/bs99010_getTmplAttFileNum.so', function() {
				var param = {
					bizType: "tmplMng",
					attFileNum: this.getParameter('attFileNum'),
					callBackFunction: null,
					rowIdx: null,
					detailView: true
				};
				everPopup.readOnlyFileAttachPopup(param);
			}, false);
		}

		function setFileAttach(rowIdx, fileId, fileCnt) {
			gridTS.setCellValue(rowIdx, 'ATT_FILE_CNT', fileCnt);
			gridTS.setCellValue(rowIdx, 'ATT_FILE_NUM', fileId);
		}

		function doClose() {
			EVF.closeWindow();
		}

	</script>

	<e:window id="OCUR0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

		<e:inputHidden id="CEO_USER_NM_ORI" name="CEO_USER_NM_ORI" value="${formData.CEO_USER_NM }" />
		<e:inputHidden id="HQ_ZIP_CD_ORI" name="HQ_ZIP_CD_ORI" value="${formData.HQ_ZIP_CD }" />
		<e:inputHidden id="HQ_ADDR_1_ORI" name="HQ_ADDR_1_ORI" value="${formData.HQ_ADDR_1 }" />
		<e:inputHidden id="HQ_ADDR_2_ORI" name="HQ_ADDR_2_ORI" value="${formData.HQ_ADDR_2 }" />

		<%-- 1. 고객 일반정보 --%>
		<e:panel id="leftP1" height="25px" width="40%">
			<e:title title="${form_FORM_CAPTION1_N}" depth="1" />
		</e:panel>
		<e:searchPanel id="form1" title="" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" collapsedIcon="true">
			<e:row>
				<e:label for="CUST_CD" title="${form_CUST_CD_N}" />
				<e:field>
					<e:inputText id="CUST_CD" name="CUST_CD" value="${formData.CUST_CD }" width="${form_CUST_CD_W}" maxLength="${form_CUST_CD_M}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}"  maskType="${form_CUST_CD_MT}" />
				</e:field>
				<e:label for="CUST_NM" title="${form_CUST_NM_N}" />
				<e:field>
					<e:inputText id="CUST_NM" name="CUST_NM" value="${formData.CUST_NM }" width="${form_CUST_NM_W}" maxLength="${form_CUST_NM_M}" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}"  maskType="${form_CUST_NM_MT}" />
				</e:field>
				<e:label for="CUST_ENG_NM" title="${form_CUST_ENG_NM_N}" />
				<e:field>
					<e:inputText id="CUST_ENG_NM" name="CUST_ENG_NM" value="${formData.CUST_ENG_NM }" width="${form_CUST_ENG_NM_W}" maxLength="${form_CUST_ENG_NM_M}" disabled="${form_CUST_ENG_NM_D}" readOnly="${form_CUST_ENG_NM_RO}" required="${form_CUST_ENG_NM_R}"  maskType="${form_CUST_ENG_NM_MT}" />
				</e:field>
			</e:row>
			 <e:row>
				<e:label for="COMPANY_TYPE" title="${form_COMPANY_TYPE_N}"/>
				<e:field>
					<e:select id="COMPANY_TYPE" name="COMPANY_TYPE" value="${formData.COMPANY_TYPE }" options="${companyTypeOptions}" width="${form_COMPANY_TYPE_W}" disabled="${form_COMPANY_TYPE_D}" readOnly="${form_COMPANY_TYPE_RO}" required="${form_COMPANY_TYPE_R}" placeHolder=""  maskType="${form_COMPANY_TYPE_MT}" onChange="onChangeCompanyType"/>
				</e:field>
				<e:label for="RELAT_YN" title="${form_RELAT_YN_N}"/>
				<e:field>
					<e:select id="RELAT_YN" name="RELAT_YN" value="${formData.RELAT_YN }" options="${relatYnOptions}" width="${form_RELAT_YN_W}" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_RELAT_YN_R}" placeHolder=""  maskType="${form_RELAT_YN_MT}"/>
				</e:field>
				<e:label for="CORP_TYPE" title="${form_CORP_TYPE_N}"/>
				<e:field>
					<e:select id="CORP_TYPE" name="CORP_TYPE" value="${formData.CORP_TYPE }" options="${corpTypeOptions}" width="${form_CORP_TYPE_W}" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder=""  maskType="${form_CORP_TYPE_MT}"/>
				</e:field>
			 </e:row>
			<e:row>
				<e:label for="IRS_NUM" title="${form_IRS_NUM_N}" />
				<e:field>
					<e:inputText id="IRS_NUM" name="IRS_NUM" placeHolder="${OCUR0011_INPUT_T1 }" value="${formData.IRS_NUM }" width="120px" maxLength="${form_IRS_NUM_M}" disabled="${form_IRS_NUM_D}" readOnly="${form_IRS_NUM_RO}" required="${form_IRS_NUM_R}" maskType="${form_IRS_NUM_MT}" />
					<e:button id="SearchTB" name="SearchTB" label="${SearchTB_N}" disabled="${SearchTB_D}" visible="${SearchTB_V}" onClick="doSearchTB" />
				</e:field>
				<e:label for="COMPANY_REG_NUM" title="${form_COMPANY_REG_NUM_N}" />
				<e:field>
					<e:inputText id="COMPANY_REG_NUM" name="COMPANY_REG_NUM" placeHolder="${OCUR0011_INPUT_T1 }" value="${formData.COMPANY_REG_NUM }" width="${form_COMPANY_REG_NUM_W}" maxLength="${form_COMPANY_REG_NUM_M}" disabled="${form_COMPANY_REG_NUM_D}" readOnly="${form_COMPANY_REG_NUM_RO}" required="${form_COMPANY_REG_NUM_R}" onChange="checkCompanyRegNum"  maskType="${form_COMPANY_REG_NUM_MT}" />
				</e:field>
				<e:label for="SCALE_TYPE" title="${form_SCALE_TYPE_N}"/>
				<e:field>
					<e:select id="SCALE_TYPE" name="SCALE_TYPE" value="${formData.SCALE_TYPE }" options="${scaleTypeOptions}" width="${form_SCALE_TYPE_W}" disabled="${form_SCALE_TYPE_D}" readOnly="${form_SCALE_TYPE_RO}" required="${form_SCALE_TYPE_R}" placeHolder=""  maskType="${form_SCALE_TYPE_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="HQ_ZIP_CD" title="${form_HQ_ZIP_CD_N}"/>
				<e:field>
					<e:search id="HQ_ZIP_CD" name="HQ_ZIP_CD" value="${formData.HQ_ZIP_CD }" width="${form_HQ_ZIP_CD_W}" maxLength="7" onIconClick="searchZipCd" disabled="${form_HQ_ZIP_CD_D}" readOnly="false" required="${form_HQ_ZIP_CD_R}"  maskType="${form_HQ_ZIP_CD_MT}" />
				</e:field>
				<e:label for="HQ_ADDR_1" title="${form_HQ_ADDR_1_N}"/>
				<e:field colSpan="3">
					<e:inputText id="HQ_ADDR_1" name="HQ_ADDR_1" value="${formData.HQ_ADDR_1 }" width="${form_HQ_ADDR_1_W}" maxLength="${form_HQ_ADDR_1_M}" disabled="${form_HQ_ADDR_1_D}" readOnly="${form_HQ_ADDR_1_RO}" required="${form_HQ_ADDR_1_R}" style="${imeMode}" maskType="${form_HQ_ADDR_1_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}" />
				<e:field>
					<e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="${formData.CEO_USER_NM }" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}"  maskType="${form_CEO_USER_NM_MT}" />
				</e:field>
				<e:label for="HQ_ADDR_2" title="${form_HQ_ADDR_2_N}"/>
				<e:field colSpan="3">
					<e:inputText id="HQ_ADDR_2" name="HQ_ADDR_2" value="${formData.HQ_ADDR_2 }" width="${form_HQ_ADDR_2_W}" maxLength="${form_HQ_ADDR_2_M}" disabled="${form_HQ_ADDR_2_D}" readOnly="${form_HQ_ADDR_2_RO}" required="${form_HQ_ADDR_2_R}" style="${imeMode}" maskType="${form_HQ_ADDR_2_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BUSINESS_TYPE" title="${form_BUSINESS_TYPE_N}" />
				<e:field>
					<e:inputText id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="${formData.BUSINESS_TYPE }" width="${form_BUSINESS_TYPE_W}" maxLength="${form_BUSINESS_TYPE_M}" disabled="${form_BUSINESS_TYPE_D}" readOnly="${form_BUSINESS_TYPE_RO}" required="${form_BUSINESS_TYPE_R}"  maskType="${form_BUSINESS_TYPE_MT}" />
				</e:field>
				<e:label for="INDUSTRY_TYPE" title="${form_INDUSTRY_TYPE_N}" />
				<e:field>
					<e:inputText id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="${formData.INDUSTRY_TYPE }" width="${form_INDUSTRY_TYPE_W}" maxLength="${form_INDUSTRY_TYPE_M}" disabled="${form_INDUSTRY_TYPE_D}" readOnly="${form_INDUSTRY_TYPE_RO}" required="${form_INDUSTRY_TYPE_R}"  maskType="${form_INDUSTRY_TYPE_MT}" />
				</e:field>
				<e:label for="FOUNDATION_DATE" title="${form_FOUNDATION_DATE_N}"/>
				<e:field>
					<e:inputDate id="FOUNDATION_DATE" name="FOUNDATION_DATE" value="${formData.FOUNDATION_DATE }" width="${inputDateWidth}" datePicker="true" required="${form_FOUNDATION_DATE_R}" disabled="${form_FOUNDATION_DATE_D}" readOnly="${form_FOUNDATION_DATE_RO}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="TEL_NUM" title="${form_TEL_NUM_N}" />
				<e:field>
					<e:inputText id="TEL_NUM" name="TEL_NUM" placeHolder="${OCUR0011_INPUT_T2 }" value="${formData.TEL_NUM }" width="${form_TEL_NUM_W}" maxLength="${form_TEL_NUM_M}" disabled="${form_TEL_NUM_D}" readOnly="${form_TEL_NUM_RO}" required="${form_TEL_NUM_R}" data="TEL_NUM" onChange="checkTelNo" maskType="${form_TEL_NUM_MT}" />
				</e:field>
				<e:label for="FAX_NUM" title="${form_FAX_NUM_N}" />
				<e:field>
					<e:inputText id="FAX_NUM" name="FAX_NUM" placeHolder="${OCUR0011_INPUT_T2 }" value="${formData.FAX_NUM }" width="${form_FAX_NUM_W}" maxLength="${form_FAX_NUM_M}" disabled="${form_FAX_NUM_D}" readOnly="${form_FAX_NUM_RO}" required="${form_FAX_NUM_R}" data="FAX_NUM" onChange="checkTelNo" maskType="${form_FAX_NUM_MT}" />
				</e:field>
				<e:label for="EMAIL" title="${form_EMAIL_N}"/>
				<e:field>
					<e:inputText id="EMAIL" name="EMAIL" placeHolder="${OCUR0011_INPUT_T3 }" value="${formData.EMAIL }" width="${form_EMAIL_W}" maxLength="${form_EMAIL_M}" disabled="${form_EMAIL_D}" readOnly="${form_EMAIL_RO}" required="${form_EMAIL_R}" style="${imeMode}" maskType="${form_EMAIL_MT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ABOUT_US" title="${form_ABOUT_US_N}"/>
				<e:field colSpan="5">
					<e:textArea id="ABOUT_US" name="ABOUT_US" value="${formData.ABOUT_US }" height="120px" width="${form_ABOUT_US_W}" maxLength="${form_ABOUT_US_M}" disabled="${form_ABOUT_US_D}" readOnly="${form_ABOUT_US_RO}" required="${form_ABOUT_US_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="REMARK" title="${form_REMARK_N}"/>
				<e:field colSpan="5">
					<e:textArea id="REMARK" name="REMARK" value="${formData.REMARK }" height="120px" width="${form_REMARK_W}" maxLength="${form_REMARK_M}" disabled="${form_REMARK_D}" readOnly="${form_REMARK_RO}" required="${form_REMARK_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 2. 관리정보 --%>
		<e:panel id="leftP2" height="25px" width="40%">
			<e:title title="${form_FORM_CAPTION2_N}" depth="1" />
		</e:panel>
		<e:searchPanel id="form2" title="" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" collapsedIcon="true">
			<e:row>
				<e:label for="E_BILL_ASP_TYPE" title="${form_E_BILL_ASP_TYPE_N}"/>
				<e:field>
					<e:select id="E_BILL_ASP_TYPE" name="E_BILL_ASP_TYPE" value="${formData.E_BILL_ASP_TYPE }" options="${eBillAspTypeOptions}" width="${form_E_BILL_ASP_TYPE_W}" disabled="${form_E_BILL_ASP_TYPE_D}" readOnly="${form_E_BILL_ASP_TYPE_RO}" required="${form_E_BILL_ASP_TYPE_R}"  placeHolder="" maskType="${form_E_BILL_ASP_TYPE_MT}"/>
				</e:field>
				<e:label for="TAX_ASP_NM" title="${form_TAX_ASP_NM_N}" />
				<e:field>
					<e:inputText id="TAX_ASP_NM" name="TAX_ASP_NM" value="${formData.TAX_ASP_NM }" width="${form_TAX_ASP_NM_W}" maxLength="${form_TAX_ASP_NM_M}" disabled="${form_TAX_ASP_NM_D}" readOnly="${form_TAX_ASP_NM_RO}" required="${form_TAX_ASP_NM_R}"  maskType="${form_TAX_ASP_NM_MT}" />
				</e:field>
				<e:label for="TAX_SEND_TYPE" title="${form_TAX_SEND_TYPE_N}"/>
				<e:field>
					<e:select id="TAX_SEND_TYPE" name="TAX_SEND_TYPE" value="${formData.TAX_SEND_TYPE }" options="${taxSendTypeOptions}" width="${form_TAX_SEND_TYPE_W}" disabled="${form_TAX_SEND_TYPE_D}" readOnly="${form_TAX_SEND_TYPE_RO}" required="${form_TAX_SEND_TYPE_R}" placeHolder=""  maskType="${form_TAX_SEND_TYPE_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CREDIT_AGENCY_NM" title="${form_CREDIT_AGENCY_NM_N}" />
				<e:field>
					<e:inputText id="CREDIT_AGENCY_NM" name="CREDIT_AGENCY_NM" value="${formData.CREDIT_AGENCY_NM }" width="${form_CREDIT_AGENCY_NM_W}" maxLength="${form_CREDIT_AGENCY_NM_M}" disabled="${form_CREDIT_AGENCY_NM_D}" readOnly="${form_CREDIT_AGENCY_NM_RO}" required="${form_CREDIT_AGENCY_NM_R}"  maskType="${form_CREDIT_AGENCY_NM_MT}" />
				</e:field>
				<e:label for="CREDIT_CD" title="${form_CREDIT_CD_N}" />
				<e:field>
					<e:inputText id="CREDIT_CD" name="CREDIT_CD" value="${formData.CREDIT_CD }" width="${form_CREDIT_CD_W}" maxLength="${form_CREDIT_CD_M}" disabled="${form_CREDIT_CD_D}" readOnly="${form_CREDIT_CD_RO}" required="${form_CREDIT_CD_R}"  maskType="${form_CREDIT_CD_MT}" />
				</e:field>
				<e:label for="ATTACH_FILE_NM" title="${form_ATTACH_FILE_NM_N}"/>
				<e:field>
					<e:search id="ATTACH_FILE_NM" name="ATTACH_FILE_NM" value="${formData.ATTACH_FILE_NM }" width="${form_ATTACH_FILE_NM_W}" maxLength="20" onIconClick="addAttachFile" disabled="${form_ATTACH_FILE_NM_D}" readOnly="true" required="${form_ATTACH_FILE_NM_R}" />
					<e:inputHidden id="ATTACH_FILE_NUM" name="ATTACH_FILE_NUM" value="${formData.ATTACH_FILE_NUM}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="PROGRESS_NM" title="${form_PROGRESS_NM_N}"/>
				<e:field>
					<e:inputHidden id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD }" />
					<e:text>${formData.PROGRESS_NM }&nbsp;</e:text>
				</e:field>
				<e:label for="MOD_USER_NM" title="${form_MOD_USER_NM_N}"/>
				<e:field>
					<e:text>${formData.MOD_USER_NM }&nbsp;</e:text>
				</e:field>
				<e:label for="MOD_DATE" title="${form_MOD_DATE_N}"/>
				<e:field>
					<e:text>${formData.MOD_DATE }&nbsp;</e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 3. 재무정보 --%>
		<e:panel id="leftP3" height="25px" width="100%">
			<e:title title="${form_FORM_CAPTION3_N}" depth="1" />
			<span style="position: relative; left: 80px; top: -23px; font-size: 11px; color: red;">${OCUR0011_TEXT5}</span>
			<span style="position: relative; top: -18px; font-size: 11px; float: right; font-weight: bold; right: 2px;">${OCUR0011_SUB_T}</span>
		</e:panel>
		<e:searchPanel id="form3" title="" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false" collapsedIcon="true">
			<e:row>
				<e:label for="STD_YYYY" title="${form_STD_YYYY_N}"/>
				<e:field>
					<e:select id="STD_YYYY" name="STD_YYYY" value="${formData.STD_YYYY }" options="${stdYyyyOptions}" width="${form_STD_YYYY_W}" disabled="${form_STD_YYYY_D}" readOnly="${form_STD_YYYY_RO}" required="${form_STD_YYYY_R}" placeHolder=""  maskType="${form_STD_YYYY_MT}"/>
				</e:field>
				<e:label for="DATA_REF_CD" title="${form_DATA_REF_CD_N}"/>
				<e:field>
					<e:select id="DATA_REF_CD" name="DATA_REF_CD" value="${formData.DATA_REF_CD }" options="${dataRefCdOptions}" width="${form_DATA_REF_CD_W}" disabled="${form_DATA_REF_CD_D}" readOnly="${form_DATA_REF_CD_RO}" required="${form_DATA_REF_CD_R}" placeHolder=""  maskType="${form_DATA_REF_CD_MT}"/>
				</e:field>
				<e:label for="TOT_ASSET" title="${form_TOT_ASSET_N}" />
				<e:field>
					<e:inputNumber id="TOT_ASSET" name="TOT_ASSET" value="${formData.TOT_ASSET}" width="${form_TOT_ASSET_W}" maxValue="${form_TOT_ASSET_M}" decimalPlace="${form_TOT_ASSET_NF}" disabled="${form_TOT_ASSET_D}" readOnly="${form_TOT_ASSET_RO}" required="${form_TOT_ASSET_R}" onNumberKr="${form_TOT_ASSET_KR}" currencyText="${form_TOT_ASSET_CT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="TOT_FUND" title="${form_TOT_FUND_N}" />
				<e:field>
					<e:inputNumber id="TOT_FUND" name="TOT_FUND" value="${formData.TOT_FUND}" width="${form_TOT_FUND_W}" maxValue="${form_TOT_FUND_M}" decimalPlace="${form_TOT_FUND_NF}" disabled="${form_TOT_FUND_D}" readOnly="${form_TOT_FUND_RO}" required="${form_TOT_FUND_R}" onChange="calTotAsset" onNumberKr="${form_TOT_FUND_KR}" currencyText="${form_TOT_FUND_CT}" />
				</e:field>
				<e:label for="TOT_SDEPT" title="${form_TOT_SDEPT_N}" />
				<e:field>
					<e:inputNumber id="TOT_SDEPT" name="TOT_SDEPT" value="${formData.TOT_SDEPT}" width="${form_TOT_SDEPT_W}" maxValue="${form_TOT_SDEPT_M}" decimalPlace="${form_TOT_SDEPT_NF}" disabled="${form_TOT_SDEPT_D}" readOnly="${form_TOT_SDEPT_RO}" required="${form_TOT_SDEPT_R}" onChange="calTotAsset" onNumberKr="${form_TOT_SDEPT_KR}" currencyText="${form_TOT_SDEPT_CT}" />
				</e:field>
				<e:label for="RATE_SDEPT" title="${form_RATE_SDEPT_N}" />
				<e:field>
					<e:inputNumber id="RATE_SDEPT" name="RATE_SDEPT" value="${formData.RATE_SDEPT}" width="${form_RATE_SDEPT_W}" maxValue="${form_RATE_SDEPT_M}" decimalPlace="${form_RATE_SDEPT_NF}" disabled="${form_RATE_SDEPT_D}" readOnly="${form_RATE_SDEPT_RO}" required="${form_RATE_SDEPT_R}" onNumberKr="${form_RATE_SDEPT_KR}" currencyText="${form_RATE_SDEPT_CT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CURR_ASSET" title="${form_CURR_ASSET_N}" />
				<e:field>
					<e:inputNumber id="CURR_ASSET" name="CURR_ASSET" value="${formData.CURR_ASSET}" width="${form_CURR_ASSET_W}" maxValue="${form_CURR_ASSET_M}" decimalPlace="${form_CURR_ASSET_NF}" disabled="${form_CURR_ASSET_D}" readOnly="${form_CURR_ASSET_RO}" required="${form_CURR_ASSET_R}" onChange="calCurrRate" onNumberKr="${form_CURR_ASSET_KR}" currencyText="${form_CURR_ASSET_CT}" />
				</e:field>
				<e:label for="CURR_SDEPT" title="${form_CURR_SDEPT_N}" />
				<e:field>
					<e:inputNumber id="CURR_SDEPT" name="CURR_SDEPT" value="${formData.CURR_SDEPT}" width="${form_CURR_SDEPT_W}" maxValue="${form_CURR_SDEPT_M}" decimalPlace="${form_CURR_SDEPT_NF}" disabled="${form_CURR_SDEPT_D}" readOnly="${form_CURR_SDEPT_RO}" required="${form_CURR_SDEPT_R}" onChange="calCurrRate" onNumberKr="${form_CURR_SDEPT_KR}" currencyText="${form_CURR_SDEPT_CT}" />
				</e:field>
				<e:label for="RATE_CURR" title="${form_RATE_CURR_N}" />
				<e:field>
					<e:inputNumber id="RATE_CURR" name="RATE_CURR" value="${formData.RATE_CURR}" width="${form_RATE_CURR_W}" maxValue="${form_RATE_CURR_M}" decimalPlace="${form_RATE_CURR_NF}" disabled="${form_RATE_CURR_D}" readOnly="${form_RATE_CURR_RO}" required="${form_RATE_CURR_R}" onNumberKr="${form_RATE_CURR_KR}" currencyText="${form_RATE_CURR_CT}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="TOT_SALES" title="${form_TOT_SALES_N}" />
				<e:field>
					<e:inputNumber id="TOT_SALES" name="TOT_SALES" value="${formData.TOT_SALES}" width="${form_TOT_SALES_W}" maxValue="${form_TOT_SALES_M}" decimalPlace="${form_TOT_SALES_NF}" disabled="${form_TOT_SALES_D}" readOnly="${form_TOT_SALES_RO}" required="${form_TOT_SALES_R}" onNumberKr="${form_TOT_SALES_KR}" currencyText="${form_TOT_SALES_CT}" />
				</e:field>
				<e:label for="NET_INCOM" title="${form_NET_INCOM_N}" />
				<e:field>
					<e:inputNumber id="NET_INCOM" name="NET_INCOM" value="${formData.NET_INCOM}" width="${form_NET_INCOM_W}" maxValue="${form_NET_INCOM_M}" decimalPlace="${form_NET_INCOM_NF}" disabled="${form_NET_INCOM_D}" readOnly="${form_NET_INCOM_RO}" required="${form_NET_INCOM_R}" onNumberKr="${form_NET_INCOM_KR}" currencyText="${form_NET_INCOM_CT}" />
				</e:field>
				<e:label for="ASSET_FILE_NM" title="${form_ASSET_FILE_NM_N}"/>
				<e:field>
					<e:search id="ASSET_FILE_NM" name="ASSET_FILE_NM" value="${formData.ASSET_FILE_NM }" width="${form_ASSET_FILE_NM_W}" maxLength="20" onIconClick="addAssetFile" disabled="${form_ASSET_FILE_NM_D}" readOnly="true" required="${form_ASSET_FILE_NM_R}" />
					<e:inputHidden id="ASSET_FILE_NUM" name="ASSET_FILE_NUM" value="${formData.ASSET_FILE_NUM}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 4. 첨부파일 --%>
		<e:panel id="leftP4" height="25px" width="40%">
			<e:title title="${form_FORM_CAPTION4_N}" depth="1" />
		</e:panel>

		<e:panel id="rightP3" height="30px" width="60%">
			<e:buttonBar id="buttonBar3" align="right" width="100%">
				<e:button id="TempletDown" name="TempletDown" label="${TempletDown_N}" disabled="${TempletDown_D}" visible="${TempletDown_V}" onClick="doTempletDown" />
			</e:buttonBar>
		</e:panel>

		<e:gridPanel id="gridTS" name="gridTS" width="100%" height="240px" gridType="${_gridType}" readOnly="${param.detailView}"/>

		<e:buttonBar id="buttonBar1" align="right" width="100%" title="">
			<e:button id="Insert" name="Insert" label="${Insert_N }" disabled="${Insert_D }" visible="${Insert_V }" onClick="doSave" data="I" />
			<e:button id="Update" name="Update" label="${Update_N }" disabled="${Update_D }" visible="${Update_V }" onClick="doSave" data="U" />
			<e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V }" onClick="doClose" />
		</e:buttonBar>

    </e:window>
</e:ui>