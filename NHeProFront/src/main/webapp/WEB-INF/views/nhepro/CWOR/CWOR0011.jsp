<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script>
        var grid;
        var baseUrl = "/nhepro/CWOR/";
        var consultContentsUrl = '';
        var detailView = '';
        var gateCd = '';
        var buyerCd = '';
        var appDocNum = '';
        var appDocCnt = '';
        var docType = '';
        var screen_id;

        function init() {
			
            window.focus();
			
            grid = EVF.C("grid");

            grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);		            // [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
			
            grid.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });
			
            var editor = EVF.C('DOC_CONTENTS').getInstance();
            editor.config.contentsCss  = "/css/richText.css";
            editor.config.allowedContent = true;
			
            EVF.V("BUYER_CD",    "${param.buyerCd}");
            EVF.V("APP_DOC_NUM", "${param.appDocNum}");
            EVF.V("APP_DOC_CNT", "${param.appDocCnt}");
            EVF.V("DOC_TYPE",    "${param.docType}");
            EVF.V("AUTH_TYPE",   "${param.authType}");
			
            doSearch();
        }

        function doSearch() {

            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + 'cwor0011_doSearch.so', function() {
                if(grid.getRowCount() == 0){
                    EVF.alert("${msg.M0002 }");
                } else {
                    //var data = this.data.formData;
                    //if(data.ATT_FILE_NUM) {
                    //	EVF.C('ATT_FILE_NUM').getUploadedFileInfo(data.DOC_TYPE, data.ATT_FILE_NUM);
                    //}
                    //2021.03.25 수정 가능하도록 변경
                    //EVF.C('ATT_FILE_NUM').setReadOnly(true);
                    consultContentsUrl = this.getParameter('consultContentsUrl');
                    screen_id = consultContentsUrl.substring(consultContentsUrl.indexOf('?')+11 ,consultContentsUrl.length );
                    consultContentsUrl = consultContentsUrl.substring(0, consultContentsUrl.indexOf('?')+1);
                    detailView = this.getParameter('detailView');
                    gateCd     = this.getParameter('gateCd');
                    buyerCd    = this.getParameter('buyerCd');
                    appDocNum  = this.getParameter('appDocNum');
                    appDocCnt  = this.getParameter('appDocCnt');
                    docType    = EVF.V("DOC_TYPE");
                }
            });
        }
		
        //2024-03-27
        //우선협상선정결과 결재 시 결재요청문서 상세보기 클릭 시 해당 입찰 담당자가 아닌 결재자는 종합낙찰제 버튼이 비활성화되어 종합낙찰제 결과 등록 화면을 볼 수 있는 방법이 없어서 버튼 활성화되도록 처리를 위한 parameter 추가
        //단, 결재요청문서에서 해당 화면 오픈시에만 버튼 활성화
        function openDocDetail() {
            var store = new EVF.Store();
            store.load(baseUrl + 'cwor0011_documentRead.so', function() {
                everPopup.openModalPopup(consultContentsUrl, 1200, 800, { detailView : detailView, gateCd : gateCd, buyerCd : buyerCd, appDocNum : appDocNum, appDocCnt : appDocCnt, SCREEN_ID : screen_id, APP_DOC_NUM : appDocNum, APP_DOC_CNT : appDocCnt, DOC_TYPE : docType });
            });
        }

        function onCancel() {

            EVF.V("SUBJECT", EVF.V("SUBJECT") + ' ');
            EVF.V("SUBJECT", EVF.V("SUBJECT").trim());
            EVF.confirm("${CWOR0011_0001 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.load(baseUrl + 'cwor0011_doCancel.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        opener.doSearch();
                        EVF.closeWindow();
                    });
                });
            });
        }

        function onApproval() {
            var param = {
                signStatus : "E",
                appDocNum : EVF.V("APP_DOC_NUM"),
                appDocCnt : EVF.V("APP_DOC_CNT")
            };
            everPopup.openApprovalRemarkPopup(param);
        }

        function onReject() {
            var param = {
                signStatus: "R",
                appDocNum : EVF.V("APP_DOC_NUM"),
                appDocCnt : EVF.V("APP_DOC_CNT")
            };
            everPopup.openApprovalRemarkPopup(param);
        }

        function doApprovalOrReject(data) {

            var store = new EVF.Store();
            store.setParameter('SIGN_STATUS', data.signStatus);
            store.setParameter('SIGN_RMK', data.signRmk);
            store.doFileUpload(function() {
	            store.load(baseUrl + 'cwor0011_doApprovalOrReject.so', function() {
	                EVF.alert(this.getResponseMessage(), function() {
	                	/** 20.12.28 농협정보 요청
	                	 *  문서유형 예정가격(ESTM) 결재 완료 시 예정가격 확정 팝업 오픈
	                	 */
	                	var docType = EVF.V("DOC_TYPE");
	                	if(docType == "ESTM") {
	                		doSearchESTM();
	                	} else {
	                		onClose();                		
	                	}
	                });
	            });
            });
		}
		
		function checkVlidation() {
		
		    var mySignStatus = EVF.V("MY_SIGN_STATUS");
		    if (mySignStatus === 'E') {
		        EVF.alert('Approved Item');
		        return false;
		    }
		    if (mySignStatus === 'R') {
		        EVF.alert('Rejected Item');
		        return false;
		    }
		}
		
		function onClose() {
		    if (opener !== undefined && opener.doSearch !== undefined) {
		        opener.doSearch();
		    }
		    EVF.closeWindow();
		}
		
		function doSearchESTM() {
			
			var store = new EVF.Store();
			store.setParameter('bidStatus', '0');
            store.setParameter('docNum', 	EVF.V("APP_DOC_NUM"));
            store.setParameter('docCnt', 	EVF.V("APP_DOC_CNT"));
            store.load(baseUrl + 'cwor0011_doSearchESTM.so', function() {
            	var buyerCd    = this.getParameter("buyerCd");
            	var estmType   = this.getParameter("estmType");
    			var bidNum 	   = this.getParameter("bidNum");
    			var bidCnt 	   = this.getParameter("bidCnt");
    			var signStatus = this.getParameter("signStatus");
    			var bidStatus  = this.getParameter("bidStatus");
    			var estmUserID = this.getParameter("estmUserID");
    			
    			if(signStatus == "E") {
    				var detailView = false;
    				if(bidStatus == "1") {
    					detailView = true;
    				}
    				
    				if(estmUserID != "${ses.userId}") {
    					detailView = true;
    				}
    				
	    			var param = {
	  					  BID_NUM  : bidNum
	  					, BID_CNT  : bidCnt
	  					, BUYER_CD : buyerCd
	  					, appDocNum : EVF.V("APP_DOC_NUM")
	  					,'detailView': detailView
	  				};
	  			
		  			var screenId = '';
		  			if (estmType == 'SE') {
		  				screenId = 'CBDI0052';
		  				everPopup.openPopupByScreenId(screenId, 1000, 400, param);
		  			} else {
		  				screenId = 'CBDI0053';
		  				everPopup.openPopupByScreenId(screenId, 1000, 480, param);
		  			}
    			} else {
    				onClose();
    			}
            });
		}
</script>

<e:window id="CWOR0011" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

<e:buttonBar id="buttonBarT" title="${form_GeneralInfoLabel_N }" align="right" width="100%">
<c:if test="${param.sendBox and param.signStatus eq 'P' }">
    <e:button id="onCancel" name="onCancel" label="${onCancel_N }" disabled="${onCancel_D }" onClick="onCancel" />
</c:if>
<c:if test="${!param.sendBox and param.signStatus eq 'P' }">
    <e:button id="onApproval" name="onApproval" label="${onApproval_N }" disabled="${onApproval_D }" onClick="onApproval" />
    <e:button id="onReject" name="onReject" label="${onReject_N }" disabled="${onReject_D }" onClick="onReject" />
</c:if>
    <e:button id="openDocDetail" name="openDocDetail" label="${openDocDetail_N }" disabled="${openDocDetail_D }" onClick="openDocDetail" />
</e:buttonBar>

<e:searchPanel id="form" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
	<e:inputHidden id="DOC_TYPE"        name="DOC_TYPE"			value="${formData.DOC_TYPE }"/>
	<e:inputHidden id="BUYER_CD"        name="BUYER_CD"         value="${formData.BUYER_CD }"/>
	<e:inputHidden id="APP_DOC_CNT"     name="APP_DOC_CNT"		value="${formData.APP_DOC_CNT }"/>
	<e:inputHidden id="MY_SIGN_STATUS"  name="MY_SIGN_STATUS"	value="${formData.MY_SIGN_STATUS }"/>
	<e:inputHidden id="SIGN_STATUS"     name="SIGN_STATUS"		value="${formData.SIGN_STATUS }"/>
	<e:inputHidden id="DOC_TITLE"       name="DOC_TITLE"        value="${formData.DOC_TITLE }"/>
	<e:inputHidden id="AUTH_TYPE"       name="AUTH_TYPE"		value="${formData.AUTH_TYPE }"/> <!-- 2021.07.26 추가 -->
	
    <e:row>
        <e:label for="APP_DOC_NUM" title="${form_APP_DOC_NUM_N}" />
        <e:field>
            <e:inputText id="APP_DOC_NUM" name="APP_DOC_NUM" value="${formData.APP_DOC_NUM }" width="${form_APP_DOC_NUM_W }" maxLength="${form_APP_DOC_NUM_M }" required="${form_APP_DOC_NUM_R }" readOnly="${form_APP_DOC_NUM_RO }" disabled="${form_APP_DOC_NUM_D}" visible="${form_APP_DOC_NUM_V}"  maskType="${form_APP_DOC_NUM_MT}" />
        </e:field>
        <e:label for="DOC_TYPE_NM" title="${form_DOC_TYPE_NM_N}" />
        <e:field>
            <e:inputText id="DOC_TYPE_NM" name="DOC_TYPE_NM" value="${formData.DOC_TYPE_NM }" width="${form_DOC_TYPE_NM_W }" maxLength="${form_DOC_TYPE_NM_M }" required="${form_DOC_TYPE_NM_R }" readOnly="${form_DOC_TYPE_NM_RO }" disabled="${form_DOC_TYPE_NM_D}" visible="${form_DOC_TYPE_NM_V}"  maskType="${form_DOC_TYPE_NM_MT}" />
        </e:field>
    </e:row>
    <e:row>
        <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
        <e:field colSpan="3">
            <e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT }" width="${form_SUBJECT_W }" maxLength="${form_SUBJECT_M }" required="${form_SUBJECT_R }" readOnly="${form_SUBJECT_RO }" disabled="${form_SUBJECT_D}" visible="${form_SUBJECT_V}"  maskType="${form_SUBJECT_MT}" />
        </e:field>
    </e:row>
    <e:row>
        <e:label for="REG_USER_NM" title="${form_REG_USER_NM_N}" />
        <e:field>
            <e:inputText id="REG_USER_NM" name="REG_USER_NM" value="${formData.REG_USER_NM }" width="${form_REG_USER_NM_W }" maxLength="${form_REG_USER_NM_M }" required="${form_REG_USER_NM_R }" readOnly="${form_REG_USER_NM_RO }" disabled="${form_REG_USER_NM_D}" visible="${form_REG_USER_NM_V}"  maskType="${form_REG_USER_NM_MT}" />
        </e:field>
        <e:label for="REG_DATE" title="${form_REG_DATE_N}"></e:label>
        <e:field>
            <e:inputText id="REG_DATE" name="REG_DATE" value="${formData.REG_DATE }" width="${form_REG_DATE_W }" maxLength="${form_REG_DATE_M }" required="${form_REG_DATE_R }" readOnly="${form_REG_DATE_RO }" disabled="${form_REG_DATE_D }" visible="${form_REG_DATE_V}"  maskType="${form_REG_DATE_MT}" />
        </e:field>
    </e:row>
    <e:row>
        <e:label for="DOC_CONTENTS" title="${form_DOC_CONTENTS_N}" />
        <e:field colSpan="3">
			<e:inputHidden id="CONTENTS_TEXT_NUM" name="CONTENTS_TEXT_NUM" value="${formData.CONTENTS_TEXT_NUM }"/>
            <e:richTextEditor id="DOC_CONTENTS" name="DOC_CONTENTS" value="${formData.DOC_CONTENTS }" width="${form_DOC_CONTENTS_W }" height="440px" required="${form_DOC_CONTENTS_R }" readOnly="${(!param.sendBox and param.signStatus eq 'P')?false:true}" disabled="${form_DOC_CONTENTS_D }" useToolbar="${!param.detailView}" style="${imeMode }" />
        </e:field>
    </e:row>
    <e:row>
        <e:label for="ATT_FILE_NUM" title="${form_ATT_FILE_NUM_N}" />
        <e:field colSpan="3">
            <e:fileManager id="ATT_FILE_NUM" name="ATT_FILE_NUM" fileId="${formData.ATT_FILE_NUM}" downloadable="true" bizType="APP" height="120px" readOnly="${(!param.sendBox and param.signStatus eq 'P')?false:true}" onSuccess="onSuccess" required="${form_ATT_FILE_NUM_R}"/>
       </e:field>
    </e:row>
</e:searchPanel>

<e:buttonBar id="buttonBarB" title="${form_ApprovalPathList_N }" align="right" width="100%"> </e:buttonBar>

<e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}"/>

</e:window>
</e:ui>

