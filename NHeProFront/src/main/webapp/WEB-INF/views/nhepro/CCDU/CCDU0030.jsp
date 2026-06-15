<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

		var grid;
		var baseUrl = "/nhepro/CCDU/CCDU0010";
		var multiYN = ${param.multiYN=="Y"?true:false};
		var readOnlyFlag = ${param.READONLY=="Y"?true:false};
		var custCd = "${param.CUST_CD}";
		var relatYn = "${ses.relatYn}";
		var corpType = "${ses.corpType}";
		var viewFlag = "${param.viewFlag}";	// 화면구분(=위임장(EN))
		
		function init() {
			grid  = EVF.C("grid");
            
			grid.setProperty("shrinkToFit", true);		// 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
			grid.setProperty("rowNumbers", ${rowNumbers});		    // 로우의 번호 표시 여부를 지정한다. [true/false]
			grid.setProperty("sortable", ${sortable});			    // 컬럼 정렬기능 사용여부를 지정한다. [true/false]
			grid.setProperty("panelVisible", ${panelVisible});	    // 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
			grid.setProperty("enterToNextRow", ${enterToNextRow}); // 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
			grid.setProperty("acceptZero", ${acceptZero});		    // 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
			
		    if(multiYN){
		    	grid.setProperty('multiSelect', true);
				EVF.C("doChoose").setVisible(true);
			}else{
				grid.setProperty('multiSelect', false);
				EVF.C("doChoose").setVisible(false);
			}
			
			if(readOnlyFlag) {
                EVF.C("CORP_TYPE").setReadOnly(true);
                EVF.C("CUST_CD").setReadOnly(true);
            } else {
            	if(relatYn == "0"){
                	EVF.C("CORP_TYPE").setReadOnly(false);
                	EVF.C("CUST_CD").setReadOnly(false);
            	}else{
            		EVF.C("CORP_TYPE").setReadOnly(true);
                	EVF.C("CUST_CD").setReadOnly(true);
            	}
            }
			
			grid.cellClickEvent(function (rowIdx, colId, value) {
				switch (colId) {
				case 'DEPT_NM':
					if (multiYN) {
                        grid.checkRow( rowIdx, true );
                    }else{
						if(value != '') {
							var data = grid.getRowValue(rowIdx);
							data.rowIdx = "${param.rowIdx}";
							
							var selectedData = JSON.stringify(data);
							
							if(${param.ModalPopup == true}){
				                parent['${param.callBackFunction}'](selectedData);
				            }else{
				                opener['${param.callBackFunction}'](selectedData);
				            }
					        
						    doClose();
						}
                    }
					break;
				}
			});
			
			if(corpType == '2' || '${param.CORP_TYPE}' == '2'){
				grid.hideCol('BRANCH_FLAG', false);
				$("#sp_form tr:eq(2)").show();
			}else{
				grid.hideCol('BRANCH_FLAG', true);
				$("#sp_form tr:eq(2)").hide();
			}

			getCust();

			if( viewFlag != 'EN' ) {
				EVF.C('CUST_CD').setRequired(true);
			}

		}
		
		// Search
		function doSearch() {
			var store = new EVF.Store();

			// form validation Check
			if (!store.validate()) return;
			
			store.setGrid([grid]);
			store.load(baseUrl + "/ccdu0030_doSearch.so", function () {
				if (grid.getRowCount() == 0) {
					return EVF.alert("${msg.M0002}");
				}
			});
		}
		
		function doChoose() {
			
			if(grid.getSelRowCount() == 0) { return EVF.alert("${msg.M0004}"); }
			
			var selectedData = grid.getSelRowValue();
	        if( grid.isEmpty( selectedData) ) { return ; }
	        
	        if(${param.ModalPopup == true}){
                parent['${param.callBackFunction}'](selectedData);
            }else{
                opener['${param.callBackFunction}'](selectedData);
            }
	        
		    doClose();
	    }
		
		function doClose() {
            EVF.closeWindow();
        }
		
		var k = 0;

        function getCust() {
        	
        	var changeCorpType = EVF.C('CORP_TYPE').getValue();
        	
        	if(changeCorpType != '2'){
	            var store = new EVF.Store();
	
	            var relat_yn = EVF.V("RELAT_YN");
	            var corp_type = EVF.V("CORP_TYPE");
	            store.load(baseUrl+'/ccdu0010_getCust.so?RELAT_YN='+relat_yn+'&CORP_TYPE='+corp_type, function() {
	                //조회후 넘겨받은 리스트를 해당 콤보다음에 셋팅한다.
	                var custInfo = this.getParameter("CUST_CD");
	                //setTimeout(function() {
	                EVF.C('CUST_CD').setOptions(custInfo);
	
	                //}, 1000)
	            });
	            
	            // 위임장 : EN
	            if( viewFlag != 'EN' ) {
		            setTimeout(function() {
			            if (k==0) {
							if(custCd == undefined || custCd == ''){
								EVF.C('CUST_CD').setValue('${ses.companyCd}');
							}else{
								EVF.C('CUST_CD').setValue('${param.CUST_CD}');
							}
							k = 1;
						} 
		            }, 500);
	            }
	            
	            EVF.C('CUST_CD').setRequired(true);
	            grid.hideCol('BRANCH_FLAG', true);
				$("#sp_form tr:eq(2)").hide();
        	}else{
        		setTimeout(function() {
			        EVF.C('CUST_CD').resetOption();
			        var store = new EVF.Store();
			        EVF.C('CUST_CD').setOptions({});

			        EVF.C('CUST_CD').setRequired(false);
			        grid.hideCol('BRANCH_FLAG', false);
			        $("#sp_form tr:eq(2)").show();
				}, 500);
        	}
        }
        
	</script>

	<e:window id="CCDU0030" onReady="init" initData="${initData}" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
        <e:inputHidden id="WORK_TYPE" name="WORK_TYPE" value="${param.WORK_TYPE}" />
		<e:searchPanel id="form" title="${msg.M9999}" columnCount="2" labelWidth="${labelWidth}" useTitleBar="false" onEnter="doSearch">
			<e:row>
				<e:label for="RELAT_YN" title="${form_RELAT_YN_N}"/>
				<e:field>
					<e:select id="RELAT_YN" name="RELAT_YN" value="${empty param.RELAT_YN ? ses.relatYn : param.RELAT_YN}" options="${relatYnOptions}" width="40%" disabled="${form_RELAT_YN_D}" readOnly="${form_RELAT_YN_RO}" required="${form_RELAT_YN_R}" placeHolder="" maskType="${form_RELAT_YN_MT}" />
					<e:select id="CORP_TYPE" name="CORP_TYPE" value="${empty param.CORP_TYPE ? ses.corpType : param.CORP_TYPE}" options="${corpTypeOptions}" width="60%" onChange="getCust" disabled="${form_CORP_TYPE_D}" readOnly="${form_CORP_TYPE_RO}" required="${form_CORP_TYPE_R}" placeHolder="" maskType="${form_CORP_TYPE_MT}" />
				</e:field>
				<e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
				<e:field>
					<e:select id="CUST_CD" name="CUST_CD" value="" options="${custCdOptions}" width="100%" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" placeHolder="" maskType="${form_CUST_CD_MT}" usePlaceHolder="false"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="DEPT_NM" title="${form_DEPT_NM_N}" />
				<e:field>
					<e:inputText id="DEPT_NM" name="DEPT_NM" value="" width="${form_DEPT_NM_W}" maxLength="${form_DEPT_NM_M}" disabled="${form_DEPT_NM_D}" readOnly="${form_DEPT_NM_RO}" required="${form_DEPT_NM_R}" style="${imeMode}" maskType="${form_DEPT_NM_MT}"/>
				</e:field>
				<e:label for="IRS_NUM" title="${form_IRS_NUM_N}" />
				<e:field>
					<e:inputText id="IRS_NUM" name="IRS_NUM" value="" width="${form_IRS_NUM_W}" maxLength="${form_IRS_NUM_M}" disabled="${form_IRS_NUM_D}" readOnly="${form_IRS_NUM_RO}" required="${form_IRS_NUM_R}" style="${imeMode}" maskType="${form_IRS_NUM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="ZONE_CD" title="${form_ZONE_CD_N}"/>
				<e:field>
				<e:select id="ZONE_CD" name="ZONE_CD" value="" options="${zoneCdOptions}" width="${form_ZONE_CD_W}" disabled="${form_ZONE_CD_D}" readOnly="${form_ZONE_CD_RO}" required="${form_ZONE_CD_R}" placeHolder="" maskType="${form_ZONE_CD_MT}" />
				</e:field>				
				<e:label for="BRANCH_FLAG" title="${form_BRANCH_FLAG_N}"/>
				<e:field>
					<e:select id="BRANCH_FLAG" name="BRANCH_FLAG" value="${param.CORP_TYPE eq '2' ? '1' : ''}" options="${branchFlagOptions}" width="${form_BRANCH_FLAG_W}" disabled="${form_BRANCH_FLAG_D}" readOnly="${form_BRANCH_FLAG_RO}" required="${form_BRANCH_FLAG_R}" placeHolder="" maskType="${form_BRANCH_FLAG_MT}" />
				</e:field>

			</e:row>
		</e:searchPanel>
		
        <e:buttonBar id="buttonBar" align="right" width="100%">
          <e:button id="doSearch" name="doSearch" label="${doSearch_N}" onClick="doSearch" disabled="${doSearch_D}" visible="${doSearch_V}"/>
          <e:button id="doChoose" name="doChoose" label="${Choose_N}" onClick="doChoose" disabled="${Choose_D}" visible="${Choose_V}"/>
        </e:buttonBar>
		<e:gridPanel gridType="${_gridType}" id="grid" name="grid" width="100%" height="fit" />
	</e:window>
</e:ui>

