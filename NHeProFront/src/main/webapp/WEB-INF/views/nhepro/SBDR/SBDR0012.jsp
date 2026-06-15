<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	int cou=1;
%>
<html>
	<head>
		<style>
			.tableM {
				width : 90%;
				border : 1px solid #444444;
				border-collapse : collapse;
			}
			.tdM {
				border : 1px solid #444444;
				background-color : #bbdefb;
			}
			.tdM2 {
				border : 1px solid #444444;
			}
			.hDefault {
				font-size: 12.5pt;
				line-height: 15px;
				font-weight: bold;
			}
			.hDefault2 {
				font-size: 12.5pt;
				line-height: 15px;
			}
		</style>
	</head>
<body>
	<div align="center">
		<table width="90%" border="0">
			<tr>
				<td align="left"><b>&nbsp;</b></td>
			</tr>
		</table>
	</div>

	<br>
	<div align="center">
		<font size="6">입찰취소공고</font>

		<br>
		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr>
				<td class="hDefault"  align="left" width="15%"><%=cou++%>.&nbsp;공 고 번 호 :</td>
				<td class="hDefault2" align="left" width="85%">${formData.ANN_NO}</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr>
				<td class="hDefault"  align="left" width="15%"><%=cou++%>.&nbsp;입 찰 건 명 :</td>
				<td class="hDefault2" align="left" width="85%">${formData.ANN_ITEM}</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.&nbsp;취 소 사 유</td></tr>
		</table>
		<table width="90%" border="0">
			<tr>
				<td align="left" style="padding-left: 10px !important;">
				${CANCEL_RMK}
  				</td>
  			</tr>
		</table>

		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td align="center"><font size="4">이상과 같이 취소공고합니다</font></td></tr>
		</table>

		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td align="center">
			${fn:substring(formData.ANN_DATE,0,4) }년
			${fn:substring(formData.ANN_DATE,4,6) }월
			${fn:substring(formData.ANN_DATE,6,8) }일
			</td></tr>
		</table>

		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td align="center"><font size="5">${formData.CUST_NM }</font></td></tr>
		</table>
		<br>
		<br>
	</div>
</body>
</html>
