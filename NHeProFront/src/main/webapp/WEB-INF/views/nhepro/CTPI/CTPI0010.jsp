<%--
  Date: 2020-06-19
  Time: 17:20:15
  Scrren ID : CTPI0010
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	response.addHeader("Access-Control-Allow-Origin", "*");
%>
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
  <script>
	
  	
    var baseUrl = '/nhepro/CTPI/CTPI0010'
    	, payMethod = "CARD"
    	, amtVal = 0
    	, goodsName = "epro_point"
    ;

    function init() {
    }
    

    function doBuy() {
		
    	var amt = EVF.V("total");
    	var isPriceEmpty = amt ==="" || amt === "0";
    	if( isPriceEmpty ){
    		// 가격을 입력하세요
    		return EVF.alert('${CTPI0010_0001}');
    	}
    	
    	if ( isNaN(amtVal) ){
    		// 숫자만 입력가능합니다
    		return EVF.alert('${CTPI0010_0002}');
    	}
    	
    	if ( amtVal < 1000 ){
    		// 1000원이상 입력하세요
    		return EVF.alert('${CTPI0010_0003}');
    	}
    	
    	
    	var param = {
    			"total" : parseInt(amtVal),
    			"payMethod" : payMethod,
    			"buyerName" : EVF.V("buyerName"),
    			"userId" : "${ses.userId}",
    			"payActionUrl" : "",
    			"goodsName" : goodsName
    			
    	};
    	everPopup.createWindowPopup('/nhepro/CTPI/CTPI0010/doBuy.so', '1000', '800', param, '', true);
    }
    
    function doBuy2() {
		
    	var amt = EVF.V("total");
    	var isPriceEmpty = amt ==="" || amt === "0";
    	if( isPriceEmpty ){
    		// 가격을 입력하세요
    		return EVF.alert('${CTPI0010_0001}');
    	}
    	
    	if ( isNaN(amtVal) ){
    		// 숫자만 입력가능합니다
    		return EVF.alert('${CTPI0010_0002}');
    	}
    	
    	if ( amtVal < 1000 ){
    		// 1000원이상 입력하세요
    		return EVF.alert('${CTPI0010_0003}');
    	}
    	
    	
    	var param = {
    			"total" : parseInt(amtVal),
    			"payMethod" : payMethod,
    			"buyerName" : EVF.V("buyerName"),
    			"userId" : "${ses.userId}",
    			"payActionUrl" : "",
    			"goodsName" : goodsName
    			
    	};
    	everPopup.createWindowPopup('/nhepro/CTPI/CTPI0010/doBuy2.so', '1000', '800', param, '', true);
    }    
    
    function checkPayMethodRadio() {

        var clickBtn = this.getData().data;
        payMethod = clickBtn;
        if(clickBtn == "CARD") {
            EVF.C("CARD").setChecked(true);
            EVF.C("BANK").setChecked(false);
        }
        else if(clickBtn == "BANK") {
            EVF.C("CARD").setChecked(false);
            EVF.C("BANK").setChecked(true);
        }
    }
    
   
    function checkFree(){
   		EVF.V("total",0);
   		EVF.V("amt","");
   		 // 활성화
   		EVF.C("amt").setDisabled(false);
   		goodsName = "epro_point";	 
    }
   
	function checkValue(){
		// 비활성화
   		EVF.C("amt").setDisabled(true);
   		EVF.V("amt","");
		
   		var value = this.getData().data;
   		amtVal = value * 1.1;
   		goodsName = this.getData().value;
   		
   		EVF.V("total", numberWithCommas(value * 1.1) ) ;
    }
	
	
	
	function handleKeyDown(e){
		
		
		var value = EVF.C("amt").getValue();
		amtVal = value * 1.1;
		EVF.V("total",  numberWithCommas(value * 1.1) );
	}
	
	// 숫자 3단위마다 콤마 
	function numberWithCommas(num){
		num = Math.round(num);
		return  num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")  ; 
	}
	
	
	
  </script>

  <e:window id="CTPI0010" initData="${initData}" onReady="init" title="${fullScreenName }" breadCrumbs="${breadCrumb }">
    <e:searchPanel id="form" title="${msg.M9999}" labelWidth="150" width="65%" columnCount="1" useTitleBar="false" onEnter="doSearch">
	 <c:set var="amtList2" value="${amtList}"/>
	 <c:set var="amtListLength" value="${amtList.size()}"/>
	 
	 <!-- 금액 -->
      <e:row>
      <e:label for="amt" title="${form_amt_N}" />
	  <e:field>
	  		<e:radioGroup id="AMOUNT_TYPE" name="AMOUNT_TYPE" disabled="" readOnly="" required="">
				<c:forEach items="${amtList2}" varStatus="status" var="item">
					<e:radio id="R${status.count}" name="R${status.count}" label="${item.AMT_COMMA}" value="${item.SIMP_C}" checked="false" readOnly="false" disabled="false"  onClick="checkValue" data="${item.AMN_HDNG_EXPL3}"/> 
					<e:br/>
				</c:forEach>
				<!--  
	            <e:radio id="R${amtListLength+1}" name="R${amtListLength+1}" label="직접입력" value="" checked="false" readOnly="false" disabled="false"  onClick="checkFree"/> 
				<e:inputText id="amt" name="amt" value="" width="${form_amt_W}" maxLength="${form_amt_M}" disabled="${form_amt_D}" readOnly="${form_amt_RO}" required="${form_amt_R}" style="${imeMode}" maskType="${form_amt_MT}" onKeyUp="handleKeyDown"/>
	  			-->
	  		</e:radioGroup>
	  </e:field>
      </e:row>
      
      <!-- 결제 금액(VAT포함) -->
      <e:row>
		<e:label for="total" title="${form_total_N}" />
		<e:field>
			<e:inputText id="total" name="total" value="" width="${form_total_W}" maxLength="${form_total_M}" disabled="${form_total_D}" readOnly="${form_total_RO}" required="${form_total_R}" style="${imeMode}" maskType="${form_total_MT}" />
		</e:field>
	  </e:row>
	  
	  <!-- 결제자 -->
      <e:row>
		<e:label for="buyerName" title="${form_buyerName_N}" />
		<e:field>
			<e:select id="buyerNameOption" name="buyerNameOption" value="COMPANY" options="${buyernameoptionOptions}" width="${form_buyerNameOption_W}" disabled="${form_buyerNameOption_D}" readOnly="${form_buyerNameOption_RO}" required="${form_buyerNameOption_R}" placeHolder="" maskType="${form_buyerNameOption_MT}" />
			<e:inputText id="buyerName" name="buyerName" value="${ses.companyNm}" width="${form_buyerName_W}" maxLength="${form_buyerName_M}" disabled="${form_buyerName_D}" readOnly="${form_buyerName_RO}" required="${form_buyerName_R}" style="${imeMode}" maskType="${form_buyerName_MT}"/>
		</e:field>
	  </e:row>
	  
	  <!-- 결제수단 -->
	  <e:row>
	  	<e:label for="payMethod" title="${form_payMethod_N}"/>
		<e:field>
		 	<e:radioGroup id="PAY_METHOD_TYPE" name="PAY_METHOD_TYPE" disabled="" readOnly="" required="">
				<e:radio id="CARD" name="CARD" label="신용카드" value="CARD" checked="true" readOnly="false" disabled="false" onClick="checkPayMethodRadio" data="CARD" />
	            <e:radio id="BANK" name="BANK" label="계좌이체" value="BANK" checked="false" readOnly="false" disabled="false" onClick="checkPayMethodRadio" data="BANK" />
	  		</e:radioGroup>
	  	</e:field>
	  </e:row>
    </e:searchPanel>
    <e:buttonBar width="100%" align="left">
      <e:button id="doBuy" name="doBuy" label="${doBuy_N}" onClick="doBuy2" disabled="${doBuy_D}" visible="${doBuy_V}"/>
    </e:buttonBar>
    
    
		<!-- 임시
		<!-- div align="right">
			<a href="javascript:doBuy2();">&nbsp;&nbsp;</a>
		</div-->    
  </e:window>
</e:ui>
