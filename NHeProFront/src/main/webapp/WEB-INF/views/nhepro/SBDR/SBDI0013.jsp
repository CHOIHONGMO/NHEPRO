<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>

<%
	String sgicUrl = PropertiesManager.getString("eversrm.sgic.url");
%>

<c:set var="sgicUrl" value="<%=sgicUrl%>" />

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/jquery.blockUI.js"></script>
    <!-- ML4WEB JS -->
    <script type="text/javascript" src="/MagicLine4Web/ML4Web/js/ext/ML_Config.js"></script>

	<script type="text/javascript">

		var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var userType = "${ses.userType}";
		var baseUrl = "/nhepro/SBDR/";
		var localServerFlag = "${localServerFlag}";

		function init() {

			if(${!havePermission}) {
				EVF.C('OpenGuar').setDisabled(true);
				EVF.C('CancelGuar').setDisabled(true);
				EVF.C('Submit').setDisabled(true);
				EVF.C('CancelReq').setDisabled(true);		// 2021.10.21 신청취소 추가
			} else {
				if(EVF.isEmpty(EVF.V("APP_DATE"))) {
					EVF.C('CancelReq').setDisabled(true);	// 2021.10.21 신청취소 추가
				} else {
					EVF.C('CancelReq').setDisabled(false);	// 2021.10.21 신청취소 추가
				}
			}
			
			setText();
			setGuarType();
		}

		function doSubmit() {

			var store = new EVF.Store();
			if(!store.validate()) { return; }
			
			// 입찰보증금을 입력하지 않은 경우
			if(EVF.isEmpty(EVF.V('BID_GUAR_AMT')) || Number(EVF.V('BID_GUAR_AMT')) == 0) {
				return EVF.alert("${SBDI0013_007}");
			}
			
			// 보증금 납부방법 = 첨부파일
			if(EVF.V('BID_GUAR_TYPE') == "F" && EVF.isEmpty(EVF.V('GUAR_ATT_FILE_NUM'))) {
				return EVF.alert("${SBDI0013_001}");
			}
			
			// 보증금 납부방법 = 전자보증
			if(EVF.V('BID_GUAR_TYPE') == "E") { 
				if(EVF.isEmpty(EVF.V('GUAR_REQ_NUM'))){
					return EVF.alert("${SBDI0013_002}");
				}
				
				if(EVF.V('INSU_STATUS') == "TA") {
					return EVF.alert("${SBDI0013_017}");
				}
				
				if(EVF.V('INSU_STATUS') == "DE") {
					return EVF.alert("${SBDI0013_018}");
				}
			} else {
				if(!EVF.isEmpty(EVF.V("HD_GUAR_REQ_NUM")) || !EVF.isEmpty(EVF.V("HD_GUAR_NUM"))) {
					return EVF.alert("전자보증을 요청 및 발급한 경우 '입찰보증서 취소' 후 '보증금 납부방법' 변경이 가능합니다.");
				}
			}
			
			EVF.confirm("${SBDI0013_003 }", function () {
			    if(localServerFlag == "Y") {
					doSave();
                } else {
                    document.reqForm.signData.value = EVF.V("VENDOR_CD") + "@@" + document.reqForm.idn.value + "@@" + EVF.V("BID_GUAR_AMT") + "@@" + "${signDate}";

					var certOdiFilter = "${certOidfilter}";
					var listOdiArr = certOdiFilter.split(";");
					var certOidfilter = "";
					for(var i in listOdiArr) {
						certOidfilter = certOidfilter + listOdiArr[i] + ",";
					}
					certOidfilter = certOidfilter.substring(0, certOidfilter.length-1);
                    magicline.uiapi.MakeSignData(document.reqForm, null, mlCallBack, certOidfilter);
                }
			});
		}

		function mlCallBack(code, message){
			if(code == 0) { <%-- 정상메시지 --%>
				if (message.encMsg != null) { document.reqForm.signedData.value = encodeURIComponent(message.encMsg); }
				if (message.vidRandom != null) { document.reqForm.vidRandom.value = encodeURIComponent(message.vidRandom); }
				doSave();
			} else {
				return EVF.alert("결과값 수신에 실패하였습니다.");
			}
		}

		function doSave() {

			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};

			var store = new EVF.Store();
			store.setParameter("signedData", document.reqForm.signedData.value);
			store.setParameter("vidRandom", document.reqForm.vidRandom.value);
			store.setParameter("idn", document.reqForm.idn.value);
			store.setParameter("localServerFlag", localServerFlag);
			store.doFileUpload(function() {
				store.load(baseUrl + 'sbdi0013_doSubmit.so', function(){
					
					var buyerCd = this.getParameter("buyerCd");
					var bidNum = this.getParameter("bidNum");
					var bidCnt = this.getParameter("bidCnt");
					var vendorCd = this.getParameter("vendorCd");
					EVF.alert(this.getResponseMessage(), function() {
						var param = {
							'BUYER_CD' : buyerCd,
							'BID_NUM'  : bidNum,
							'BID_CNT'  : bidCnt,
							'VENDOR_CD': vendorCd,
							'detailView': false,
							'popupFlag': true
						};
						if(popupFlag) {
							opener.doSearch();
							doClose();
						}
						else { document.location.href = '/nhepro/SBDR/SBDI0013/view.so?' + $.param(param); }
					});
				});
			});
		}
		
		// 2021.10.21 : 입찰신청취소
		function doCancelReq() {
			
			var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
			
			if(!EVF.isEmpty(EVF.V("HD_GUAR_REQ_NUM")) || !EVF.isEmpty(EVF.V("HD_GUAR_NUM"))) {
				return EVF.alert("전자보증증권을 요청 및 발급한 경우 '입찰보증서 취소' 후 '입찰 신청 취소'가 가능합니다.");
			}
			
			var store = new EVF.Store();
			EVF.confirm("${SBDI0013_022}", function () {
				store.load(baseUrl + 'sbdi0013_doCancelReq.so', function(){
					EVF.alert(this.getResponseMessage(), function() {
						if(popupFlag) {
							opener.doSearch();
							doClose();
						}
						else { document.location.href = '/nhepro/SBDR/SBDI0013/view.so?' }
					});
				});
			});
		}
		
		function doAttFile() {
			var guarType = EVF.V('BID_GUAR_TYPE');
			if( guarType != 'F' ) {
				return EVF.alert("보증금 납부방법이 '첨부파일'인 경우에만 첨부할 수 있습니다.");
			}
			
			var param = {
				attFileNum: EVF.V('GUAR_ATT_FILE_NUM'),
				rowIdx: '',
				callBackFunction: 'fileAttachPopupCallback',
				bizType: 'BID',
				detailView: false
			};
			everPopup.fileAttachPopup(param);
		}

		function fileAttachPopupCallback(gridRowId, fileId, fileCount) {
			EVF.V('GUAR_ATT_FILE_CNT', fileCount);
			EVF.V('GUAR_ATT_FILE_NUM', fileId);
		}

		function doAppAttFile() {
			var param = {
				attFileNum: EVF.V('APP_ATT_FILE_NUM'),
				rowIdx: '',
				callBackFunction: 'appFileAttachPopupCallback',
				bizType: 'BID',
				detailView: false
			};
			everPopup.fileAttachPopup(param);
		}

		function appFileAttachPopupCallback(gridRowId, fileId, fileCount) {
			EVF.V('APP_ATT_FILE_CNT', fileCount);
			EVF.V('APP_ATT_FILE_NUM', fileId);
		}

		function setText() {

			var element = Number(EVF.V('BID_GUAR_AMT'));
			var num = String(element);
			var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
			var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
			var result = "";

			var C1 = true;
			var C2 = true;
			var C3 = true;
			for (var i = 0; i < num.length; i++) {
				var str = "";
				var han = hanA[num.charAt(num.length - (i + 1))];
				if (han != "") {
					str += han+danA[i];

					if (4 <= i && i <= 7  && C1 == true) {str += "만"; C1 = false;}
					if (8 <= i && i <= 11 && C2 == true) {str += "억"; C2 = false;}
					if (i >= 12 && C3 == true) {str += "조"; C3 = false;}
					result = str + result;
				}
			}
			result = (EVF.V('CUR') == "KRW") ? " ( 금 " + result + "원 )" : " ( " + result + " " + EVF.V('CUR') +" )";
			EVF.C("bidGuarAmtTxt").setText(result);
		}
		
		// 보증금납부방법(현금, 첨부파일, 전자보증) 선택시
		function setGuarType() {
			if( EVF.V('BID_GUAR_TYPE') == 'E' ) {		// 전자보증
				EVF.V('GUARANTEER', ("${formData.GUARANTEER }" == "") ? '10' : "${formData.GUARANTEER }");
				EVF.V('GUAR_REQ_NUM', "${formData.GUAR_REQ_NUM }");
				EVF.V('GUAR_NUM', "${formData.GUAR_NUM }");
				EVF.C('GUARANTEER').setDisabled(true);
				$("#sp_form3 tr:eq(2)").show();
				$("#sp_form3 tr:eq(3)").show();
			} else {
				EVF.V('GUARANTEER', '');
				EVF.V('GUAR_REQ_NUM', '');
				EVF.V('GUAR_NUM', '');
				EVF.C('GUARANTEER').setDisabled(true);
				$("#sp_form3 tr:eq(2)").hide();
				$("#sp_form3 tr:eq(3)").hide();
			}
		}
		
		//입찰보증 신청
		function doOpenGuar() {
			
			if(!checkTimeToServer(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
				return EVF.alert("SBDI0013_019");
			}
			
			if(EVF.isEmpty(EVF.V('BID_GUAR_AMT')) || Number(EVF.V('BID_GUAR_AMT')) == 0) {
				return EVF.alert("${SBDI0013_007}");
			}
			
			if(EVF.isEmpty(EVF.V('BID_GUAR_TYPE'))) {
				return EVF.alert("${SBDI0013_013}");
			}
			
			if(!EVF.isEmpty(EVF.V('BID_GUAR_TYPE'))) {
				if(EVF.V('BID_GUAR_TYPE') != "E") {
					return EVF.alert("${SBDI0013_008}");
				}
				if(EVF.V('BID_GUAR_TYPE') == "E" && EVF.isEmpty(EVF.V('GUARANTEER'))) {
					return EVF.alert("${SBDI0013_009}");
				}
				
				if(EVF.V('BID_GUAR_TYPE') == "E" && EVF.V('GUARANTEER') == "10") {
					if(EVF.isEmpty(EVF.V('GUAR_NUM'))) {  //증권번호 발급전 상태
						if(EVF.V('INSU_STATUS') == "TA") {
							return EVF.alert("${SBDI0013_010}");
						} else {
							bidGuar_approval();
						}
					} else {  //증권번호 발급된 상태
						if(EVF.V('INSU_STATUS') == "DE") {
							return EVF.alert("${SBDI0013_011}");
						} else if(EVF.V('INSU_STATUS') == "SA") {
							return EVF.alert("${SBDI0013_012}");
						}
					}
				}
			}
		}
		
		//입찰보증 취소
		function doCancelGuar() {
			
			if(!checkTimeToServer(EVF.C("APP_END_DATE").getValue(), EVF.C("APP_END_TIME").getValue(), EVF.C("APP_END_MIN").getValue())) {
				return EVF.alert("SBDI0013_020");
			}
			
			if(EVF.isEmpty(EVF.V('BID_GUAR_AMT')) || Number(EVF.V('BID_GUAR_AMT')) == 0) {
				return EVF.alert("${SBDI0013_007}");
			}
			
			if(EVF.isEmpty(EVF.V('BID_GUAR_TYPE'))) {
				return EVF.alert("${SBDI0013_013}");
			}
			
			if(!EVF.isEmpty(EVF.V('BID_GUAR_TYPE'))) {
				if(EVF.V('BID_GUAR_TYPE') != "E") {
					return EVF.alert("${SBDI0013_014}");
				}
				
				if(EVF.V('BID_GUAR_TYPE') == "E" && EVF.V('GUARANTEER') == "10") {
					if(EVF.isEmpty(EVF.V('GUAR_NUM'))) {  //증권번호 발행 전
						if(EVF.V('INSU_STATUS') == "TA") {
							bidGuar_cancel();
						} else {
							return EVF.alert("${SBDI0013_015}");
						}
					} else {  //증권번호 발행 후
						if(EVF.V('INSU_STATUS') == "DE") {
							return EVF.alert("${SBDI0013_016}");
						} else if(EVF.V('INSU_STATUS') == "SA") {
							bidGuar_delete();
						}
					}
				}
			}
		}
		
		function bidGuar_approval() {
			var store = new EVF.Store();
			
			var formData = {
					BUYER_CD: EVF.C('BUYER_CD').getValue(),
					BID_NUM: EVF.C('BID_NUM').getValue(),
					BID_CNT: EVF.C('BID_CNT').getValue(),
					VENDOR_CD: EVF.C('VENDOR_CD').getValue(),
					BID_GUAR_AMT: EVF.C('BID_GUAR_AMT').getValue(),
					BID_GUAR_TYPE: EVF.C('BID_GUAR_TYPE').getValue(),
					GUARANTEER: EVF.C('GUARANTEER').getValue(),
					GUAR_REQ_NUM: EVF.C('GUAR_REQ_NUM').getValue()
			    };
			
           	
			store.setParameter('guardata',JSON.stringify(formData));
			
			EVF.confirm("보증 신청을 하시겠습니까?", function() {
                   store.doFileUpload(function() {
                       store.load('/nhepro/SCTR/SCTR0011/sctr0011_guarBdhd_approval.so', function () {
                           //EVF.alert("성공적으로 신청하였습니다.");
                           var buyerCd = this.getParameter("buyerCd");
						   var bidNum = this.getParameter("bidNum");
						   var bidCnt = this.getParameter("bidCnt");
						   var vendorCd = this.getParameter("vendorCd");
						   
						   EVF.alert(this.getResponseMessage(), function() {
								var param = {
									'BUYER_CD' : buyerCd,
									'BID_NUM' : bidNum,
									'BID_CNT' : bidCnt,
									'VENDOR_CD': vendorCd,
									'detailView' : false,
									'popupFlag' : true
								};
								document.location.href = '/nhepro/SBDR/SBDI0013/view.so?' + $.param(param);
						   });
                       }, false);
                   });
               })
		}
		
		function bidGuar_cancel() {
			var store = new EVF.Store();
			
			var formData = {
					BUYER_CD: EVF.C('BUYER_CD').getValue(),
					BID_NUM: EVF.C('BID_NUM').getValue(),
					BID_CNT: EVF.C('BID_CNT').getValue(),
					VENDOR_CD: EVF.C('VENDOR_CD').getValue(),
					BID_GUAR_TYPE: EVF.C('BID_GUAR_TYPE').getValue(),
					GUARANTEER: EVF.C('GUARANTEER').getValue(),
					GUAR_REQ_NUM: EVF.C('GUAR_REQ_NUM').getValue()
			    };
			
			store.setParameter('guardata',JSON.stringify(formData));
			
			EVF.confirm("보증취소를 하시겠습니까?", function() {
                store.doFileUpload(function() {
                    store.load('/nhepro/SCTR/SCTR0011/sctr0011_guarBdhd_cancel.so', function () {
                        //EVF.alert("성공적으로 신청하였습니다.");
                 	   var buyerCd = this.getParameter("buyerCd");
					   var bidNum = this.getParameter("bidNum");
					   var bidCnt = this.getParameter("bidCnt");
					   var vendorCd = this.getParameter("vendorCd");
					   
					   EVF.alert(this.getResponseMessage(), function() {
							var param = {
								'BUYER_CD' : buyerCd,
								'BID_NUM' : bidNum,
								'BID_CNT' : bidCnt,
								'VENDOR_CD': vendorCd,
								'detailView' : false,
								'popupFlag' : true
							};
							document.location.href = '/nhepro/SBDR/SBDI0013/view.so?' + $.param(param);
					   });
                    }, false);
                });
            })
		}
		
		function bidGuar_delete() {
			
			var store = new EVF.Store();
			
			var formData = {
					BUYER_CD: EVF.C('BUYER_CD').getValue(),
					BID_NUM: EVF.C('BID_NUM').getValue(),
					BID_CNT: EVF.C('BID_CNT').getValue(),
					VENDOR_CD: EVF.C('VENDOR_CD').getValue(),
					BID_GUAR_TYPE: EVF.C('BID_GUAR_TYPE').getValue(),
					GUARANTEER: EVF.C('GUARANTEER').getValue(),
					GUAR_REQ_NUM: EVF.C('GUAR_REQ_NUM').getValue()
			    };
			
           	
			store.setParameter('guardata',JSON.stringify(formData));
			
			EVF.confirm("전자입찰보증에 대한 정보가 사라집니다.\n보증취소를 하시겠습니까? ", function() {
				store.doFileUpload(function() {
                    store.load('/nhepro/SCTR/SCTR0011/sctr0011_guarNumBdhd_cancel.so', function () {
                 		var buyerCd = this.getParameter("buyerCd");
						var bidNum = this.getParameter("bidNum");
						var bidCnt = this.getParameter("bidCnt");
						var vendorCd = this.getParameter("vendorCd");
						   
						EVF.alert(this.getResponseMessage(), function() {
					    	var param = {
								'BUYER_CD' : buyerCd,
								'BID_NUM' : bidNum,
								'BID_CNT' : bidCnt,
								'VENDOR_CD': vendorCd,
								'detailView' : false,
								'popupFlag' : true
							};
							document.location.href = '/nhepro/SBDR/SBDI0013/view.so?' + $.param(param);
						});
                    }, false);
                });
			})
		}
		
		function doClose() {
			EVF.closeWindow();
		}
		
		function checkTimeToServer(date, time, min) {
			if(!EVF.isEmpty(date) && !EVF.isEmpty(time) && !EVF.isEmpty(min)) {
				var validStartDate = Number(date) + time + min;
				if ("${today}" + "${todayTime}" > validStartDate) {
					return false
				}
			}
			return true;
		}
		
		function openSgic() {
			var url = "${sgicUrl}";
    		window.open(url);
		}
		
	</script>

	<e:window id="SBDI0013" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

		<%-- 신청인 정보 --%>
		<e:buttonBar id="buttonBar" align="right" width="100%" title="${SBDI0013_CAPTION1 }">
	        <c:if test="${param.popupFlag == true}">
	            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
	        </c:if>
		</e:buttonBar>
		
		<e:searchPanel id="form1" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
			<e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
			<e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
			<e:inputHidden id="VENDOR_CD" name="VENDOR_CD" value="${formData.VENDOR_CD}" />
			<e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
			<e:inputHidden id="APPLY_POSSIBLE_FLAG" name="APPLY_POSSIBLE_FLAG" value="${formData.APPLY_POSSIBLE_FLAG}" />
			<e:inputHidden id="APP_ATT_FILE_NUM" name="APP_ATT_FILE_NUM" value="${formData.APP_ATT_FILE_NUM}" />
			<e:inputHidden id="GUAR_ATT_FILE_NUM" name="GUAR_ATT_FILE_NUM" value="${formData.GUAR_ATT_FILE_NUM}" />
			<e:inputHidden id="INSU_STATUS" name="INSU_STATUS" value="${formData.INSU_STATUS}" />
			<e:inputHidden id="APP_END_DATE" name="APP_END_DATE" value="${formData.APP_END_DATE}" />
			<e:inputHidden id="APP_END_TIME" name="APP_END_TIME" value="${formData.APP_END_TIME}" />
			<e:inputHidden id="APP_END_MIN" name="APP_END_MIN" value="${formData.APP_END_MIN}" />
			<!-- 2021.10.22 : 입찰신청취소시 보증신청번호 및 증권번호 체크 -->
			<e:inputHidden id="HD_GUAR_REQ_NUM" name="HD_GUAR_REQ_NUM" value="${formData.GUAR_REQ_NUM}" />
			<e:inputHidden id="HD_GUAR_NUM" name="HD_GUAR_NUM" value="${formData.GUAR_NUM}" />
			
			<e:row>
				<e:label for="VENDOR_NM" title="${form_VENDOR_NM_N}"/>
				<e:field>
					<e:inputText id="VENDOR_NM" name="VENDOR_NM" value="${formData.VENDOR_NM }" width="${form_VENDOR_NM_W}" maxLength="${form_VENDOR_NM_M}" disabled="${form_VENDOR_NM_D}" readOnly="${form_VENDOR_NM_RO}" required="${form_VENDOR_NM_R}" />
				</e:field>
				<e:label for="COMPANY_REG_NO" title="${form_COMPANY_REG_NO_N}"/>
				<e:field>
					<e:inputText id="COMPANY_REG_NO" name="COMPANY_REG_NO" value="${formData.COMPANY_REG_NO }" width="${form_COMPANY_REG_NO_W}" maxLength="${form_COMPANY_REG_NO_M}" disabled="${form_COMPANY_REG_NO_D}" readOnly="${form_COMPANY_REG_NO_RO}" required="${form_COMPANY_REG_NO_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ADDR" title="${form_ADDR_N}"/>
				<e:field>
					<e:inputText id="ADDR" name="ADDR" value="${formData.ADDR }" width="${form_ADDR_W}" maxLength="${form_ADDR_M}" disabled="${form_ADDR_D}" readOnly="${form_ADDR_RO}" required="${form_ADDR_R}" />
				</e:field>
				<e:label for="TEL_NO" title="${form_TEL_NO_N}"/>
				<e:field>
					<e:inputText id="TEL_NO" name="TEL_NO" value="${formData.TEL_NO }" width="${form_TEL_NO_W}" maxLength="${form_TEL_NO_M}" disabled="${form_TEL_NO_D}" readOnly="${form_TEL_NO_RO}" required="${form_TEL_NO_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CEO_USER_NM" title="${form_CEO_USER_NM_N}"/>
				<e:field>
					<e:inputText id="CEO_USER_NM" name="CEO_USER_NM" value="${formData.CEO_USER_NM }" width="${form_CEO_USER_NM_W}" maxLength="${form_CEO_USER_NM_M}" disabled="${form_CEO_USER_NM_D}" readOnly="${form_CEO_USER_NM_RO}" required="${form_CEO_USER_NM_R}" />
				</e:field>
				<e:label for="IRS_NO" title="${form_IRS_NO_N}"/>
				<e:field>
					<e:inputText id="IRS_NO" name="IRS_NO" value="${formData.IRS_NO }" width="${form_IRS_NO_W}" maxLength="${form_IRS_NO_M}" disabled="${form_IRS_NO_D}" readOnly="${form_IRS_NO_RO}" required="${form_IRS_NO_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="VENDOR_PIC_USER_NM" title="${form_VENDOR_PIC_USER_NM_N}"/>
				<e:field>
					<e:inputText id="VENDOR_PIC_USER_NM" name="VENDOR_PIC_USER_NM" value="${formData.VENDOR_PIC_USER_NM }" width="${form_VENDOR_PIC_USER_NM_W}" maxLength="${form_VENDOR_PIC_USER_NM_M}" disabled="${form_VENDOR_PIC_USER_NM_D}" readOnly="${form_VENDOR_PIC_USER_NM_RO}" required="${form_VENDOR_PIC_USER_NM_R}" />
				</e:field>
				<e:label for="VENDOR_PIC_USER_CELL_NUM" title="${form_VENDOR_PIC_USER_CELL_NUM_N}"/>
				<e:field>
					<e:inputText id="VENDOR_PIC_USER_CELL_NUM" name="VENDOR_PIC_USER_CELL_NUM" value="${formData.VENDOR_PIC_USER_CELL_NUM }" width="${form_VENDOR_PIC_USER_CELL_NUM_W}" maxLength="${form_VENDOR_PIC_USER_CELL_NUM_M}" disabled="${form_VENDOR_PIC_CELL_NUM_D}" readOnly="${form_VENDOR_PIC_USER_CELL_NUM_RO}" required="${form_VENDOR_PIC_USER_CELL_NUM_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="VENDOR_PIC_USER_EMAIL" title="${form_VENDOR_PIC_USER_EMAIL_N}"/>
				<e:field colSpan="3">
					<e:inputText id="VENDOR_PIC_USER_EMAIL" name="VENDOR_PIC_USER_EMAIL" value="${formData.VENDOR_PIC_USER_EMAIL }" width="42%" maxLength="${form_VENDOR_PIC_USER_EMAIL_M}" disabled="${form_VENDOR_PIC_USER_EMAIL_D}" readOnly="${form_VENDOR_PIC_USER_EMAIL_RO}" required="${form_VENDOR_PIC_USER_EMAIL_R}" />
					<e:text style="color: red;font-weight: bold;">(담당자 정보는 개인정보 수집·이용 동의서 서명자와 동일)</e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 입찰공고 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0013_CAPTION2 }</div>
		</div>
		<e:searchPanel id="form2" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="ANN_NO" title="${form_ANN_NO_N}"/>
				<e:field>
					<e:inputText id="ANN_NO" name="ANN_NO" value="${formData.ANN_NO }" width="${form_ANN_NO_W}" maxLength="${form_ANN_NO_M}" disabled="${form_ANN_NO_D}" readOnly="${form_ANN_NO_RO}" required="${form_ANN_NO_R}" />
				</e:field>
				<e:label for="ANN_DATE" title="${form_ANN_DATE_N}" />
				<e:field>
					<e:inputText id="ANN_DATE" name="ANN_DATE" value="${formData.ANN_DATE }" width="${form_ANN_DATE_W}" maxLength="${form_ANN_DATE_M}" disabled="${form_ANN_DATE_D}" readOnly="${form_ANN_DATE_RO}" required="${form_ANN_DATE_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ANN_ITEM" title="${form_ANN_ITEM_N}"/>
				<e:field colSpan="3">
					<e:inputText id="ANN_ITEM" name="ANN_ITEM" value="${formData.ANN_ITEM }" width="${form_ANN_ITEM_W}" maxLength="${form_ANN_ITEM_M}" disabled="${form_ANN_ITEM_D}" readOnly="${form_ANN_ITEM_RO}" required="${form_ANN_ITEM_R}" />
				</e:field>
			</e:row>
		</e:searchPanel>

		<%-- 입찰보증금 정보 --%>
		<div class="e-component e-title-container" data-uuid="Title-541-391-560">
			<div class="e-title-bullet-h1"></div>
			<div class="e-title-text">${SBDI0013_CAPTION3 }</div>
		</div>
		<e:searchPanel id="form3" labelWidth="${longLabelWidth}" width="100%" columnCount="2" useTitleBar="false">
			<e:row>
				<e:label for="BID_GUAR_RATE" title="${form_BID_GUAR_RATE_N}" />
				<e:field>
					<e:inputNumber id="BID_GUAR_RATE" name="BID_GUAR_RATE" value='${formData.BID_GUAR_RATE }' align='right' width='${form_BID_GUAR_RATE_W}' required='${form_BID_GUAR_RATE_R }' readOnly='${form_BID_GUAR_RATE_RO }' disabled='${form_BID_GUAR_RATE_D }' visible='${form_BID_GUAR_RATE_V }' decimalPlace="0" />
					<e:text>%</e:text>
				</e:field>
				<e:label for="BID_GUAR_AMT" title="${form_BID_GUAR_AMT_N}" />
				<e:field>
					<e:inputNumber id="BID_GUAR_AMT" name="BID_GUAR_AMT" value='${formData.BID_GUAR_AMT }' align='right' width='${form_BID_GUAR_AMT_W}' required='${form_BID_GUAR_AMT_R }' readOnly='${form_BID_GUAR_AMT_RO }' disabled='${form_BID_GUAR_AMT_D }' visible='${form_BID_GUAR_AMT_V }' decimalPlace="0" onChange="setText"/>
                    <e:inputText id="CUR" name="CUR" value="${formData.CUR }" width="${form_CUR_W}" maxLength="${form_CUR_M}" disabled="${form_CUR_D}" readOnly="${form_CUR_RO}" required="${form_CUR_R}" />
                    <e:text id="bidGuarAmtTxt" style="text-align:left;" width="150px">)</e:text>
					<e:inputText id="VAT_TYPE" name="VAT_TYPE" value="${formData.VAT_TYPE }" width="${form_VAT_TYPE_W}" maxLength="${form_VAT_TYPE_M}" disabled="${form_VAT_TYPE_D}" readOnly="${form_VAT_TYPE_RO}" required="${form_VAT_TYPE_R}" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BID_GUAR_TYPE" title="${form_BID_GUAR_TYPE_N}"/>
				<e:field>
 					<e:select id="BID_GUAR_TYPE" name="BID_GUAR_TYPE" value="${formData.BID_GUAR_TYPE }" options="${bidGuarTypeOptions}" width="${form_BID_GUAR_TYPE_W}" disabled="${form_BID_GUAR_TYPE_D}" readOnly="${form_BID_GUAR_TYPE_RO}" required="${form_BID_GUAR_TYPE_R}" placeHolder="" maskType="${form_BID_GUAR_TYPE_MT}" onChange="setGuarType" />
				</e:field>
				<e:label for="GUAR_ATT_FILE_CNT" title="${form_GUAR_ATT_FILE_CNT_N}"/>
				<e:field>
					<e:search id="GUAR_ATT_FILE_CNT" name="GUAR_ATT_FILE_CNT" value="${formData.GUAR_ATT_FILE_CNT }" width="${form_GUAR_ATT_FILE_CNT_W}" maxLength="${form_GUAR_ATT_FILE_CNT_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'doAttFile' : 'everCommon.blank'}" disabled="${form_GUAR_ATT_FILE_CNT_D}" readOnly="${form_GUAR_ATT_FILE_CNT_RO}" required="${form_GUAR_ATT_FILE_CNT_R}" />
					<e:text>&nbsp;&nbsp;( 입찰보험가입금 납부방법이 '첨부파일'인 경우 )</e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="GUARANTEER" title="${form_GUARANTEER_N}" />
				<e:field colSpan="3">
					<e:select id="GUARANTEER" name="GUARANTEER" value="${formData.GUARANTEER }" options="${guaranteerOptions}" width="${form_GUARANTEER_W}" disabled="${form_GUARANTEER_D}" readOnly="${form_GUARANTEER_RO}" required="${form_GUARANTEER_R}" placeHolder="" maskType="${form_GUARANTEER_MT}" />
					<e:text>&nbsp;</e:text>
					<e:button id="OpenGuar" name="OpenGuar" label="${OpenGuar_N }" disabled="${OpenGuar_D }" visible="${OpenGuar_V}" onClick="doOpenGuar" />
					<e:button id="CancelGuar" name="CancelGuar" label="${CancelGuar_N }" disabled="${CancelGuar_D }" visible="${CancelGuar_V}" onClick="doCancelGuar" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="GUAR_REQ_NUM" title="${form_GUAR_REQ_NUM_N}"/>
				<e:field>
					<e:inputText id="GUAR_REQ_NUM" name="GUAR_REQ_NUM" value="${formData.GUAR_REQ_NUM }" width="${form_GUAR_REQ_NUM_W}" maxLength="${form_GUAR_REQ_NUM_M}" disabled="${form_GUAR_REQ_NUM_D}" readOnly="${form_GUAR_REQ_NUM_RO}" required="${form_GUAR_REQ_NUM_R}" />
				</e:field>
				<e:label for="GUAR_NUM" title="${form_GUAR_NUM_N}" />
				<e:field>
					<e:inputText id="GUAR_NUM" name="GUAR_NUM" value="${formData.GUAR_NUM }" width="${form_GUAR_NUM_W}" maxLength="${form_GUAR_NUM_M}" disabled="${form_GUAR_NUM_D}" readOnly="${form_GUAR_NUM_RO}" required="${form_GUAR_NUM_R}" style="${formData.GUAR_NUM == null ? '' : 'color:#FF0000;'}" onClick="${formData.GUAR_NUM == null ? '' : 'openSgic'}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="APP_ATT_FILE_CNT" title="${form_APP_ATT_FILE_CNT_N}"/>
 				<e:field>
					<e:search id="APP_ATT_FILE_CNT" name="APP_ATT_FILE_CNT" value="${formData.APP_ATT_FILE_CNT }" width="${form_APP_ATT_FILE_CNT_W}" maxLength="${form_APP_ATT_FILE_CNT_M}" onIconClick="${(!param.detailView || param.detailView == null) ? 'doAppAttFile' : 'everCommon.blank'}" disabled="${form_APP_ATT_FILE_CNT_D}" readOnly="${form_APP_ATT_FILE_CNT_RO}" required="${form_APP_ATT_FILE_CNT_R}" />
				</e:field>
				<e:label for="APP_DATE" title="${form_APP_DATE_N}" />
				<e:field>
					<e:inputText id="APP_DATE" name="APP_DATE" value="${formData.APP_DATETIME }" width="${form_APP_DATE_W}" maxLength="${form_APP_DATE_M}" disabled="${form_APP_DATE_D}" readOnly="${form_APP_DATE_RO}" required="${form_APP_DATE_R}" style="${imeMode}" maskType="${form_APP_DATE_MT}"/>
				</e:field>
			</e:row>
		</e:searchPanel>
		<br><br>
		<e:text width="100%" style="position: relative; left: 160px; padding: 0; font-size: 11pt; font-weight: bold;">본인은 위의 번호로 공고(지명통지)한 귀 회의 일반(제한·지명)경쟁입찰에 참가하고자</e:text>
		<br>
		<e:text width="100%" style="position: relative; left: 160px; padding: 0; font-size: 11pt; font-weight: bold;">귀 회에서 정한 공사(물품구매·기술용역)입찰유의서 및 입찰공고 사항을 모두 승낙하고</e:text>
		<br>
		<e:text width="100%" style="position: relative; left: 160px; padding: 0; font-size: 11pt; font-weight: bold;">별첨서류를 첨부하여 입찰참가 신청을 합니다.</e:text>
		<br><br><br>
		<e:text width="100%" style="text-align: center; font-size: 11pt; font-weight: bold;">신청인 : ${formData.VENDOR_NM }</e:text>
		<br><br>
		<e:text width="100%" style="text-align: center; font-size: 11pt; font-weight: bold;">${formData.TODAY_YEAR }년 ${formData.TODAY_MONTH }월 ${formData.TODAY_DAY }일</e:text>
		<br>
		
		<e:buttonBar id="buttonBar1" align="right" width="100%" title="${form_CAPTION_N }">
			<e:button id="Submit" name="Submit" label="${Submit_N }" disabled="${Submit_D }" visible="${Submit_V}" onClick="doSubmit" />
			<e:button id="CancelReq" name="CancelReq" label="${CancelReq_N}" onClick="doCancelReq" disabled="${CancelReq_D}" visible="${CancelReq_V}"/>
		</e:buttonBar>
		
        <form id='reqForm' name='reqForm' method='post' action="/MagicLine4Web/ML4Web/jcaosCheck.jsp">
            <input type="hidden" id="signData" name="signData" value=""/>
            <input type="hidden" id="signedData" name="signedData"/>
            <input type="hidden" id="vidRandom" name="vidRandom"/>
            <input type="hidden" id="vidType" name="vidType" value="client"/>
            <input type="hidden" id="idn" name="idn" value="${formData.IRS_NO}"/>
        </form>

        <div id="dscertContainer">
            <iframe id="dscert" name="dscert" src="" width="100%" height="100%" frameborder="0" allowTransparency="true" style="position:fixed;z-index:100010;top:0px;left:0px;width:100%;height:100%;"></iframe>
        </div>

	</e:window>
</e:ui>