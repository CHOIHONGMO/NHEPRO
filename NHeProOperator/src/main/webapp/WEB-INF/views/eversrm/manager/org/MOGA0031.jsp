<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">

        var grid; var deptGrid;
        var baseUrl = "/eversrm/manager/org/";

        function init() {


            deptGrid = EVF.C("deptGrid");
            grid = EVF.C("grid");

            var treeViewObj = deptGrid.getGridViewObj();
            treeViewObj.setHeader({visible: true});
            treeViewObj.setCheckBar({visible: false});
            treeViewObj.setIndicator({visible: false});
            treeViewObj.setTreeOptions({showCheckBox: false});

            deptGrid.setColCursor('DEPT_NM', 'pointer');
            deptGrid.setColReadOnly('CTRL_MAPPING_YN', true);
            deptGrid.setColReadOnly('USER_MAPPING_YN', true);

            deptGrid.cellClickEvent(function(rowIdx, colIdx, value) {
                if(colIdx == "DEPT_NM"){
                    EVF.V("DEPT_CD",deptGrid.getCellValue(rowIdx, 'DEPT_CD'));
                    doSearch_DP();
                }else if(colIdx == "TEAM_LEADER_USER_NM"){
                    var	param =	{
                        rowIdx: rowIdx,
                        custCd: EVF.V("CUST_CD"),
                        callBackFunction: "callBackCTRL_USER_ID"
                    };
                    everPopup.openCommonPopup(param, 'SP0086');
                }
            });

            deptGrid.cellChangeEvent(function(rowIdx, colIdx, iRow, iCol, value, oldValue) {
                if(colIdx == "INDEPT" || colIdx == "ACC_CODE"){
                    var addParam = [{
                        "DEPT_CD" : deptGrid.getCellValue(rowIdx, 'DEPT_CD')
                        ,"ACC_CODE" : deptGrid.getCellValue(rowIdx, 'ACC_CODE')
                        ,"INDEPT" : deptGrid.getCellValue(rowIdx, 'INDEPT')
                        ,"TEAM_LEADER_USER_ID" : deptGrid.getCellValue(rowIdx, 'TEAM_LEADER_USER_ID')
                    }];
                    grid.addRow(addParam);
                }
            });

            deptGrid.setProperty('shrinkToFit', true);                  // 컬럼의 너비를 그리드의 너비만큼 비율적으로 늘려서 맞춘다. [true/false]
            deptGrid.setProperty('rowNumbers', ${rowNumbers});			// 로우의 번호 표시 여부를 지정한다. [true/false]
            deptGrid.setProperty('sortable', ${sortable});				// 컬럼 정렬기능 사용여부를 지정한다. [true/false]
            deptGrid.setProperty('panelVisible', ${panelVisible});		// 그리드 상단에 컬럼그룹핑 패널의 표시 여부를 지정한다. [true/false]
            deptGrid.setProperty('enterToNextRow', ${enterToNextRow});	// 셀에서 엔터입력 시 포커스의 이동방향을 지정한다. [true/false]
            deptGrid.setProperty('acceptZero', ${acceptZero});			// 그리드의 셀이 숫자형일 때 0인 데이터에 대한 필수입력처리 여부를 지정한다. [true/false]
            deptGrid.setProperty('singleSelect', ${singleSelect});		// [선택] 컬럼의 다중선택 여부를 지정한다. [true/false]
            deptGrid.setProperty('multiSelect', ${param.detailView == true ? false : multiSelect}); //[선택] 컬럼의 사용여부를 지정한다. [true/false]

            doSearch();

        }

        function doSearch() {

            var store = new EVF.Store();
            if(!store.validate()) { return; }
            store.load(baseUrl + 'MOGA0031_doSelect_deptTree.so', function() {

                var treeData = this.getParameter("treeData");
                var jsonTree = JSON.parse(treeData);

                deptGrid.getDataProvider().setRows(jsonTree, 'tree', '', '', 'icon');
                treeViewObj = deptGrid.getGridViewObj();
                treeViewObj.expandAll();
            });
        }

        function doSave() {

            grid.checkAll(true);
            if(grid.getSelRowCount() == 0) { return EVF.alert("${MOGA0031_002}"); }

            EVF.confirm("${msg.M0021}", function() {
                var store = new EVF.Store();
                store.setGrid([grid]);
                store.getGridData(grid, 'all');
                store.load(baseUrl + 'MOGA0031_doSave_tree.so', function() {
                    EVF.alert(this.getResponseMessage());
                    doSearch();
                    grid.delAllRow();
                });
            });

        }

        function callBackCTRL_USER_ID(jsonData)	{

            deptGrid.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_NM', jsonData.USER_NM);
            deptGrid.setCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID', jsonData.USER_ID);
            deptGrid.setCellValue(jsonData.rowIdx, 'checkYN', 'Y');

            var addParam = [{
                 "DEPT_CD" : deptGrid.getCellValue(jsonData.rowIdx, 'DEPT_CD')
                ,"ACC_CODE" : deptGrid.getCellValue(jsonData.rowIdx, 'ACC_CODE')
                ,"INDEPT" : deptGrid.getCellValue(jsonData.rowIdx, 'INDEPT')
                ,"TEAM_LEADER_USER_ID" : deptGrid.getCellValue(jsonData.rowIdx, 'TEAM_LEADER_USER_ID')
            }];
            grid.addRow(addParam);
        }

        function setBuyer(data) {
            EVF.V('CUST_CD', data.CUST_CD);
            EVF.V('CUST_NM', data.CUST_NM);
        }

    </script>
    <e:window id="MOGA0031" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">

        <e:inputHidden id="DEPT_CD" name="DEPT_CD"/>

        <e:searchPanel id="form" title="${msg.M9999 }" columnCount="1" labelWidth="${labelWidth }" useTitleBar="false" onEnter="doSearch">
        <e:row>
            <e:label for="CUST_CD" title="${form_CUST_CD_N}"/>
            <e:field>
                <e:inputText id="CUST_CD" name="CUST_CD" value="${ses.companyCd}" width="0" maxLength="${form_CUST_CD_M}" disabled="${form_CUST_CD_D}" readOnly="${form_CUST_CD_RO}" required="${form_CUST_CD_R}" />
                <e:search id="CUST_NM" name="CUST_NM" value="${ses.companyNm}" width="100%" maxLength="${form_CUST_NM_M}" onIconClick="${form_CUST_NM_RO ? 'everCommon.blank' : 'getBuyer'}" popupCode="SP0066.setBuyer" disabled="${form_CUST_NM_D}" readOnly="${form_CUST_NM_RO}" required="${form_CUST_NM_R}" />
            </e:field>
        </e:row>
        </e:searchPanel>

        <e:buttonBar id="buttonBar" align="right" width="100%">
            <e:button id="Search" name="Search" label="${Search_N }" disabled="${Search_D }" visible="${Search_V}" onClick="doSearch" />
            <e:button id="Save" name="Save" label="${Save_N }" disabled="${Save_D }" visible="${Save_V}" onClick="doSave" />
        </e:buttonBar>


        <e:panel id="H1" width="100%"  height="fit">
            <e:gridPanel id="deptGrid" name="deptGrid" gridType="RGT" width="100%" height="fit" readOnly="${param.detailView}"/>
        </e:panel>

        <e:panel width="0px" height="0px">
            <e:gridPanel id="grid" name="grid" gridType="${_gridType}" width="0%" height="0px" readOnly="${param.detailView}"/>
        </e:panel>

    </e:window>
</e:ui>