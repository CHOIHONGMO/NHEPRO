<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">
        var addParam = [];
        var baseUrl = "";

        function init() {
            if("${param.attFileNum }" > "") {
                EVF.C("fileAttach").setFileId("${param.attFileNum }");
            }

            <%--$(window).off('unload');--%>
            <%--window.onbeforeunload = function() {--%>
                <%--console.log('AAAAAAAAAAAAAAAAAAA');--%>
                <%--if(opener) {--%>
                    <%--opener.window.focus();--%>
                    <%--opener['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount());--%>
                <%--} else if(parent) {--%>
                    <%--parent['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount());--%>
                    <%--parent.window.focus();--%>
                <%--}--%>
            <%--}--%>
        }

        function onAfterRemove() {
            if(opener) {
                opener.window.focus();
                opener['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName());
            } else if(parent) {
                parent.window.focus();
                parent['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName());
            }
        }

        function doApply() {
            var store = new EVF.Store();
            var fileCount = EVF.C('fileAttach').getFileCount();
            if( fileCount > 0 ) {
	            store.doFileUpload(function() {
	            	// 2021.07.01 첨부파일 업로드 불가 확장자 파일인 경우 업로드는 안되지만 파일 카운트에 포함되는 오류로 인해 수정
	            	if (!EVF.C("fileAttach").fileUploadError) {
	                    onError();
	                } else {
	                	doCallBack();
	                }
	            });
	        } 
            else {
	        	if(opener) {
                    opener.window.focus();
                    opener['${param.callBackFunction}']('${param.rowIdx}', EVF.C('fileAttach').getFileId(), fileCount, "");
                } else if(parent) {
                    parent.window.focus();
                    parent['${param.callBackFunction}']('${param.rowIdx}', EVF.C('fileAttach').getFileId(), fileCount, "");
                }
	        	doClose();
	        }
        }
		
        function doCallBack() {
        	if(opener) {
                opener.window.focus();
                console.log('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName())
                opener['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName());
            } else if(parent) {
                parent.window.focus();
                console.log('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName())
                parent['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,EVF.C('fileAttach').getFileCount(), EVF.C('fileAttach').getFileName());
            }
        }
        
        function doClose() {
            if(opener) {
                window.open("", "_self");
            }
            EVF.closeWindow();
        }
        
        function onError() {
            $(".ui-icon-circle-arrow-w").trigger("click");
            
            var fileId = EVF.C('fileAttach').getFileId();
            var store = new EVF.Store();
            store.setParameter('UUID', fileId);
            if(fileId != null || fileId != ""){
            	store.load("/common/file/fileAttach/dofileCount.so", function () {
            		var fileCount = this.getParameter("FILE_COUNT");
            		if(opener) {
                        opener.window.focus();
                        console.log('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,fileCount, EVF.C('fileAttach').getFileName())
                        opener['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,fileCount, EVF.C('fileAttach').getFileName());
                    } else if(parent) {
                        parent.window.focus();
                        console.log('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,fileCount, EVF.C('fileAttach').getFileName())
                        parent['${param.callBackFunction}']('${param.rowIdx}' ,EVF.C('fileAttach').getFileId() ,fileCount, EVF.C('fileAttach').getFileName());
                    }
                });
            }
        }

    </script>
    <e:window id="commonFileAttach" onReady="init" initData="${initData}" title="첨부파일" breadCrumbs="${breadCrumb }">

        <c:if test="${!param.detailView}">
            <e:buttonBar id="buttonBar" align="right" width="100%">
                <e:button id="doApply" name="doApply" label="적용" onClick="doApply" />
                    <%--<e:button id="doClose" name="doClose" label="닫기" onClick="doClose" />--%>
            </e:buttonBar>
        </c:if>

        <e:searchPanel useTitleBar="false" id="form" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="2">
            <e:row>
                <e:label for="fileAttach" title="첨부파일" />
                <e:field colSpan="3">
                	<e:fileManager id="fileAttach" required="" name="fileAttach"  readOnly="${param.detailView }" fileId="${param.attFileNum}" downloadable="true" width="100%" bizType="${param.bizType}" height="255" onBeforeRemove="onBeforeRemove" onAfterRemove="onAfterRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" fileExtension='${param.fileExtension}' maxFileSize='${param.maxFileSize}' maxFileCount="${empty param.maxFileCount ? 'null' : param.maxFileCount}"/>
                </e:field>
            </e:row>
        </e:searchPanel>

    </e:window>
</e:ui>