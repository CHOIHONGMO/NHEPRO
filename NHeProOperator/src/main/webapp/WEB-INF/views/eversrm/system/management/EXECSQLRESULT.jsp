<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script>

        var cnt = 0;
        var baseUrl = '/eversrm/system/management/EXECSQL';
        var grid1 = {};

        function init() {

           	grid1 = new EVF.C('grid1');

            <c:forEach varStatus="status" var="columnx" items="${COLUMN}">
        		grid1.createColumn('${columnx.colm}', '${columnx.colm}', 130, 'center', 'text', 50, false,false, '', 0);
			</c:forEach>

            grid1.excelExportEvent({
                allItems : "${excelExport.allCol}",
                fileName : "${screenName }"
            });

	    	<c:if test="${param.TYPE=='S'}">
				doSearch();
	    	</c:if>
	    	<c:if test="${param.TYPE=='T'}">
				EVF.alert('${message}');
	    	</c:if>
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid1]);
            store.load(baseUrl+'/doSearch.so', function() {
				$('.e-panel-titlebar').css('width', '');
			});
        }

    </script>

    <e:window id="EXECSQLRESULT" onReady="init" initData="${initData}">
        <e:searchPanel id="form" title="SQL" columnCount="1" useTitleBar="true">
            <e:row>
                <e:label for="MESSAGE1" title="SQL"/>
                <e:field>
                    <e:textArea id="SQL" name="SQL" value="${param.SQL }" required="" disabled="" readOnly="" maxLength="" width="100%" height="200"/>
                </e:field>
            </e:row>
        </e:searchPanel>

		<e:gridPanel gridType="${_gridType}" id="grid1" name="grid1" width="100%" height="fit" readOnly="${param.detailView}"/>
    </e:window>
</e:ui>