<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">
   		var baseUrl = "/eversrm/";
        function init() {
            
        }
		
        function doConfirm() {
        	var type = EVF.V("type");
        	var param = {
                    "rowIdx": EVF.V("rowIdx"),
                    "check": "Y"
                };
        	
        	if (type == "ecpcHD") {
                opener.guarEcpcHdGuidecheck(param);
            } else {
            	opener.guarEcpcGuidecheck(param);
            }
        	
            EVF.closeWindow();
        }
        
    </script>

    <e:window id="guarGuide" onReady="init" initData="${initData}" title="소프트웨어공제조합 전자신청안내" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="" labelWidth="100%" width="100%" columnCount="1">
	        <e:inputHidden id="rowIdx" name="rowIdx" value="${param.rowIdx}"/>
	        <e:inputHidden id="type" name="type" value="${param.type}"/>
	        <e:field>
	        	<e:text style="font-weight: bold; font-size: 14px; color: red">※ 전자보증 신청 시 주의사항</e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: #222222">전자보증 신청 후 소프트공제조합 사이트에서의 계약번호는 농협 전자구매시스템의 계약상세 화면에서 전자보증으로 신청하신 계약건에 대한 "계약번호"가 아닌 "전자보증신청번호" 입니다.</e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: #222222">전자보증 신청 후 소프트공제조합 사이트에서 신청하신 보증내용을 불러오기 및 수기입력 시 계약번호를 입력하는 경우 "전자보증신청번호"를 입력하시기 바랍니다.</e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: #222222">"전자보증신청번호"는 신청하신 보증 건에 대해 신규로 생성되며 전자보증 신청 후 계약상세화면에서 확인 가능합니다.</e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: #222222">예) 1. EC201200001(11자리 계약번호)를 입력 시 전자보증 신청 오류 </e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: #222222">&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;2. GU2101000000011(14자리 전자보증신청번호)를 입력 시 전자보증 정상 완료.</e:text><e:br/>
	        	<e:text></e:text><e:br/>
	        	<e:text></e:text><e:br/>
	        	<e:text style="font-weight: bold; font-size: 14px; color: red">※ 위의 내용을 확인하신 후 "확인"버튼을 클릭하시면 전자보증 신청을 하실 수 있습니다.</e:text><e:br/>
	        </e:field>
        </e:searchPanel>
		
        <div style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <div class="btn_confirm" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doConfirm();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">확인</span>
            </div>
        </div>
    </e:window>
</e:ui>

