<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script type="text/javascript">
	
    var baseUrl = '/nhepro/CTPI/CTPU0040';

    function init() {


          
    }
    
    function doRefund(){
    	var inputAmt = EVF.V("RFDM_PNT");
    	
    	// 입력 금액 1000원 이하
    	if( inputAmt < 1000 ){
    		// 1000원이상 입력하세요
    		return EVF.alert('${CTPU0040_0001}');
    	}
    	
    	
    	// 환불 가능한 금액  >= 입력한 금액  
    	var canRefund =  ${AMOUNT} >= inputAmt  ;
    	if( !canRefund ){
    		// 입력한 금액이 환불 가능 금액보다  큽니다
    		return EVF.alert('${CTPU0040_0002}');
    	}
    	
    	var store = new EVF.Store();
        if(!store.validate()) return;
        store.load(baseUrl+'/doRefund.so', function() {
        	EVF.alert(this.getResponseMessage());
        });
    }
    

	
	
  </script>

  <e:window id="CTPU0040" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <e:text style="font-weight: bold; font-size: 14px; color: #222222" width="300px" >■ 잔여 이용권 환불 신청 안내&nbsp;:&nbsp;&nbsp;</e:text>
    <e:br/>
    <e:text id="">
&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;잔여 이용권에 대해서 환불신청이 가능합니다. (단, 1000원 미만의 이용권은 환불 불가 <e:br/>
&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;이용권 환불 신청 시 환불신청 이용권에 대하여 이용이 금지되며, 경우에 따라 환불에 필요한 서류 (사업자등록증사본, 사업자명의 통장사본)를 추가로 요구할 수 있습니다<e:br/>
&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;계좌이체 환불 대상은 신청 익월 초에 고객님의 요청계좌로 입금됩니다<e:br/>
&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;이용권 결제일 30일 이내 환불 신청시 환불(신청)금액*1.1 금액이 환불(결제일부취소)되며 30일 이후는 환불(신청)금액만 계좌이체 됩니다<e:br/>
&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;환불금액에 대하여 별도의 음수 세금계산서는 발행되지 않습니다. (단, 결제일부취소는 음수 신용카드 전표 / 현금영수증 발행 됨.
    </e:text>
    <e:br/>&nbsp;
    <e:br/>&nbsp;
    <e:text style="font-weight: bold; font-size: 14px; color: #222222" width="300px" >■ 환불금액 안내</e:text>
    <e:br/>
    <e:searchPanel id="form1" title="${msg.M9999}" labelWidth="100%" width="80%" columnCount="1" useTitleBar="false" >
    	<e:field>
    		<e:text >${ses.userNm} ${CORP_NUM} 님의 환불가능한 금액은</e:text>
    		<e:text style="font-weight: bold; font-size: 14px; color: #222222"> ${AMOUNT}원</e:text>
    		<e:text> 입니다.</e:text>
    	</e:field>
    </e:searchPanel>
    <e:br/>
   <e:br/>
   
	<e:text style="font-weight: bold; font-size: 14px; color: #222222" width="300px" >■ 환불신청 정보</e:text>  
    <e:searchPanel id="form2" title="${msg.M9999}" labelWidth="150" width="85%" columnCount="3" useTitleBar="false" onEnter="doSearch" >
    <e:inputHidden id='AMOUNT' name='AMOUNT' value='${AMOUNT}'/>
     <e:br/>
    	<e:row>
    		<!-- 요청자 -->
	    	<e:label for="RQ_RGMN" title="${form2_RQ_RGMN_N}" />
			<e:field >
				<e:inputText id="RQ_RGMN" name="RQ_RGMN" value="" width="${form2_RQ_RGMN_W}" maxLength="${form2_RQ_RGMN_M}" disabled="${form2_RQ_RGMN_D}" readOnly="${form2_RQ_RGMN_RO}" required="${form2_RQ_RGMN_R}" style="${imeMode}" maskType="${form2_RQ_RGMN_MT}"/>
			</e:field>
			<!-- 금액 -->
			<e:label for="RFDM_PNT" title="${form2_RFDM_PNT_N}" />
			<e:field>
				<e:inputText id="RFDM_PNT" name="RFDM_PNT" value="" width="90%" maxLength="${form2_RFDM_PNT_M}" disabled="${form2_RFDM_PNT_D}" readOnly="${form2_RFDM_PNT_RO}" required="${form2_RFDM_PNT_R}" style="${imeMode}" maskType="${form2_RFDM_PNT_MT}"/>
				<e:text width="10%">원</e:text>
			</e:field>
		</e:row>
		<e:row>
			<!-- 환불계좌, 계좌번호 -->
			<e:label for="BANK_CD" title="${form2_BANK_CD_N}"/>
			<e:field colSpan="3">
				<e:select id="BANK_CD" name="BANK_CD" value="" options="${bankCdOptions}" width="35%" disabled="${form2_BANK_CD_D}" readOnly="${form2_BANK_CD_RO}" required="${form2_BANK_CD_R}" placeHolder="" maskType="${form2_BANK_CD_MT}" />
				<e:inputText  id="ACNO" name="ACNO" value="" width="65%" maxLength="${form2_ACNO_M}" disabled="${form2_ACNO_D}" readOnly="${form2_ACNO_RO}" required="${form2_ACNO_R}" style="${imeMode}" maskType="${form2_ACNO_MT}"/>
			</e:field>
			<!-- 예금주 -->
			<e:label for="DPRNM" title="${form2_DPRNM_N}" />
			<e:field>
				<e:inputText id="DPRNM" name="DPRNM" value="" width="${form2_DPRNM_W}" maxLength="${form2_DPRNM_M}" disabled="${form2_DPRNM_D}" readOnly="${form2_DPRNM_RO}" required="${form2_DPRNM_R}" style="${imeMode}" maskType="${form2_DPRNM_MT}"/>
			</e:field>
		</e:row>
    </e:searchPanel>
     <e:br/>
    <e:buttonBar width="100%" >
    	<e:button id="doRefund" name="doRefund" label="${doRefund_N}" onClick="doRefund" disabled="${doRefund_D}" visible="${doRefund_V}"/>
    </e:buttonBar>
    
  </e:window>
</e:ui>
