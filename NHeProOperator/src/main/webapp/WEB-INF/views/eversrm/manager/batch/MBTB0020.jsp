<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
	<script type="text/javascript">

	var baseUrl = "/eversrm/manager/batch/MBTB0020";

	function init() {
		EVF.C('EXEC_CD').removeOption('SWGuar');
	    EVF.C('EXEC_CD').removeOption('SGGuar');
    }

    function doExecute() {

        var store = new EVF.Store();
        if(!store.validate()) return;

    	EVF.confirm("${msg.M8888 }", function() {
        	store.load(baseUrl + '/doExecute.so', function(){
        		EVF.alert(this.getResponseMessage());
        	});
    	});
    }
	
    </script>

	<e:window id="MBTB0020" onReady="init" initData="${initData}" title="${fullScreenName}" breadCrumbs="${breadCrumb }">
		<e:searchPanel id="form" title="${msg.M9999 }" columnCount="2" labelWidth="200" useTitleBar="false">
			<e:row>
				<e:label for="EXEC_CD" title="${form_EXEC_CD_N}" />
				<e:field colSpan="3">
					<e:select id="EXEC_CD" name="EXEC_CD" value="" options="${execCdOptions }" width="${form_EXEC_CD_W}" disabled="${form_EXEC_CD_D}" readOnly="${form_EXEC_CD_RO}" required="${form_EXEC_CD_R}" placeHolder=""  maskType="${form_EXEC_CD_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="BUYER_CD" title="BUYER_CD(BNH0011)" />
				<e:field>
				<e:inputText id="BUYER_CD" name="BUYER_CD" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>

				<e:label for="CONT_NUM" title="CONT_NUM(BNH0011)" />
				<e:field>
				<e:inputText id="CONT_NUM" name="CONT_NUM" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="CUST_CD" title="CUST_CD(BNH0012)" />
				<e:field colSpan="3">
				<e:inputText id="CUST_CD" name="CUST_CD" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
			</e:row>
			<e:row>
				<e:label for="FROMDATE" title="FROMDATE(BNH0021)" />
				<e:field>
				<e:inputText id="FROMDATE" name="FROMDATE" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>

				<e:label for="TODATE" title="TODATE(BNH0021)" />
				<e:field>
				<e:inputText id="TODATE" name="TODATE" value="" width="${form_CONT_NUM_W}" maxLength="${form_CONT_NUM_M}" disabled="${form_CONT_NUM_D}" readOnly="${form_CONT_NUM_RO}" required="${form_CONT_NUM_R}" style="${imeMode}" maskType="${form_CONT_NUM_MT}"/>
				</e:field>
			</e:row>			
		</e:searchPanel>

		<e:buttonBar id="buttonBar" align="right" width="100%">
			<e:button id="doExecute" name="doExecute" label="${doExecute_N}" onClick="doExecute" disabled="${doExecute_D}" visible="${doExecute_V}" />
		</e:buttonBar>
	</e:window>
</e:ui>
