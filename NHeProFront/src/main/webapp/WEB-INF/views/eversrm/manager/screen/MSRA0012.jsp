<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript">

    	var addParam = [];
    	var baseUrl = "/eversrm/manager/screen/";

		function init() {

		}

        function doSave() {

			if ( EVF.V('CONTENTS') == '') {
				return EVF.alert("${BSYS_040_MSG1 }");
			}

			EVF.confirm("${msg.M0011 }", function() {
				var store = new EVF.Store();
				if(!store.validate()) return;

				store.doFileUpload(function() {
					store.load(baseUrl + 'helpInfo/doSave.so', function(){
						EVF.alert(this.getResponseMessage());
						opener.doSearch();
						EVF.closeWindow();
					});
				});
			});
        }

        function doDelete() {

        	EVF.confirm("${msg.M0013 }", function() {
				var store = new EVF.Store();
				store.load(baseUrl + 'helpInfo/doDelete.so', function(){
					EVF.alert(this.getResponseMessage());
					opener.doSearch();
					EVF.closeWindow();
				});
			});
        }

        function doClose() {
        	EVF.closeWindow();
        }

	</script>
    <e:window id="MSRA0012" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doSave" name="doSave"  label="${doSave_N }" disabled="${doSave_D }" onClick="doSave" visible="${doSave_V}"/>
			<e:button id="doDelete" name="doDelete" label="${doDelete_N }" disabled="${doDelete_D }" onClick="doDelete" visible="${doDelete_V}"/>
			<e:button id="doClose" name="doClose" label="${doClose_N }" disabled="${doClose_D }" onClick="doClose" visible="${doClose_V}"/>
		</e:buttonBar>
		<e:searchPanel id="form" useTitleBar="false" title="${form_CAPTION_N }" labelWidth="${labelWidth}" width="100%" columnCount="1">
			<e:row>
				<e:field colSpan="2">
					<e:richTextEditor height="450px" id="CONTENTS" name="CONTENTS" width="100%" required="${form_TEXT_CONTENTS_R }" readOnly="${param.detailView }" disabled="${form_TEXT_CONTENTS_D }" value="${formData.CONTENTS }" />
					<e:inputHidden id="HELP_TEXT_NUM" name="HELP_TEXT_NUM" value="${formData.HELP_TEXT_NUM }" />
					<e:inputHidden id="SCREEN_ID" name="SCREEN_ID" value="${formData.SCREEN_ID }" />
 				</e:field>
 			</e:row>
 			<e:row>
                <e:field colSpan="2">
                    <e:fileManager id="HELP_ATT_FILE_NUM" name="HELP_ATT_FILE_NUM" readOnly="${param.detailView ? true : false}"  fileId="${formData.HELP_ATT_FILE_NUM}" downloadable="true" width="100%" bizType="SR" height="120px" onBeforeRemove="onBeforeRemove" onError="onError" onFileClick="onFileClick" onSuccess="onSuccess" required="" />
 				</e:field>
 			</e:row>
		</e:searchPanel>
    </e:window>
</e:ui>