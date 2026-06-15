<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript">
        function init() {
            var editor = EVF.C("NOTICE_CONTENTS").getInstance();
            editor.config.contentsCss  = "/css/richText.css";
            editor.config.allowedContent = true;
        }
		
        function doClose(){
            EVF.closeWindow();
        }
    </script>

    <e:window id="OETR0062" onReady="init" initData="${initData}" title="개인정보처리 및 서비스 이용약관" breadCrumbs="${breadCrumb }">
        <e:searchPanel id="form" useTitleBar="false" title="" labelWidth="${longLabelWidth}" width="100%" columnCount="1">
            <e:inputHidden id="NOTICE_NUM" name="NOTICE_NUM" value="${formData.NOTICE_NUM }" /> <!-- STOCNOTC의 계약서 폼번호 -->
            <e:inputHidden id="NOTICE_TEXT_NUM" name="NOTICE_TEXT_NUM" value="${formData.NOTICE_TEXT_NUM }" /> <!-- STOCNOTC의 계약서 폼 text번호 -->
			
            <e:row>
                <e:label for="SUBJECT" title="제목" />
                <e:field>
                    <e:text>${formData.SUBJECT }</e:text>
                </e:field>
            </e:row>
            <e:row>
                <e:label for="START_DATE" title="기간" />
                <e:field>
                	<e:text>${formData.START_DATE }</e:text>
                    <e:text>~&nbsp;</e:text>
                	<e:text>${formData.END_DATE }</e:text>
                </e:field>
            </e:row>
            
            <%-- 계약내용 --%>
            <e:row>
                <e:field colSpan="2">
                    <e:richTextEditor id="NOTICE_CONTENTS" name="NOTICE_CONTENTS" value="${formData.NOTICE_CONTENTS }" width="100%" height="500px" required="false" readOnly="true" disabled="false" />
                </e:field>
            </e:row>
        </e:searchPanel>
		
        <div style="font-weight: normal; text-align: center; font-size:12px; line-height: 30px; margin-right: 10px">
            	※ 이용자는 위 각 정보의 수집∙활용 내용을 충분히 이해하고 동의하였습니다.
        </div>

        <div style="width: 100%; text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <div class="btn_confirm" style="border-radius: 15px; width: 100px; height: 30px; background-color: #223a6a; text-align: center; display: inline-block; cursor: pointer;" onclick="doClose();">
                <span style="color: #fff; font-size: 14px; line-height: 30px;">닫기</span>
            </div>
        </div>
    </e:window>
</e:ui>

