<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">
    	var grid;
        var baseUrl = "/nhepro/CETR/";

        function init() {
        	
        	grid = EVF.C("grid");

            grid.setProperty("shrinkToFit", true);		            // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty("panelVisible", ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty("enterToNextRow", ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty("multiSelect", ${param.detailView == true ? false : multiSelect});		// [선택] 컬럼의 사용여부를 지정한다. [true/false]
            grid.setProperty("singleSelect", ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
        	
            if( ${!param.detailView} ){
    	        grid.delRowEvent(function() {
    	            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
    				grid.delRow();
    			});
            }
            
            // 고객사코드, 부서코드 중복 체크
            grid.dupRowEvent(function(rowId) {
    			EVF.alert(rowId);
            }, ["BUYER_CD", "DEPT_CD"]);
            
            var PH_FLAG		= EVF.V("PH_FLAG");
            var PROGRESS_CD = EVF.V("ORG_PROGRESS_CD");
            var REQ_COM_CD  = EVF.V("REQ_COM_CD");
            var REQ_DEPT_CD = EVF.V("DEPT_CD");
            if( PROGRESS_CD == "" ) {
            	EVF.C("doSave").setVisible(true); 			// 저장
            	EVF.C("doSaveReq").setVisible(true); 		// 요청
                EVF.C("doDelete").setVisible(false); 		// 삭제
                EVF.C("getBuyerCd").setVisible(true); 		// 대상고객조회
                EVF.C("openCustomer").setVisible(true); 	// 대상고객 및 부서조회
                
                EVF.C("doSave").setDisabled(false);
                EVF.C("doSaveReq").setDisabled(false);
                EVF.C("getBuyerCd").setDisabled(false);
                EVF.C("openCustomer").setDisabled(false);
            }
            else if( PROGRESS_CD == "100" ) {
            	EVF.C("doSave").setVisible(true); 			// 저장
            	EVF.C("doSaveReq").setVisible(true); 		// 요청
                EVF.C("doDelete").setVisible(true); 		// 삭제
                EVF.C("getBuyerCd").setVisible(true); 		// 대상고객조회
                EVF.C("openCustomer").setVisible(true); 	// 대상고객 및 부서조회
                
                EVF.C("doSave").setDisabled(false);
                EVF.C("doSaveReq").setDisabled(false);
                EVF.C("doDelete").setDisabled(false);
                EVF.C("getBuyerCd").setDisabled(false);
                EVF.C("openCustomer").setDisabled(false);
            }
            else if( PROGRESS_CD == "200" || PROGRESS_CD == "300" || PROGRESS_CD == "400" || PROGRESS_CD == "500" ) {
            	EVF.C("doSave").setVisible(false); 			// 저장
            	EVF.C("doSaveReq").setVisible(false); 		// 요청
            	if( PROGRESS_CD == "200" ) {
                	if( REQ_COM_CD == "${ses.companyCd}" && (REQ_DEPT_CD == "" || REQ_DEPT_CD == "${ses.deptCd}") ) {
                        EVF.C("doDelete").setVisible(true); 	// 삭제
                        EVF.C("doDelete").setDisabled(false);	// 삭제
                	} else {
                        EVF.C("doDelete").setVisible(false); 	// 삭제
                	}
            	} else {
                    EVF.C("doDelete").setVisible(false); 	// 삭제
            	}
                EVF.C("getBuyerCd").setVisible(false); 		// 대상고객조회
                EVF.C("openCustomer").setVisible(false); 	// 대상고객 및 부서조회
				
                // 회신여부=1
            	if( PH_FLAG == "1" ) {
                    // 요청자 회사 및 부서가 아니면 조치정보 등록 가능하도록 함
                    if( (REQ_COM_CD != "${ses.companyCd}" && REQ_DEPT_CD != "${ses.deptCd}")
                     || (REQ_COM_CD == "${ses.companyCd}" && REQ_DEPT_CD != "${ses.deptCd}") ) {
                    	if( EVF.V("VC_SQ") != "" ) {
                        	EVF.C('PROGRESS_CD').removeOption('100');
                        	EVF.C('PROGRESS_CD').removeOption('200');
                        	
                            EVF.C("PROGRESS_CD").setReadOnly(false);
                            EVF.C("PROGRESS_CD").setRequired(true);
                            EVF.C("DF_RMK").setReadOnly(false);
                            EVF.C("DS_ATTACH_FILE_NO").setReadOnly(false);
                        	
                        	if( PROGRESS_CD == "200" || PROGRESS_CD == "300" ) {
                            	EVF.C('PROGRESS_CD').setValue("300");
                            	EVF.C("DF_RMK").setRequired(false); // 접수(300)인 경우 답변내용 필수 제외
                        	} else {
                                EVF.C("DF_RMK").setRequired(true);
                        	}
        					
                            EVF.C("doSave").setVisible(true);
                            EVF.C("doSave").setDisabled(false);
                            if( PROGRESS_CD == "500" ) {
                                EVF.C("doSave").setVisible(false);
                                
                                EVF.C("PROGRESS_CD").setReadOnly(true);
                                EVF.C("DF_RMK").setReadOnly(true);
                                EVF.C("DS_ATTACH_FILE_NO").setReadOnly(true);
                            }
                    	}
                    }
            	}
            }
            
            if( "${formData.VC_NO}" != "" ) {
            	doSearch();
            }
            EVF.C("doClose").setDisabled(false);
        }
		
        function onChangePROGRESS_CD() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
            var orgValue = EVF.V("ORG_PROGRESS_CD");
			
            if(value != "") {
            	if(value == "300") { // 접수(300)인 경우 답변내용 필수 제외
                	EVF.C("DF_RMK").setRequired(false);
            	} else {
                	EVF.C("DF_RMK").setRequired(true);
            	}
            }
            if(value != "" && Number(value) < Number(orgValue)) {
                EVF.alert("${CETR0051_001}", function () {
                    EVF.V("PROGRESS_CD", orgValue);
                });
            }
        }
		
        // 회신여부 변경시
        function onChangePH_FLAG() {
            var C = this;
            var id = C.getID();
            var value = C.getValue();
			
            if(value == "1") {
                EVF.C("PH_DATE").setRequired(true);
                EVF.C("PH_DATE").setDisabled(false);
            } else {
                EVF.C("PH_DATE").setValue("");
                EVF.C("PH_DATE").setRequired(false);
                EVF.C("PH_DATE").setDisabled(true);
            }
        }
        
        function doSearch() {
        	var store = new EVF.Store();
	        store.setGrid([grid]);
	        store.load(baseUrl + 'cetr0051_doSearchVOCD.so', function() {
	        	if (grid.getRowCount() > 0) { grid.checkAll(true); }
	        });
        }
        
        // 요청
        function doSaveReq() {
            var store = new EVF.Store();

            if (!store.validate()) { return; }
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
            
            EVF.confirm("${msg.M0053}", function () {
                store.doFileUpload(function() {
                	store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "cetr0051_doSaveReq.so", function() {
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                            }
                            doClose();
                        });
                    });
                });
            });
        }
		
        // 임시저장
        function doSave() {
            var store = new EVF.Store();

            if (!store.validate()) { return; }
            if (grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
            if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }
            
            var detailView  = false;
            var buttonView  = false;
            var PROGRESS_CD = EVF.V("PROGRESS_CD");
            if( PROGRESS_CD == "200" || PROGRESS_CD == "300" || PROGRESS_CD == "400" || PROGRESS_CD == "500" ) {
                detailView = true;
                buttonView = false;
            } else {
                detailView = false;
                buttonView = true;
            }
            
            EVF.confirm("${msg.M0021}", function () {
                store.doFileUpload(function() {
                	store.setGrid([grid]);
                    store.getGridData(grid, "sel");
                    store.load(baseUrl + "cetr0051_doSave.so", function() {
                    	var vcNum = this.getParameter('VC_NO');
                    	var vcSq  = this.getParameter('VC_SQ');
                    	var param = {
                                VC_NO: vcNum,
                                VC_SQ: vcSq,
                                detailView: detailView,
                                buttonView: buttonView
                            };
                    	
                        EVF.alert(this.getResponseMessage(), function() {
                            if(opener) {
                                opener.doSearch();
                            }
                            if(PROGRESS_CD == "500") {
                            	doClose();
                            } else {
                                location.href = baseUrl + 'CETR0051/view.so?' + $.param(param);
                            }
                        });
                    });
                });
            });
        }
		
        // 삭제
        function doDelete() {
            EVF.confirm("삭제시 선택한 요청번호로 묶인 업무연락 전체가 삭제됩니다.\n업무연락을 삭제하시겠습니까?", function () {
                var store = new EVF.Store();
                store.load(baseUrl + "cetr0051_doDelete.so", function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        if(opener) {
                            opener.doSearch();
                        }
                        doClose();
                    });
                });
            });
        }
        
        // 고객사만 조회
        function getBuyerCd() {
			var param = {
				callBackFunction : "setBuyerCd"
			};
			everPopup.openCommonPopup(param, 'MP0020');
		}
		function setBuyerCd(jsonData) {
			for( idx in jsonData ){
           		var addParam = [{
	        			"IRS_NUM" : jsonData[idx].IRS_NUM,
	        			"BUYER_CD": jsonData[idx].CUST_CD,
	        			"BUYER_NM": jsonData[idx].CUST_NM
        			}];
            	grid.addRow(addParam);
           	}
		}
		
		// 고객사 및 부서 조회
        function openCustomer() {
        	var param = {
    				'callBackFunction': 'callBackCUST_CD',
    				'RELAT_YN': '0',	//농협(0), 비농협(1) : NH0005
    				'CORP_TYPE': '',	//지역농축협(2) : NH0002
    				'READONLY': 'N',	//팝업 조회조건 변경불가
    				'multiYN': 'Y',		//멀티팝업여부
    				'viewFlag': 'VC',	//화면구분(VC:고객VOC, 고객소통)
    				'detailView': false
    		};
    		everPopup.openPopupByScreenId("CCDU0010", 1000, 700, param);
        }
        function callBackCUST_CD(jsonData) {
        	for( idx in jsonData ){
           		var addParam = [{
	        			"IRS_NUM" : jsonData[idx].IRS_NUM,
	        			"BUYER_CD": jsonData[idx].CUST_CD,
	        			"BUYER_NM": jsonData[idx].CUST_NM,
	        			"DEPT_CD" : jsonData[idx].DEPT_CD,
	        			"DEPT_NM" : jsonData[idx].DEPT_NM
        			}];
            	grid.addRow(addParam);
           	}
        }
        
        function doClose() {
            EVF.closeWindow();
        }
    </script>

    <e:window id="CETR0051" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
    	<e:inputHidden id="VC_SQ" name="VC_SQ" value="${formData.VC_SQ}"/> <!-- 요청항번 -->
    	<e:inputHidden id="COMPANY_CD" name="COMPANY_CD" value="${formData.COMPANY_CD}"/> <!-- 요청자 고객코드 -->
    	<e:inputHidden id="DEPT_CD" name="DEPT_CD" value="${formData.DEPT_CD}"/> <!-- 요청자 부서코드 -->
        <e:inputHidden id="REQ_USER_ID" name="REQ_USER_ID" value="${formData.REQ_USER_ID}"/> <!-- 요청자ID -->
        <e:inputHidden id="RECV_USER_ID" name="RECV_USER_ID" value="${formData.RECV_USER_ID}"/> <!-- 접수자ID -->
        <e:inputHidden id="DS_USER_ID" name="DS_USER_ID" value="${formData.DS_USER_ID}"/> <!-- 답변자ID -->
        <e:inputHidden id="ORG_PROGRESS_CD" name="ORG_PROGRESS_CD" value="${formData.ORG_PROGRESS_CD}"/>
    	<e:inputHidden id="VOC_TYPE_NM" name="VOC_TYPE_NM" value="${formData.VOC_TYPE_NM}"/> <!-- VOC/업무연락 유형 -->
		
        <e:searchPanel id="form1" title="${form_CAPTION_N}" labelWidth="120px" labelAlign="${labelAlign}" columnCount="2" useTitleBar="false" onEnter="">
            <!-- 요청정보 -->
            <e:row>
                <e:label for="VC_NO" title="${form_VC_NO_N}" />
                <e:field>
                    <e:inputText id="VC_NO" name="VC_NO" value="${formData.VC_NO}" width="${form_VC_NO_W}" maxLength="${form_VC_NO_M}" disabled="${form_VC_NO_D}" readOnly="${form_VC_NO_RO}" required="${form_VC_NO_R}"  maskType="${form_VC_NO_MT}" />
                </e:field>
                <e:label for="REQ_COM_NM" title="${form_REQ_COM_NM_N}" />
                <e:field>
                    <e:inputText id="REQ_COM_CD" name="REQ_COM_CD" value="${formData.REQ_COM_CD}" width="26%" maxLength="${form_REQ_COM_CD_M}" disabled="${form_REQ_COM_CD_D}" readOnly="${form_REQ_COM_CD_RO}" required="${form_REQ_COM_CD_R}" style="${imeMode}" maskType="${form_REQ_COM_CD_MT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="REQ_COM_NM" name="REQ_COM_NM" value="${formData.REQ_COM_NM}" width="68%" maxLength="${form_REQ_COM_NM_M}" disabled="${form_REQ_COM_NM_D}" readOnly="${form_REQ_COM_NM_RO}" required="${form_REQ_COM_NM_R}" style="${imeMode}" maskType="${form_REQ_COM_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="REQ_USER_NM" title="${form_REQ_USER_NM_N}" />
                <e:field>
                    <e:inputText id="REQ_USER_NM" name="REQ_USER_NM" value="${formData.REQ_USER_NM}" width="26%" maxLength="${form_REQ_USER_NM_M}" disabled="${form_REQ_USER_NM_D}" readOnly="${form_REQ_USER_NM_RO}" required="${form_REQ_USER_NM_R}" style="${imeMode}" maskType="${form_REQ_USER_NM_MT}"/>
                    <e:text>/</e:text>
                    <e:inputText id="REQ_DATE" name="REQ_DATE" value="${formData.REQ_DATE}" width="68%" maxLength="${form_REQ_DATE_M}" disabled="${form_REQ_DATE_D}" readOnly="${form_REQ_DATE_RO}" required="${form_REQ_DATE_R}" style="${imeMode}" maskType="${form_REQ_DATE_MT}"/>
                </e:field>
                <e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
                <e:field>
                    <e:inputText id="DEPT_NM" name="DEPT_NM" value="${formData.DEPT_NM}" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="VOC_TYPE" title="${form_VOC_TYPE_N}"/>
                <e:field>
                    <e:select id="VOC_TYPE" name="VOC_TYPE" value="${formData.VOC_TYPE}" options="${vocTypeOptions}" width="${form_VOC_TYPE_W}" disabled="${form_VOC_TYPE_D}" readOnly="${form_VOC_TYPE_RO}" required="${form_VOC_TYPE_R}" placeHolder="" maskType="${form_VOC_TYPE_MT}" />
                </e:field>
                <e:label for="PH_FLAG" title="${form_PH_FLAG_N}"/>
				<e:field>
					<e:select id="PH_FLAG" name="PH_FLAG" value="${formData.PH_FLAG}" options="${phFlagOptions}" width="26%" disabled="${form_PH_FLAG_D}" readOnly="${form_PH_FLAG_RO}" required="${form_PH_FLAG_R}" placeHolder="" maskType="${form_PH_FLAG_MT}" onChange="onChangePH_FLAG" />
					<e:text>, 회신요청일 : </e:text>
                    <e:inputDate id="PH_DATE" name="PH_DATE" value="${formData.PH_DATE}" width="${inputDateWidth}" datePicker="true" required="${form_PH_DATE_R}" disabled="${form_PH_DATE_D}" readOnly="${form_PH_DATE_RO}" />
				</e:field>
            </e:row>
            <e:row>
	            <e:label for="SUBJECT" title="${form_SUBJECT_N}" />
				<e:field colSpan="3">
					<e:inputText id="SUBJECT" name="SUBJECT" value="${formData.SUBJECT}" width="${form_SUBJECT_W}" maxLength="${form_SUBJECT_M}" disabled="${form_SUBJECT_D}" readOnly="${form_SUBJECT_RO}" required="${form_SUBJECT_R}" style="${imeMode}" maskType="${form_SUBJECT_MT}"/>
				</e:field>
			</e:row>
            <e:row>
                <e:label for="REQ_RMK" title="${form_REQ_RMK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="REQ_RMK" name="REQ_RMK" value="${formData.REQ_RMK}" height="90px" width="${form_REQ_RMK_W}" maxLength="${form_REQ_RMK_M}" disabled="${form_REQ_RMK_D}" readOnly="${form_REQ_RMK_RO}" required="${form_REQ_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="ATTACH_FILE_NO" title="${form_ATTACH_FILE_NO_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="ATTACH_FILE_NO" name="ATTACH_FILE_NO" readOnly="${form_ATTACH_FILE_NO_RO}"  fileId="${formData.ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="MP" height="90px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
                </e:field>
            </e:row>
        </e:searchPanel>
        
        <!-- Button 영역 -->
	  	<e:buttonBar title="업무공유 대상고객" width="100%" align="right">
			<e:button id="getBuyerCd" name="getBuyerCd" label="${getBuyerCd_N}" onClick="getBuyerCd" disabled="${getBuyerCd_D}" visible="${getBuyerCd_V}"/>
	    	<e:button id="openCustomer" name="openCustomer" label="${openCustomer_N}" onClick="openCustomer" disabled="${openCustomer_D}" visible="${openCustomer_V}"/>
	    </e:buttonBar>
        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />
		
		<e:buttonBar title="회신정보 (회신여부가 'N'인 경우 작성하지 않습니다)" width="100%" align="right" />
		<e:searchPanel id="form2" title="${form_CAPTION_N}" labelWidth="120px" labelAlign="${labelAlign}" columnCount="2" useTitleBar="false" onEnter="">
            <e:row>
                <e:label for="PROGRESS_CD" title="${form_PROGRESS_CD_N}"/>
                <e:field colSpan="3">
                    <e:select id="PROGRESS_CD" name="PROGRESS_CD" value="${formData.PROGRESS_CD}" onChange="onChangePROGRESS_CD" options="${progressCdOptions}" width="${form_PROGRESS_CD_W}" disabled="${form_PROGRESS_CD_D}" readOnly="${form_PROGRESS_CD_RO}" required="${form_PROGRESS_CD_R}" placeHolder="" maskType="${form_PROGRESS_CD_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="RECV_USER_NM" title="${form_RECV_USER_NM_N}" />
                <e:field>
                    <e:inputText id="RECV_USER_NM" name="RECV_USER_NM" value="${formData.RECV_USER_NM}" width="${form_RECV_USER_NM_W}" maxLength="${form_RECV_USER_NM_M}" disabled="${form_RECV_USER_NM_D}" readOnly="${form_RECV_USER_NM_RO}" required="${form_RECV_USER_NM_R}"  maskType="${form_RECV_USER_NM_MT}" />
                </e:field>
                <e:label for="RECV_DATE" title="${form_RECV_DATE_N}" />
                <e:field>
                    <e:inputText id="RECV_DATE" name="RECV_DATE" value="${formData.RECV_DATE}" width="${form_RECV_DATE_W}" maxLength="${form_RECV_DATE_M}" disabled="${form_RECV_DATE_D}" readOnly="${form_RECV_DATE_RO}" required="${form_RECV_DATE_R}" style="${imeMode}" maskType="${form_RECV_DATE_MT}"/>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DS_USER_NM" title="${form_DS_USER_NM_N}" />
                <e:field>
                    <e:inputText id="DS_USER_NM" name="DS_USER_NM" value="${formData.DS_USER_NM}" width="${form_DS_USER_NM_W}" maxLength="${form_DS_USER_NM_M}" disabled="${form_DS_USER_NM_D}" readOnly="${form_DS_USER_NM_RO}" required="${form_DS_USER_NM_R}"  maskType="${form_DS_USER_NM_MT}" />
                </e:field>
                <e:label for="DS_DATE" title="${form_DS_DATE_N}" />
                <e:field>
                    <e:inputText id="DS_DATE" name="DS_DATE" value="${formData.DS_DATE}" width="${form_DS_DATE_W}" maxLength="${form_DS_DATE_M}" disabled="${form_DS_DATE_D}" readOnly="${form_DS_DATE_RO}" required="${form_DS_DATE_R}"  maskType="${form_DS_DATE_MT}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DF_RMK" title="${form_DF_RMK_N}"/>
                <e:field colSpan="3">
                    <e:textArea id="DF_RMK" name="DF_RMK" value="${formData.DF_RMK}" height="90px" width="${form_DF_RMK_W}" maxLength="${form_DF_RMK_M}" disabled="${form_DF_RMK_D}" readOnly="${form_DF_RMK_RO}" required="${form_DF_RMK_R}" />
                </e:field>
            </e:row>
            <e:row>
                <e:label for="DS_ATTACH_FILE_NO" title="${form_DS_ATTACH_FILE_NO_N}" />
                <e:field colSpan="3">
                    <e:fileManager id="DS_ATTACH_FILE_NO" name="DS_ATTACH_FILE_NO" readOnly="${form_DS_ATTACH_FILE_NO_RO}"  fileId="${formData.DS_ATTACH_FILE_NO}" downloadable="true" width="100%" bizType="MP" height="90px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <e:buttonBar align="right" width="100%">
            <e:button id="doSaveReq" name="doSaveReq" label="${doSaveReq_N}" onClick="doSaveReq" disabled="${doSaveReq_D}" visible="${doSaveReq_V}"/>
            <e:button id="doSave" name="doSave" label="${doSave_N}" onClick="doSave" disabled="${doSave_D}" visible="${doSave_V}"/>
            <e:button id="doDelete" name="doDelete" label="${doDelete_N}" onClick="doDelete" disabled="${doDelete_D}" visible="${doDelete_V}"/>
            <e:button id="doClose" name="doClose" label="${doClose_N}" onClick="doClose" disabled="${doClose_D}" visible="${doClose_V}"/>
        </e:buttonBar>
    </e:window>
</e:ui>