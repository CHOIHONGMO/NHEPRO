<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

	<script type="text/javascript">

        var grid;
	    var isDetailView = ('${param.detailView}' === 'true' ? true : false);
		var baseUrl = "/nhepro/CBDR/";
		var maxProgressCd;

	    function init() {

            grid = EVF.C("grid");

            grid.cellClickEvent(function(rowIdx, colIdx, value) {

                if(colIdx == "TECH_ATT_FILE_NUM") {
					if(grid.getCellValue(rowIdx, 'BID_STATUS') == "200") {
						var param = {
							attFileNum: grid.getCellValue(rowIdx, 'TECH_ATT_FILE_NUM'),
							rowIdx: rowIdx,
							callBackFunction: 'setFileAttach',
							bizType: 'BID',
							detailView: false
						};
						everPopup.fileAttachPopup(param);
					}
                }
                if(colIdx == "TECH_RMK") {
					if(grid.getCellValue(rowIdx, 'BID_STATUS') == "200") {
						var param = {
							title: "${CBDI0036_T003}",
							message: grid.getCellValue(rowIdx, 'TECH_RMK'),
							callbackFunction: 'setRMK',
							rowIdx: rowIdx
						};
						everPopup.commonTextInput(param);
					}
                }
            });

			grid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {

				if (colIdx == "TECH_SCORE" || colIdx == "PRC_SCORE") {

					var techScore = Number(grid.getCellValue(rowIdx, 'TECH_SCORE'));
					var prcScore = Number(grid.getCellValue(rowIdx, 'PRC_SCORE'));
					var sumScore = techScore + prcScore;

					if(sumScore > 100) {
						if(colIdx == "TECH_SCORE") { grid.setCellValue(rowIdx, 'TECH_SCORE', null); }
						if(colIdx == "PRC_SCORE") { grid.setCellValue(rowIdx, 'PRC_SCORE', null); }
						return EVF.alert("${CBDI0036_T015}")
					}
					if(sumScore < 0) {
						if(colIdx == "TECH_SCORE") { grid.setCellValue(rowIdx, 'TECH_SCORE', null); }
						if(colIdx == "PRC_SCORE") { grid.setCellValue(rowIdx, 'PRC_SCORE', null); }
						return EVF.alert("${CBDI0036_T016}")
					}

					if(!EVF.isEmpty(techScore) && techScore > -1 && !EVF.isEmpty(prcScore) && prcScore > -1) {
						grid.setCellValue(rowIdx, 'SUM_SCORE', sumScore);
					} else {
						grid.setCellValue(rowIdx, 'SUM_SCORE', null);
					}

					<%-- 심사점수, 가격점수를 입력하면 합산점수가 자동계산되며, STOCBDHD.CONF_STD_SCORE의 값을 기준으로 최종결과를 판단하여 ‘적격＇ 또는 ‘부적격’으로 SETTING!! --%>
					<%--
					var confStdScore = Number(EVF.V("CONF_STD_SCORE"));
					if((confStdScore > 0) && (sumScore >= confStdScore)) {
						grid.setCellValue(rowIdx, 'BID_STATUS', "300"); //적격
					} else {
						grid.setCellValue(rowIdx, 'BID_STATUS', "400");
					}
					--%>
				}
			});

            grid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            grid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            grid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            grid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            grid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            grid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            grid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            grid.setProperty('multiSelect', false);                 // [선택] 컬럼의 사용여부를 지정한다. [true/false]

            if(${!havePermission}) {
                EVF.C('Lottery').setDisabled(true);
                EVF.C('SuccessfulBid').setDisabled(true);
                EVF.C('FailBid').setDisabled(true);
                EVF.C('ReBid').setDisabled(true);
                EVF.C('ReAnn').setDisabled(true);
            } else {
                EVF.C('Lottery').setDisabled(false);
                EVF.C('SuccessfulBid').setDisabled(false);
                EVF.C('FailBid').setDisabled(false);
                EVF.C('ReBid').setDisabled(false);
                EVF.C('ReAnn').setDisabled(false);
            }

			if(EVF.V("BID_STATUS") == "1300" || EVF.V("BID_STATUS") == "2500") {
				EVF.C('Lottery').setVisible(false);
				EVF.C('SuccessfulBid').setVisible(false);
				EVF.C('FailBid').setVisible(false);
				EVF.C('ReBid').setVisible(false);
				EVF.C('ReAnn').setVisible(false);
			}

            doSearchVendorVO();
        }

        function doSearchVendorVO() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }

            store.setGrid([grid]);
            store.load(baseUrl + 'cbdi0036_doSearchVendorVO.so', function() {

                var viewLotteryFlag = this.getParameter("viewLotteryFlag");

                if(grid.getRowCount() == 0) {
                    EVF.alert("${msg.M0002 }");
                } else {

					var rowIds = grid.getAllRowId();
					for(var i in rowIds) {
						if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "100" || grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {
							grid.setCellValue(rowIds[i], 'BID_STATUS', "200");
							grid.setCellValue(rowIds[i], 'ORI_BID_STATUS', "200");
							//grid.setCellReadOnly(rowIds[i], 'BID_STATUS', false);
							grid.setCellReadOnly(rowIds[i], 'TECH_SCORE', false);
							grid.setCellRequired(rowIds[i], "TECH_SCORE", true);
							grid.setCellReadOnly(rowIds[i], 'PRC_SCORE', false);
							grid.setCellRequired(rowIds[i], "PRC_SCORE", true);
							break;
						}
						if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "300") {
							grid.setCellFontColor(rowIds[i], 'VENDOR_NM', "#ff0000");
							grid.setCellFontWeight(rowIds[i], 'VENDOR_NM', true);
							grid.setCellFontColor(rowIds[i], 'BID_AMT', "#ff0000");
							grid.setCellFontColor(rowIds[i], 'SUM_SCORE', "#ff0000");
							grid.setCellFontWeight(rowIds[i], 'SUM_SCORE', true);
							grid.setCellFontColor(rowIds[i], 'BID_STATUS', "#ff0000");
							grid.setCellFontWeight(rowIds[i], 'BID_STATUS', true);
						}
					}

                    if(viewLotteryFlag == "Y" || EVF.V("BID_STATUS") == "1300" || EVF.V("BID_STATUS") == "2500") {
                        EVF.C('SuccessfulBid').setVisible(false);
                        EVF.C('FailBid').setVisible(false);
                        EVF.C('ReBid').setVisible(false);
                        EVF.C('ReAnn').setVisible(false);
                    } else {
                        EVF.C('Lottery').setVisible(false);
						EVF.C('SuccessfulBid').setVisible(true);
						EVF.C('FailBid').setVisible(true);
						EVF.C('ReBid').setVisible(true);
						EVF.C('ReAnn').setVisible(true);
                    }
                    grid.setColIconify("TECH_ATT_FILE_NUM", "TECH_ATT_FILE_NUM", "file", false);
                    grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
                }
            });
        }

        function doLottery() {

            EVF.confirm("${CBDI0036_T004 }", function () {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'cbdi0036_doLottery.so', function() {
                    EVF.alert(this.getResponseMessage(), function() {
                        doSearchVendorVO();
                    });
                });
            });
        }

        function doSuccessfulBid() {

            var confirmMsg = "";
            var settleCnt = 0;

			if (!grid.validate().flag) { return EVF.alert(grid.validate().msg); }

			var checkedRowId = null;
			var rowIds = grid.getAllRowId();
            for(var i in rowIds) {
            	if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {
        			checkedRowId = rowIds[i];
            		<%-- grid.setCellValue(rowIds[i], 'BID_STATUS', "300"); --%>
            	}

            	var estmAmt = 0;
            	var estmMsg = "";
                <%-- if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "300") { --%>
            	if(grid.getCellValue(rowIds[i], 'BID_STATUS') == "200") {

        			if (EVF.V("ESTM_TYPE") == 'SE' || EVF.V("ESTM_TYPE") == 'PE') {
        				estmMsg = "${form_FINAL_ESTM_PRC_TXT_N}" + "${CBDI0036_T023}";
        				estmAmt = everString.replaceAll(EVF.V("FINAL_ESTM_PRC"), ",", "");
        			} else {
        				estmMsg = "${form_BASIC_AMT_N}" + "${CBDI0036_T023}";
        				estmAmt = everString.replaceAll("${formData.BASIC_AMT }", ",", "");
        			}
        			if (estmAmt < grid.getCellValue(rowIds[i], 'BID_AMT')) {
						return EVF.alert(estmMsg)
        			}

					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) > 100) {
						return EVF.alert("${CBDI0036_T015}")
					}
					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) < 0) {
						return EVF.alert("${CBDI0036_T016}")
					}

					if(Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) == 0) {
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T019}";
					} else if (Number(grid.getCellValue(rowIds[i], 'SUM_SCORE')) < Number(EVF.V("CONF_STD_SCORE"))) { <%-- 적격심사기준 점수 check --%>
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T024}";
					} else if (Number(grid.getCellValue(rowIds[i], 'BID_AMT')) < (Number(estmAmt) * Number(EVF.V("SB_LIMIT_RATE")) / 100)) { <%-- 낙찰하한율 check --%>
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T025}";
					} else {
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T014}";
					}
					settleCnt++;
                }
            }

            if(settleCnt == 0) { return EVF.alert("${CBDI0036_T018}") }

            EVF.confirm(confirmMsg, function () {

            	grid.setCellValue(checkedRowId, 'BID_STATUS', "300");

            	var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'cbdi0036_doSuccessfulBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                        var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
                        if(popupFlag) {
                            opener.opener.doSearch();
                            opener.doClose();
                            doClose();
                        }
                    });
                });
            });
        }

        function doFailBid() {

            var confirmMsg = "${CBDI0036_T009}";
            var remainVendorCnt = 0;

			grid.checkAll(false);

			var checkedRowId = null;
			var rowIds = grid.getAllRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
					grid.checkRow(rowIds[i], true);
					checkedRowId = rowIds[i];
					<%-- grid.setCellValue(rowIds[i], 'BID_STATUS', "400"); --%>
					confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T008}";
				}
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "600") {
					grid.checkRow(rowIds[i], true);
					grid.setCellValue(rowIds[i], 'BID_STATUS', "600");
				}
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "100") {
					remainVendorCnt++;
				}
            }

			if(remainVendorCnt == 0) {
				confirmMsg = "${CBDI0036_T009}";
			}

            EVF.confirm(confirmMsg, function () {

               	grid.setCellValue(checkedRowId, 'BID_STATUS', "400");

               	var store = new EVF.Store();
				store.setGrid([grid]);
				store.getGridData(grid, 'sel');
                store.load(baseUrl + 'cbdi0036_doFailBid.so', function(){
                    EVF.alert(this.getResponseMessage(), function() {
                    	if(remainVendorCnt == 0) {
							var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
							if(popupFlag) {
								opener.opener.doSearch();
								opener.doClose();
								doClose();
							}
						} else {
							doSearchVendorVO();
						}
                    });
                });
            });
        }

        function doReBid() {

	        var voteCnt = Number(EVF.V("VOTE_CNT"));
	        var voteLimitCnt = Number(EVF.V("CHECK_VOTE_LIMIT_CNT"));

			<%-- 재입찰 누르면 ‘심사중＇인 협력업체만 재입찰을 진행. --%>
			var confirmMsg = "";
			var remainVendorCnt = 0;
			var reBidVendorCnt = 0;

			grid.checkAll(false);
			var rowIds = grid.getAllRowId();
			var vendorCd = ""; var vendorMaxVoteCnt = "";
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
					if(Number(grid.getCellValue(rowIds[i], 'VENDOR_MAX_VOTE_CNT')) > Number(voteLimitCnt)) {
						//return EVF.alert("${CBDI0036_T007}");
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T026}";
					} else {
						confirmMsg = grid.getCellValue(rowIds[i], 'VENDOR_NM') + "${CBDI0036_T022}";
					}
					vendorCd = grid.getCellValue(rowIds[i], 'VENDOR_CD');
					vendorMaxVoteCnt = grid.getCellValue(rowIds[i], 'VENDOR_MAX_VOTE_CNT');
					reBidVendorCnt++;
				}
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "100") {
					remainVendorCnt++;
				}
			}

			if(remainVendorCnt == 0 && reBidVendorCnt == 0) { return EVF.alert("${CBDI0036_T020}"); }

			EVF.confirm(confirmMsg, function () {
				var param = {
					'BUYER_CD' : EVF.V('BUYER_CD'),
					'BID_NUM' : EVF.V('BID_NUM'),
					'BID_CNT' : EVF.V('BID_CNT'),
					'VENDOR_CD' : vendorCd,
					'VENDOR_MAX_VOTE_CNT' : vendorMaxVoteCnt,
					'REBID' : true,
					'individualFlag' : true,
					'callbackFunction' : "doCallBackFunctionIndividual",
					'popupFlag' : true,
					'detailView' : false
				};
				everPopup.openWindowPopup("/nhepro/CBDR/CBDI0032/view.so", 900, 590, param, "reBid", true);
			});
        }

		function doCallBackFunctionIndividual() {

			grid.checkAll(false);
			var rowIds = grid.getAllRowId();
			for(var i in rowIds) {
				if(grid.getCellValue(rowIds[i], 'ORI_BID_STATUS') == "200") {
					grid.checkRow(rowIds[i], true);
				}
			}

			var store = new EVF.Store();
			store.setGrid([grid]);
			store.getGridData(grid, 'sel');
			store.load(baseUrl + 'cbdi0036_callBackIndividual.so', function() {
				var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
				if(popupFlag) {
					opener.opener.doSearch();
					opener.doClose();
					doClose();
				}
			});
		}

        function doReAnn() {

	        <%-- 이전 공고를 '유찰'시킨 후, 새로운 공고를 작성하기 위한 Popup창을 띄운다. --%>
            var store = new EVF.Store();
            EVF.confirm("${CBDI0036_T005 }", function () {
            	// 2021.04.14 변경
                // 기존 유찰 => 재공고 가능 진행상태 체크
            	//store.load(baseUrl + 'cbdr0033_doFailBid.so', function(){
                store.load(baseUrl + 'cbdr0033_doCheckWithReAnn.so', function(){
                    var param = {
                        'buyerCd' : EVF.V('BUYER_CD'),
                        'bidNum' : EVF.V('BID_NUM'),
                        'bidCnt' : EVF.V('BID_CNT'),
                        'preBidNum' : EVF.V('BID_NUM'),
                        'preBidCnt' : EVF.V('BID_CNT'),
                        'preVoteCnt' : EVF.V('VOTE_CNT'),
                        'baseDataType': "ReBID",
                        'callbackFunction': "doCallBackFunction",
                        'popupFlag' : true,
                        'detailView' : false
                    };
                    everPopup.openWindowPopup("/nhepro/CBDI/CBDI0011/view.so", 1300, 800, param, "modBidNotice", true);
                });
            });
        }

        function doCallBackFunction() {
            var popupFlag = ${(param.popupFlag == null || !param.popupFlag) ? false : true};
            if(popupFlag) {
                opener.opener.doSearch();
                opener.doClose();
                doClose();
            }
        }

        function setFileAttach(rowIdx, fileId, fileCnt) {
            grid.setCellValue(rowIdx, 'TECH_ATT_FILE_NUM', fileId);
            grid.setColIconify("TECH_ATT_FILE_NUM", "TECH_ATT_FILE_NUM", "file", false);
        }

        function setRMK(data) {
            grid.setCellValue(data.rowIdx, "TECH_RMK", data.message);
            grid.setColIconify("TECH_RMK", "TECH_RMK", "comment", false);
        }

        function openFinalEstmPrc() {

			var param = {
				 BID_NUM : EVF.V("BID_NUM")
				,BID_CNT : EVF.V("BID_CNT")
				,BUYER_CD : EVF.V("BUYER_CD")
				,'detailView' : true
			};
			if (EVF.V("ESTM_TYPE") == 'SE') {
				everPopup.openPopupByScreenId('CBDI0052', 1000, 300, param);
			} else {
				everPopup.openPopupByScreenId('CBDI0053', 1000, 480, param);
			}
		}

        function doClose() {
            EVF.closeWindow();
        }

    </script>
    <e:window id="CBDI0036" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="PR_BUYER_CD" name="PR_BUYER_CD" value="${formData.PR_BUYER_CD}" />
        <e:inputHidden id="BUYER_CD" name="BUYER_CD" value="${formData.BUYER_CD}" />
        <e:inputHidden id="BID_NUM" name="BID_NUM" value="${formData.BID_NUM}" />
        <e:inputHidden id="BID_CNT" name="BID_CNT" value="${formData.BID_CNT}" />
        <e:inputHidden id="VOTE_CNT" name="VOTE_CNT" value="${formData.VOTE_CNT}" />
        <e:inputHidden id="BID_STATUS" name="BID_STATUS" value="${formData.BID_STATUS}" />
        <e:inputHidden id="BID_USER_ID" name="BID_USER_ID" value="${formData.BID_USER_ID}" />
        <e:inputHidden id="CONT_TYPE1" name="CONT_TYPE1" value="${formData.CONT_TYPE1}" />
        <e:inputHidden id="CONT_TYPE2" name="CONT_TYPE2" value="${formData.CONT_TYPE2}" />
        <e:inputHidden id="CONT_TYPE3" name="CONT_TYPE3" value="${formData.CONT_TYPE3}" />
        <e:inputHidden id="VOTE_LIMIT_CNT" name="VOTE_LIMIT_CNT" value="${formData.VOTE_LIMIT_CNT}" />
        <e:inputHidden id="CHECK_VOTE_LIMIT_CNT" name="CHECK_VOTE_LIMIT_CNT" value="${formData.CHECK_VOTE_LIMIT_CNT}" />
        <e:inputHidden id="DIFF_GUAR_FLAG" name="DIFF_GUAR_FLAG" value="${formData.DIFF_GUAR_FLAG}" />
        <e:inputHidden id="SB_LIMIT_RATE" name="SB_LIMIT_RATE" value="${formData.SB_LIMIT_RATE}" />
        <e:inputHidden id="CONF_STD_SCORE" name="CONF_STD_SCORE" value="${formData.CONF_STD_SCORE}" />
        <e:inputHidden id="ESTM_TYPE" name="ESTM_TYPE" value="${formData.ESTM_TYPE}" />

        <%-- 입찰공고 정보 --%>
        <e:buttonBar id="buttonBar" align="right" width="100%" title="${CBDI0036_T001 }">
            <e:button id="Lottery" name="Lottery" label="${Lottery_N }" disabled="${Lottery_D }" visible="${Lottery_V}" onClick="doLottery" />
            <e:button id="SuccessfulBid" name="SuccessfulBid" label="${SuccessfulBid_N }" disabled="${SuccessfulBid_D }" visible="${SuccessfulBid_V}" onClick="doSuccessfulBid" />
            <e:button id="FailBid" name="FailBid" label="${FailBid_N }" disabled="${FailBid_D }" visible="${FailBid_V}" onClick="doFailBid" />
            <e:button id="ReBid" name="ReBid" label="${ReBid_N }" disabled="${ReBid_D }" visible="${ReBid_V}" onClick="doReBid" />
            <e:button id="ReAnn" name="ReAnn" label="${ReAnn_N }" disabled="${ReAnn_D }" visible="${ReAnn_V}" onClick="doReAnn" />
            <e:button id="Close" name="Close" label="${Close_N }" disabled="${Close_D }" visible="${Close_V}" onClick="doClose" />
        </e:buttonBar>

		<e:searchPanel id="form1" labelWidth="${labelWidth}" width="100%" columnCount="2" useTitleBar="false">
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
			<e:row>
				<e:label for="BASIC_AMT" title="${form_BASIC_AMT_N}"/>
				<e:field>
					<e:text>${formData.BASIC_AMT }&nbsp;&nbsp;${formData.CUR }&nbsp;&nbsp;${formData.VAT_TYPE } </e:text>
				</e:field>
				<e:label for="FINAL_ESTM_PRC_TXT" title="${form_FINAL_ESTM_PRC_TXT_N}"/>
				<e:field>
					<e:inputText id="FINAL_ESTM_PRC_TXT" name="FINAL_ESTM_PRC_TXT" value="${formData.FINAL_ESTM_PRC_TXT }" style="${formData.FINAL_ESTM_PRC == null ? '' : 'font-weight:bold; cursor:pointer; color:blue;'}" onClick="${formData.FINAL_ESTM_PRC == null ? '' : 'openFinalEstmPrc'}" width="${form_FINAL_ESTM_PRC_TXT_W}" maxLength="${form_FINAL_ESTM_PRC_TXT_M}" disabled="${form_FINAL_ESTM_PRC_TXT_D}" readOnly="${form_FINAL_ESTM_PRC_TXT_RO}" required="${form_FINAL_ESTM_PRC_TXT_R}" />
					<e:inputHidden id="FINAL_ESTM_PRC" name="FINAL_ESTM_PRC" value="${formData.FINAL_ESTM_PRC }" />
				</e:field>
			</e:row>
			<e:row>
				<e:label for="MIN_BID_AMT" title="${form_MIN_BID_AMT_N}"/>
				<e:field colSpan="3">
                    <e:text>${formData.MIN_BID_AMT }&nbsp;&nbsp;${formData.CUR }&nbsp;&nbsp;${formData.VAT_TYPE } </e:text>
				</e:field>
			</e:row>
		</e:searchPanel>

        <%-- 적격심사결과 --%>
        <div class="e-component e-title-container" data-uuid="Title-541-391-560">
            <div class="e-title-bullet-h1"></div>
            <div class="e-title-text">${CBDI0036_T002 }</div>
            <div class="e-title-text" style="font-size:11px;padding-left: 5px;">${CBDI0036_T027 }</div>
        </div>
        <e:gridPanel id="grid" name="grid" width="100%" height="fit" gridType="${_gridType}" readOnly="${param.detailView}" />

	</e:window>
</e:ui>