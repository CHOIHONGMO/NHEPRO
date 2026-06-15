<%--*
  * Copyright (c) 2013 ST-Ones (http://www.st-ones.com/) All rights reserved.
  * @LastModified 17. 11. 3 오전 11:05
  --%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<e:ui>
<style>
	p {
		line-height: 3px;
	}
</style>
<script>
	function init() {
		$("#e-window-container-body").css("height", "100%");
		onActiveTab('1');
	}

	function onActiveTab(newTabId, oldTabId, event) {
		if(newTabId == undefined) {
			if($(EVF.C("1").getBoxEl()[0]).css('display') == "block") {
				newTabId = '1';
			} else {
				newTabId = '2';
			}
		}

		var url = '/eversrm/system/management/watcher/doSearch.so';
		if (newTabId === '1') {
			$('#actionType').val("1");
			$.post(url, $('#form').serialize(), function(data) {
				$('#terminal').html(data.logString);
				$('#terminal').append('<input type="text" id="lastIdx" style="width: 0; height: 0; border: 0;">');

				document.getElementById('terminal').innerHTML = document.getElementById('terminal').innerHTML.replace(/\[([a-zA-Z].*?[:]{1}.*?)\]/gm, '[<span style="color: #9ad717;">$1</span>]');
				$('#terminal').show();

				$('#lastIdx').focus();
				$('#lastIdx').blur();
			}, "json");
		} else if (newTabId === '2') {
			if(!${isDev}) {
				$('#actionType').val("2");
				$.post(url, $('#form').serialize(), function(data) {
					$('#terminal2').html(data.logString);
					$('#terminal2').append('<input type="text" id="lastIdx2" style="width: 0; height: 0; border: 0;">');

					document.getElementById('terminal2').innerHTML = document.getElementById('terminal2').innerHTML.replace(/\[([a-zA-Z].*?[:]{1}.*?)\]/gm, '[<span style="color: #9ad717;">$1</span>]');
					$('#terminal2').show();

					$('#lastIdx2').focus();
					$('#lastIdx2').blur();

				}, "json");
			}
		}
	}
</script>
<form id="form" name="form">
	<input type="hidden" id="actionType" name="actionType">
	<div style="display: table;">
		<select id="logType" name="logType" onchange="onActiveTab();" style="height: 23px;">
			<option value="O">operator</option>
			<option value="F">front</option>
		</select>
		&nbsp;
		<div style="display: table-cell; vertical-align: middle; border-radius: 2px; background-color: #ccc; color: #000; font-size: 12px; text-indent: -1px; width: 80px; height: 23px; text-align: center; cursor: pointer;" onclick="javascript:onActiveTab();">새로고침</div>
	</div>
</form>
<br>
<e:window id="watcher" onReady="init" margin="0 4px">
	<e:tabPanel id="log" onActive="onActiveTab">
		<e:tab id="1" title="ServerLog1">
			<pre id="terminal" style="overflow: auto; font-family: Consolas, Inconsolata, Monaco, 'Courier New'; font-size: 12px; color: gray;background-color: #000; border-radius: 3px; padding: 5px; display: none;"></pre>
		</e:tab>
		<c:if test="${isDev ne true}">
			<e:tab id="2" title="ServerLog2">
				<pre id="terminal2" style="overflow: auto; font-family: Consolas, Inconsolata, Monaco, 'Courier New'; font-size: 12px; color: gray;background-color: #000; border-radius: 3px; padding: 5px; display: none;"></pre>
			</e:tab>
		</c:if>
	</e:tabPanel>
</e:window>
</e:ui>