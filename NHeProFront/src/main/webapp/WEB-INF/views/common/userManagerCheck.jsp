<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript" src="/js/nhepro/bundle.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>

    <script type="text/javascript">
    	
        function init() {
        	doClear();
        }
		
		function doClear(gubun) {
        	
        	var store = new EVF.Store();
            store.load('/managerKeyClear.so', function () {
            	if (gubun == "1") {
                	EVF.alert("문자로 전송된 인증번호를 입력하세요.");
            	}
            }, false);
        }
        
        function doConfirm() {
        	
        	if (EVF.isEmpty("${formData.USER_NM}") || EVF.isEmpty("${formData.CELL_NUM}")) {
                return EVF.alert("사용자명 또는 휴대폰번호가 없습니다. 고객센터에 문의하세요.");
            }
        	if (EVF.isEmpty(EVF.V("MANAGER_KEY")) || EVF.V("MANAGER_KEY").trim().length != 6) {
                return EVF.alert("인증번호는 공백을 제외하고 6자리로 입력해야 합니다.");
            }
        	
        	var store = new EVF.Store();
            store.load('/managerKeyConfirm.so', function () {
            	var rltCode = this.getResponseCode();
            	if (rltCode == '1') {
                	opener.doAuthManagerCallback(rltCode);
                    doClose();
               	} else {
               		EVF.alert("문자인증 정보가 일치하지 않습니다.\n전송된 문자의 인증번호 6자리를 정확하게 입력하세요.");
               	}
            }, false);
        }
        
        function doClose(){
            EVF.closeWindow();
        }
    </script>

    <e:window id="userManagerCheck" onReady="init" initData="${initData}" title="관리자 문자인증" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%">
            <e:inputHidden id="USER_ID"  name="USER_ID"  value="${formData.USER_ID }" />
            <e:inputHidden id="USER_NM"  name="USER_NM"  value="${formData.USER_NM }" />
            <e:inputHidden id="CELL_NUM" name="CELL_NUM" value="${formData.CELL_NUM }" />
            <e:row>
                <e:label for="USER_NM" title="사용자" />
                <e:field>
                    <e:text>${formData.USER_NM } </e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="CELL_NUM" title="휴대폰번호" />
				<e:field>
					<e:text>${formData.CELL_NUM } </e:text>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="MANAGER_KEY" title="${form_MANAGER_KEY_N}" />
				<e:field>
					<e:inputText id="MANAGER_KEY" name="MANAGER_KEY" value="" width="${form_MANAGER_KEY_W}" maxLength="${form_MANAGER_KEY_M}" disabled="${form_MANAGER_KEY_D}" readOnly="${form_MANAGER_KEY_RO}" required="${form_MANAGER_KEY_R}" style="${imeMode}" maskType="${form_MANAGER_KEY_MT}"/>
				</e:field>
            </e:row>
        </e:searchPanel>
        
        <div style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <div class="btn_clear" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doClear('1');">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">문자 재전송</span>
            </div>
            <div class="btn_confirm" style="border-radius: 15px; width: 80px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doConfirm();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">확인</span>
            </div>
        </div>
    </e:window>
</e:ui>

