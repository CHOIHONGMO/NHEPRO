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
		</style>
	</head>
<body>
	<div align="center">
		<table width="90%" border="0">
			<tr>
			<td align="left"><b>공고번호 </b>&nbsp;${formData.ANN_NO}</td>
			</tr>
		</table>
	</div>

	<br>
	<div align="center">
		<font size="6">입찰공고</font>

		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.공고일반</td></tr>
		</table>

		<table class="tableM">
			<tr>
					<td class="tdM" width="15%" align="center">공&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
					<td class="tdM2" width="85%" colspan="3" align="left">&nbsp;${formData.ANN_ITEM}</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">공&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;법&nbsp;&nbsp;&nbsp;&nbsp;인</td>
					<td class="tdM2" width="35%" align="left">&nbsp;${formData.CUST_NM }</td>
					<td class="tdM" width="15%" align="center">사&nbsp;&nbsp;&nbsp;&nbsp;용&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;법&nbsp;&nbsp;&nbsp;&nbsp;인</td>
					<td class="tdM2" width="35%" align="left">&nbsp;${formData.PR_BUYER_CD }</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">계&nbsp;&nbsp;&nbsp;&nbsp;약&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기&nbsp;&nbsp;&nbsp;&nbsp;간</td>
					<td class="tdM2" align="left">&nbsp;${formData.CONT_TERM }</td>
					<c:if test="${formData.CONT_TYPE2 != 'QE' }">
						<td class="tdM" width="15%" align="center">사&nbsp;&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예&nbsp;&nbsp;&nbsp;&nbsp;산</td>
						<td class="tdM2" align="left">&nbsp;${formData.PR_AMT}</td>
					</c:if>
					<c:if test="${formData.CONT_TYPE2 == 'QE' }">
						<td class="tdM" width="15%" align="center">기&nbsp;&nbsp;&nbsp;&nbsp;초&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가&nbsp;&nbsp;&nbsp;&nbsp;격</td>
						<td class="tdM2" align="left">&nbsp;${formData.BASIC_AMT}</td>
					</c:if>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">정&nbsp;정&nbsp;&nbsp;공&nbsp;고&nbsp;&nbsp;여&nbsp;부</td>
					<td class="tdM2" align="left">&nbsp;${formData.RE_BID_YN }</td>
					<td class="tdM" width="15%" align="center">계&nbsp;약&nbsp;&nbsp;금&nbsp;액&nbsp;&nbsp;구&nbsp;분</td>
					<td class="tdM2" align="left">&nbsp;${formData.CONT_TYPE3_LOC}</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">계&nbsp;&nbsp;&nbsp;&nbsp;약&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;방&nbsp;&nbsp;&nbsp;&nbsp;법</td>
					<td class="tdM2" align="left">&nbsp;${formData.CONT_TYPE1_LOC }</td>
					<td class="tdM" width="15%" align="center">입&nbsp;찰&nbsp;&nbsp;제&nbsp;한&nbsp;&nbsp;횟&nbsp;수</td>
					<td class="tdM2" align="left">&nbsp;${formData.VOTE_LIMIT_CNT }&nbsp;회(재입찰 가능횟수)</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">차&nbsp;액&nbsp;&nbsp;보&nbsp;증&nbsp;&nbsp;여&nbsp;부</td>
					<td class="tdM2" align="left">&nbsp;${formData.DIFF_GUAR_FLAG }</td>
					<td class="tdM" width="15%" align="center">입&nbsp;&nbsp;&nbsp;&nbsp;찰&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장&nbsp;&nbsp;&nbsp;&nbsp;소</td>
					<td class="tdM2" align="left">&nbsp;${formData.APP_PLACE }</td>
			</tr>

			<tr>
					<td class="tdM" width="15%" align="center" rowspan="3">낙&nbsp;찰&nbsp;자&nbsp;결&nbsp;정&nbsp;방&nbsp;법</td>
			</tr>
			<tr>
					<td class="tdM2" align="left" colspan="3">&nbsp;${formData.CONT_TYPE2_LOC }</td>
			</tr>

        <c:if test="${formData.CONT_TYPE2 == 'LP' }"><!-- 최저가 -->
			<tr>
					<td class="tdM2" align="left" colspan="3">
	        <c:if test="${formData.FINA_SOLV_FLAG == '1' }">
					&nbsp;- 예정가격 이하로서 최저가격으로 입찰한 자를 낙찰자로 결정<BR/>
					&nbsp;- 물품구매입찰유의서 제15조에 의하며 동조 1항의 단서조항의 경우 최저가 입찰자가 예정가격의 ${formData.ESTM_LIMIT_RATE}% 미만일 때<br>
					&nbsp;&nbsp;&nbsp;입찰자의 부채·유동비율 평가 시 한국은행의 기업경영분석 통계 자료 중 최근 년도 전산업의 평균유동비율(${formData.RATE_CURR}%) 이상,<br>
					&nbsp;&nbsp;&nbsp;평균부채비율(${formData.RATE_SDEPT}%) 이하를 기준으로 함
			</c:if>
					</td>
			</tr>
		</c:if>
        <c:if test="${formData.CONT_TYPE2 == 'TD' }"><!-- 2단계분리입찰 -->
			<tr>
					<td class="tdM2" align="left" colspan="3">
					&nbsp;- 기술입찰을 실시하여 그중 적격자들만 가격입찰서를 제출하며, 가격입찰자 중 최저가격 입찰자를 낙찰자로 결정함<br>
					&nbsp;&nbsp;&nbsp;(기술적격기준 : 기술평가 ${formData.MIN_TECH_SCORE}점 이상)<BR/>
					&nbsp;- 기술입찰결과 적격자에 한하여 가격입찰 상세일정을 개별 통지함
					</td>
			</tr>
		</c:if>
        <c:if test="${formData.CONT_TYPE2 == 'TS' }"><!-- 2단계동시입찰 -->
			<tr>
					<td class="tdM2" align="left" colspan="3">
					&nbsp;- 기술⦁가격입찰을 동시에 제출하되, 먼저 기술입찰을 개찰하여 적격자로 확정된 자 중에서 최저가격 입찰자를 낙찰자로 <br>
					&nbsp;&nbsp;&nbsp;결정함 (기술적격기준 : 기술평가 ${formData.MIN_TECH_SCORE}점 이상)<BR/>
					&nbsp;- 기술입찰결과 적격자에 한하여 가격입찰 상세일정을 개별 통지하며, 입찰등록 시 제출한 가격서를 가격입찰의  1회차<br>
					&nbsp;&nbsp;&nbsp;가격입찰서로 갈음함
					</td>
			</tr>
		</c:if>
        <c:if test="${formData.CONT_TYPE2 == 'NE' }"><!-- 협상에 의한 낙찰자 선정 -->
        	<c:if test="${formData.BUYER_CD == 'C00009'}">
        		<c:if test="${formData.REF_BUYER_CD == 'C08759'}">
        			<tr>
						<td class="tdM2" align="left" colspan="3">
						&nbsp;- 기술평가점수(${formData.TECH_SCORE}점)와 가격평가점수(${formData.PRC_SCORE}점)를 종합 평가한 결과 ${formData.MIN_TOT_SCORE}점 이상인 자를 협상적격자로 선정<br>
						&nbsp;&nbsp;&nbsp;(단, 기술평가점수 ${formData.TECH_SCORE}점 중 ${formData.MIN_TECH_SCORE}점 이상)<BR/>
						&nbsp;- 협상방법 : 최고득점 업체를 대상으로 협상을 진행하되, 협상결과 적합하지 않을 경우 순차적으로 차 순위 업체와 협상<BR/>
						&nbsp;- 세부평가항목과 방법은 제안요청서 참조
						</td>
					</tr>
        		</c:if>
        		<c:if test="${formData.REF_BUYER_CD != 'C08759'}">
        			<c:if test="${formData.ANN_TO_DATE == 'N' }">
						<tr>
								<td class="tdM2" align="left" colspan="3">
								&nbsp;- 기술평가점수(${formData.TECH_SCORE}점)와 가격평가점수(${formData.PRC_SCORE}점)<br>
								&nbsp;- 입찰가격이 사업예산 이하이며 기술평가점수가 기술평가 배점한도 85% 이상인자를 협상적격자로 선정<br>
								&nbsp;&nbsp;&nbsp;기술평가점수 ${formData.TECH_SCORE}점 중 ${formData.MIN_TECH_SCORE}점 이상<BR/>
								&nbsp;- 협상방법 : 최고득점 업체를 대상으로 협상을 진행하되, 협상결과 적합하지 않을 경우 순차적으로 차 순위 업체와 협상<BR/>
								&nbsp;- 세부평가항목과 방법은 제안요청서 참조
								</td>
						</tr>
					</c:if>
					<c:if test="${formData.ANN_TO_DATE == 'Y' }">
						<tr>
							<td class="tdM2" align="left" colspan="3">
							&nbsp;- 기술평가점수(${formData.TECH_SCORE}점)와 가격평가점수(${formData.PRC_SCORE}점)를 종합 평가한 결과 ${formData.MIN_TOT_SCORE}점 이상인 자를 협상적격자로 선정<br>
							&nbsp;&nbsp;&nbsp;(단, 기술평가점수 ${formData.TECH_SCORE}점 중 ${formData.MIN_TECH_SCORE}점 이상)<BR/>
							&nbsp;- 협상방법 : 최고득점 업체를 대상으로 협상을 진행하되, 협상결과 적합하지 않을 경우 순차적으로 차 순위 업체와 협상<BR/>
							&nbsp;- 세부평가항목과 방법은 제안요청서 참조
							</td>
						</tr>
					</c:if>
        		</c:if>
			</c:if>
			<c:if test="${formData.BUYER_CD != 'C00009' }">
				<tr>
					<td class="tdM2" align="left" colspan="3">
					&nbsp;- 기술평가점수(${formData.TECH_SCORE}점)와 가격평가점수(${formData.PRC_SCORE}점)를 종합 평가한 결과 ${formData.MIN_TOT_SCORE}점 이상인 자를 협상적격자로 선정<br>
					&nbsp;&nbsp;&nbsp;(단, 기술평가점수 ${formData.TECH_SCORE}점 중 ${formData.MIN_TECH_SCORE}점 이상)<BR/>
					&nbsp;- 협상방법 : 최고득점 업체를 대상으로 협상을 진행하되, 협상결과 적합하지 않을 경우 순차적으로 차 순위 업체와 협상<BR/>
					&nbsp;- 세부평가항목과 방법은 제안요청서 참조
					</td>
				</tr>
			</c:if>
		</c:if>
        <c:if test="${formData.CONT_TYPE2 == 'QE' }"><!-- 적격심사 -->
			<tr>
					<td class="tdM2" align="left" colspan="3">
					&nbsp;- 예정가격 이하이고 낙찰하한률 이상의 가격으로 입찰한 자를 적격심사 대상자로 선정<BR/>
					&nbsp;- 심사방법 : 상기의 적격심사 대상자 중 입찰가격이 낮은 입찰자부터 우선하여 순차적으로 적격심사를 실시하고,<br>
					&nbsp;&nbsp;&nbsp;종합평점이 ${formData.CONF_STD_SCORE}점 이상일 경우 낙찰자로 결정<BR/>
					&nbsp;- 적격심사 종합평점 ${formData.CONF_STD_SCORE}점 이상, 낙찰하한율 ${formData.SB_LIMIT_RATE}%<BR/>
					</td>
			</tr>
		</c:if>
			<tr>
					<td class="tdM" width="15%" align="center">입&nbsp;찰&nbsp;&nbsp;참&nbsp;가&nbsp;&nbsp;자&nbsp;격</td>
					<td class="tdM2" colspan="3" align="left">
					&nbsp;${formData.LIMIT_CRIT}
					</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.입 찰 일 정</td></tr>
		</table>
		<table class="tableM">
			<tr>
					<td class="tdM" width="15%" align="center">구 분</td>
					<td class="tdM" width="35%" align="center">일 시</td>
					<td class="tdM" width="25%" align="center">장 소</td>
					<td class="tdM" width="25%" align="center">비 고</td>
			</tr>
			<tr>
					<td class="tdM2" align="center">입&nbsp;&nbsp;&nbsp;&nbsp;찰&nbsp;&nbsp;&nbsp;&nbsp;등&nbsp;&nbsp;&nbsp;&nbsp;록</td>
					<td class="tdM2" align="center">${formData.APP_BEGIN} ~ ${formData.APP_END}</td>
					<td class="tdM2" align="center">${formData.APP_PLACE }</td>
					<td class="tdM2" align="left"></td>
			</tr>

        <c:if test="${formData.CONT_TYPE2 != 'TD' }"><!-- 2단계분리입찰이 아닌 경우 -->
			<tr>
					<td class="tdM2" align="center">입&nbsp;&nbsp;찰&nbsp;&nbsp;서&nbsp;&nbsp;&nbsp;제&nbsp;&nbsp;출</td>
					<td class="tdM2" align="center">${formData.BID_BEGIN} ~ ${formData.BID_END}</td>
					<td class="tdM2" align="center">${formData.APP_PLACE }</td>
					<td class="tdM2" align="left"></td>
			</tr>
			<c:if test="${formData.CONT_TYPE2 != 'NE' }"><!-- 협상에 의한 낙찰자 선정이 아닌 경우 -->
				<tr>
					<td class="tdM2" align="center">개&nbsp;&nbsp;&nbsp;&nbsp;찰&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;시</td>
					<td class="tdM2" align="center">${formData.OPENTIME}</td>
					<td class="tdM2" align="center">${formData.APP_PLACE }</td>
					<td class="tdM2" align="left"></td>
				</tr>
			</c:if>
        </c:if>

		</table>

<c:if test="${formData.ANNO_OPEN_FLAG == '1' || formData.PROP_OPEN_FLAG == '1' }">
		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.설명회 일정</td></tr>
		</table>
		<table class="tableM">
			<tr>
					<td class="tdM" width="15%" align="center">구 분</td>
					<td class="tdM" width="15%" align="center">일 시</td>
					<td class="tdM" width="20%" align="center">장 소</td>
					<td class="tdM" width="15%" align="center">필수참석여부</td>
					<td class="tdM" width="35%" align="center">비 고</td>
			</tr>
<c:if test="${formData.ANNO_OPEN_FLAG == '1' }">
			<tr>
					<td class="tdM2" align="center">사&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;설&nbsp;&nbsp;명&nbsp;&nbsp;회</td>
					<td class="tdM2" align="center">${formData.ANNO_DATE}</td>
					<td class="tdM2" align="center">${formData.ANNO_PLACE}</td>
					<td class="tdM2" align="center">${formData.ANNO_FLAG}</td>
					<td class="tdM2" align="center">${formData.ANNO_RMK}</td>
			</tr>
</c:if>
<c:if test="${formData.PROP_OPEN_FLAG == '1' }">
			<tr>
					<td class="tdM2" align="center">제&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;설&nbsp;&nbsp;명&nbsp;&nbsp;회</td>
					<td class="tdM2" align="center">${formData.PROP_DATE}</td>
					<td class="tdM2" align="center">${formData.PROP_PLACE}</td>
					<td class="tdM2" align="center">${formData.PROP_FLAG}</td>
					<td class="tdM2" align="center">${formData.PROP_RMK}</td>
			</tr>
</c:if>
		</table>
</c:if>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.입찰보증금</td></tr>
		</table>

		<table width="90%" border="0">
			<tr>
					<td colspan="4" align="left">
						&nbsp;○ 입찰참가자는 입찰신청(제안서 제출) 마감일까지 입찰금액(부가세포함)의 100분의 5 이상의 입찰보증금을 현금(체신관서 또는 「은행법」의 적용을 받는 금융기관이 발행한 자기앞수표 포함) 또는 농협이 인정하는 보증서 등으로 납부하여야 함
					</td>
			</tr>
		</table>

		<table class="tableM">
			<tr>
					<td class="tdM" width="15%" align="center">피&nbsp;보&nbsp;증&nbsp;(보험)자</td>
					<td class="tdM2" colspan="3" align="center">${formData.CUST_NM }&nbsp;(사업자번호:${formData.IRS_NUM })</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">입&nbsp;&nbsp;&nbsp;&nbsp;찰&nbsp;&nbsp;&nbsp;&nbsp;건&nbsp;&nbsp;&nbsp;&nbsp;명</td>
					<td class="tdM2" width="35%" align="center">${formData.ANN_ITEM }</td>
					<td class="tdM" width="15%" align="center">사&nbsp;&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;&nbsp;법&nbsp;&nbsp;&nbsp;&nbsp;인</td>
					<td class="tdM2" width="35%" align="center">${formData.PR_BUYER_CD }</td>
			</tr>
		</table>

		<table width="90%" border="0">
			<tr>
					<td colspan="4" align="left">
						&nbsp;○ 협상대상자가 협상이 성립된 날로부터
					<c:if test="${formData.CONT_TYPE2 == 'LP' }">
						5일
					</c:if>
					<c:if test="${formData.CONT_TYPE2 != 'LP' }">
						10일
					</c:if>
						이내에 계약을 체결하지 아니할 때에는 납부한 입찰보증금은 농협에 귀속하며, 부정당업자 제재를 받을 수 있음
					</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.담당자 문의관련</td></tr>
		</table>

		<table class="tableM">
			<tr>
					<td class="tdM" width="15%" align="center">입찰사무관련문의</td>
					<td class="tdM2" colspan="3" align="center">${formData.BID_USER_TEXT }</td>
			</tr>
			<tr>
					<td class="tdM" width="15%" align="center">사업내용관련문의</td>
					<td class="tdM2" colspan="3" align="center">${formData.PR_USER_TEXT.replaceAll('MAKEBR','<BR>')}</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.입찰무효</td></tr>
		</table>
		<table width="90%" border="0">
			<tr>
					<td colspan="4" align="left">
						&nbsp;○ 입찰참가자격이 없는 자가 행한 입찰 또는 입찰조건에 위배되는 입찰은 무효로 함
					</td>
			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.본 계약은 청렴계약 이행 대상 계약임</td></tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.참고사항</td></tr>
		</table>
		<table width="90%" border="0">
			<tr>
				<td align="left">&nbsp;○ 제안요청내용, 계약조건, 입찰유의서 등 본 입찰에 관한 제반사항을 완전히 숙지하고 입찰에 응해야하며, 숙지하지 못하여 발생한 책임은 입찰자에 있음<br/>
  								 &nbsp;○ 평가와 관련해서 발생되는 모든 사안에 대하여 대외비로 취급하며, 제출된 모든 문서는 심의평가를 위한 경우를 제외하고는 공개 및 반환하지 않음
  				</td>
  			</tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.기타사항</td></tr>
		</table>
		<table width="90%" border="0">
			<tr><td align="left" style="padding-left: 5px !important;">
				${APP_ETC}
  		</td></tr>
		</table>

		<br>
		<table width="90%" border="0">
			<tr><td class="hDefault" align="left"><%=cou++%>.붙임파일</td></tr>
		</table>
		<table width="90%" border="0">
			<tr><td align="left">
				<c:forEach items="${formData.ATT_FILE}" var="file" varStatus="status">
					&nbsp;<a target="fileDown" href="/common/file/fileAttach/download.so?UUID=${file.UUID}&UUID_SQ=${file.UUID_SQ}">${file.REAL_FILE_NM}</a><BR/>
				</c:forEach>
  		</td></tr>
		</table>

		<br>
		<br>
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td align="center"><font size="4">이상과 같이 공고합니다</font></td></tr>
		</table>

		<br>
		<br>
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
		<br>
		<br>
		<table width="90%" border="0">
			<tr><td align="center"><font size="5">${formData.CUST_NM }</font></td></tr>
		</table>
		<br>
		<br>

	</div>
	<iframe name="fileDown" src="" width="0" height="0"></iframe>
</body>
</html>
