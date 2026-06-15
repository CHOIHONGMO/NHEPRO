<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="Referrer" content="origin">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="apple-mobile-web-app-title" content="FIRSTePro"/>
	<meta name="robots" content="index,nofollow"/>
	<meta name="description" content="FIRSTePro"/>
	<meta name="keywords" content="FIRSTePro"/>
	<meta name="format-detection" content="telephone=no"/>
	<title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
	<link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">

	<script type="text/javascript" src="/js/nhepro/bundle.js"></script>
	<script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
	<script type="text/javascript" src="/js/jquery.serializeObject.js"></script>
	<script type="text/javascript" src="/js/everuxf/lic/licenseKey.js"></script>
	<script type="text/javascript" src="/js/ever-popup.js"></script>
	<script type="text/javascript" src="/js/ever-string.js"></script>
	<script type="text/javascript" src="/js/ever-formutils.js"></script>
	<style>
		#e-mask{background:rgba(85,85,85,0.1);display:none;font-size:13px;height:100%;text-align:center;width:100%;margin:auto;padding:0;position:fixed;z-index:99999999999999;transition:all .07s ease-in;vertical-align:middle;top:0;left:0}
		#e-mask-icon{color:#777;font-size:40px;position:absolute;top:45%;left:50%}
		#e-mask-icon:after{font-family:"Font Awesome 5 Free";font-weight:900}
	</style>
    <script>
	    var changeIdFlag = true;
	    var baseUrl = "/nhepro/REGISTER/";

	    $(document).ready(function() {

		    //$(".text-right").on("change", function(e) {
			//    onChangeEXEC();
			//});

		    //$(".comma").on("keyup", function(e) {
			//    $(this).val(everString.comma($(this).val().replace(/,/gi, "")));
		    //});

		    /*$(".sl, .customer").on({
			    "change": function (el) {
				    // 체크박스 체크 시 해제 / 체크
			    	var id = el.target.id;

				    if (id.indexOf("SL_CB") > -1 || id.indexOf("BUYER_CB") > -1) {

					    if (el.target.checked) {
						    el.target.checked = true;
					    } else {
						    el.target.checked = false;
					    }
				    } else {
				    	// 값 입력 시 체크박스 체크
					    if (el.currentTarget.className.indexOf("sl") > -1) {
						    $(el.target).closest("tr").find("td input[name=SL_CB]").prop("checked", true);
					    } else if (el.currentTarget.className.indexOf("customer") > -1) {
						    $(el.target).closest("tr").find("td input[name=BUYER_CB]").prop("checked", true);
						}
					}
			    }
		    });*/
		    
		    //21.01.20 회원가입 승인 이후 로그인화면에서 아이디 한글 입력방지로 인하여 회원가입 시 사용자 아이디 한글입력 방지 추가
			$("#USER_ID").keyup(function(event){
				if(!(event.keyCode >= 37 && event.keyCode <= 40)) {
					var inputVal = $(this).val();
					$(this).val(inputVal.replace(/[^a-zA-Z0-9]/gi, ''));
				}
			});
		    
		    if("${form.CONFIRM_FLAG}" == "R") {
			    $("#REG_TYPE").val("${form.REG_TYPE}");
			    $("#BUSINESS_SIZE").val("${form.BUSINESS_SIZE}");
			    $("#RELAT_YN").val("${form.RELAT_YN}");
			    $("#CORP_TYPE").val("${form.CORP_TYPE}");
			    $("#FI_YEAR").val("${form.FI_YEAR}");
			    $("#EVIDENCE_TYPE").val("${form.EVIDENCE_TYPE}");
			    $("#E_BILL_ASP_TYPE").val("${form.E_BILL_ASP_TYPE}");
			    $("#TAX_SEND_TYPE").val("${form.TAX_SEND_TYPE}");
			    $("#CREDIT_CD").val("${form.CREDIT_CD}");
			    $("#MAIL_FLAG").val("${user.MAIL_FLAG}");
			    $("#SMS_FLAG").val("${user.SMS_FLAG}");
				$("#USER_ID").attr("readonly", true);
			    $("#USER_NM").attr("readonly", true);
			    onChangeEXEC();
		    } else {
			    $('input[name*=ATT_FILE_NUM]').each(function(k, v) {
				    v.value = EVF.getUUID(true);
			    });

			    // 결제정보 한줄 기본 제공
			    addEvent('pay');

			    // 거래희망 고객사
			    addEvent('customer');
		    }
		    onRegTypeChange();
		});

        function addEvent(el) {
	        var idx = $("." + el + " > tbody > tr").length + 1;

	        if (el == "customer") {
		        $("." + el + " > tbody").append(
			        "<tr>\n" +
			        "<td>\n" +
			        "<div class=\"custom-control custom-checkbox custom-checkbox-sm\">\n" +
			        "<input type=\"checkbox\" id=\"BUYER_CB"+ idx +"\" name=\"BUYER_CB\" class=\"custom-control-input\" title=\"text\" checked>\n" +
			        "<label class=\"custom-control-label font-weight-bold\"></label>\n" +
			        "</div>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<div class=\"input-group\">\n" +
			        "<input id=\"BUYER_NM"+ idx +"\" name=\"BUYER_NM\" value=\"\" class=\"form-control\" type=\"search\" placeholder=\"\" aria-label=\"Search\" readonly style=\"top: 1px;\">\n" +
			        "<input type=\"hidden\" id=\"BUYER_CD"+ idx +"\" name=\"BUYER_CD\" value=\"\"/>&nbsp;\n" +
					"<a class=\"btn btn-outline-secondary d-inline-block\" onclick=\"javascript:getBuyer('"+ idx +"');\">일반고객</a>&nbsp;\n" +
					"<a class=\"btn btn-outline-secondary d-inline-block\" onclick=\"javascript:getBidBuyer('"+ idx +"');\">입찰공고고객</a>\n" +
			        "</div>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"REQ_REASON"+ idx +"\" name=\"REQ_REASON\" class=\"form-control\"/>\n" +
			        "</td>\n" +
			        "</tr>"
		        );
        	}
			else if (el == "sl") {
	        	var uuid = EVF.getUUID(true);
        		$("." + el + " > tbody").append(
        			"<tr>\n" +
			        "<td>\n" +
			        "<div class=\"custom-control custom-checkbox custom-checkbox-sm\">\n" +
			        "<input type=\"checkbox\" id=\"SL_CB"+ idx +"\" name=\"SL_CB\" class=\"custom-control-input\" title=\"text\" checked>\n" +
			        "<label class=\"custom-control-label font-weight-bold\"></label>\n" +
			        "</div>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<select class=\"custom-select\" id=\"SL_TYPE"+ idx +"\" name=\"SL_TYPE\">\n" +
			        "<option value=\"\"></option>\n" +
			        <c:forEach var="sl" items="${slType}">
			        "<option value=\"${sl.value}\">${sl.text}</option>\n" +
			        </c:forEach>
			        "</select>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"SL_NUM"+ idx +"\" name=\"SL_NUM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"SL_NM"+ idx +"\" name=\"SL_NM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"ISSUE_NM"+ idx +"\" name=\"ISSUE_NM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"EXPIRY_DATE"+ idx +"\" name=\"EXPIRY_DATE\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<a href=\"javascript:doAtt_File('"+ idx +"', 'SL_ATT_FILE_NUM')\" class=\"btn btn-outline-light btn-search\"><i class=\"fas fa-search\"></i></a>\n" +
			        "<input type=\"hidden\" id=\"SL_ATT_FILE_NUM"+ idx +"\" name=\"SL_ATT_FILE_NUM\" value=\"" + uuid + "\"/>\n" +
			        "</td>\n" +
			        "</tr>"
				);
			}
			else {
				var uuid = EVF.getUUID(true);
		        $("." + el + " > tbody").append(
			        "<tr>\n" +
			        "<td>\n" +
			        "<div class=\"custom-control custom-checkbox custom-checkbox-sm\">\n" +
			        "<input type=\"checkbox\" id=\"PAY_CB"+ idx +"\" name=\"PAY_CB\" class=\"custom-control-input\" title=\"text\" checked>\n" +
			        "<label class=\"custom-control-label font-weight-bold\"></label>\n" +
			        "</div>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACC_NM"+ idx +"\" name=\"PAY_ACC_NM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<select class=\"custom-select\" id=\"PAY_BANK"+ idx +"\" name=\"PAY_BANK\">\n" +
			        "<option value=\"\"></option>\n" +
			        <c:forEach var="pay" items="${payBank}">
			        "<option value=\"${pay.value}\">${pay.text}</option>\n" +
			        </c:forEach>
			        "</select>\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACCOUNT_NUM"+ idx +"\" name=\"PAY_ACCOUNT_NUM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACCOUNT_USER_NM"+ idx +"\" name=\"PAY_ACCOUNT_USER_NM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACC_MNG_NM"+ idx +"\" name=\"PAY_ACC_MNG_NM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACC_NMG_TEL_NUM"+ idx +"\" name=\"PAY_ACC_NMG_TEL_NUM\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
			        "<input type=\"text\" id=\"PAY_ACC_MNG_EMAIL"+ idx +"\" name=\"PAY_ACC_MNG_EMAIL\" class=\"form-control\" title=\"example\" placeholder=\"\">\n" +
			        "</td>\n" +
			        "<td>\n" +
				    "<input type=\"hidden\" id=\"PAY_REQUIRED_FLAG" + idx + "\" name=\"PAY_REQUIRED_FLAG\" value=\"" + 1 + "\" />" +
				    "</td>\n" +
			        "<td>\n" +
					"<a href=\"javascript:doAtt_File('" + idx + "', 'PAY_ATT_FILE_NUM')\" class=\"btn btn-outline-light btn-search\"><i class=\"fas fa-search\"></i></a>\n" +
					"<input type=\"hidden\" id=\"PAY_ATT_FILE_NM" + idx +"\" name=\"PAY_ATT_FILE_NM\" />\n" +
					"<input type=\"hidden\" id=\"PAY_ATT_FILE_NUM" + idx + "\" name=\"PAY_ATT_FILE_NUM\" value=\"" + uuid + "\"/>\n" +
					"</td>\n" +
		        	"</tr>"
		        );
	        }
        }

        function delEvent(id) {
	        var buyerCb = $("input[name=" + id + "]");

	        if(buyerCb.length == 0) {
		        return alert("선택된 데이터가 없습니다.");
	        }

	        $(buyerCb).each(function(k, v) {
		        if(v.checked) {
			        $(v).closest('tr').remove();
		        }
	        });
		}
        
        //2021.05.17 사용자ID 입력 시 금지어 체크
        function checkId(){
			var map = everString.Injection($('#USER_ID').val());
            
			if(!map.success) {
				changeIdFlag = true;
				$('#USER_ID').val('');
               	$('#USER_ID').focus();
            	return alert(map.msg);
            }
        }

        function userIdCheck() {
	        if($('#USER_ID').val() == '') {
		        $('#USER_ID').focus();
		        return alert("사용자ID를 입력하여 주시기 바랍니다.");
	        }
	        
	        if( $('#USER_ID').val().trim().length < 6 ) {
                $('#USER_ID').focus();
                return alert("사용자ID는 6자리 이상 입력하여 주시기 바랍니다.");
            }
	        
	        if( $('#USER_ID').val().trim().length > 20 ) {
                $('#USER_ID').focus();
                return alert("사용자ID는 20자리 이하로 입력하여 주시기 바랍니다.");
            }
	        
	        var url = baseUrl + "userIdCheck.so";
	        var param = {
		        USER_ID: $('#USER_ID').val()
	        };
	        $.post(url, param, function(data) {
		        if(data.responseCode == 'fail') {
			        alert("이미 등록된 사용자 ID 입니다.");
			        $('#USER_ID').val('');
			        $('#USER_ID').focus();

			        changeIdFlag = true;
		        } else {
			        alert("사용하실 수 있는 ID 입니다.");

			        changeIdFlag = false;
		        }

		        return;
	        }, "json" );
        }

        function doSave() {
        	// validation 체크
	        var returnFlag = false;
	        var vendorFlag = false;
	        var vendorRmkFlag = false;

	        $('input').closest('.row').find('.fa-check').each(function(k, v) {
		        if($(v).closest('.row').find('input').val() == '') {
			        var name = $(v).closest('.row').find('input').prop('name');
			        formUtil.animate(name, 'form');
			        returnFlag = true;
		        }
	        });

	        // 주소 체크
	        $('input').closest('.double').find('.fa-check').each(function(k, v) {
		        $(v).closest('.double').find('input').each(function(k1, v1) {
			        var name = $(v1).prop('name');
			        if($("input[name="+name+"]").val() == '') {
				        formUtil.animate(name, 'form');
				        returnFlag = true;
					}
		        });
	        });

	        $('select').closest('.row').find('.fa-check').each(function(k, v) {
		        if($(v).closest('.row').find('select').val() == '') {
			        var name = $(v).closest('.row').find('select').prop('name');
			        formUtil.animate(name, 'form');
			        returnFlag = true;
		        }
	        });

	        if(returnFlag) {
		        return alert("필수 값을 입력하여 주시기 바랍니다.");
	        }

		    var totLiabAmt = ($("#TOT_LIAB_AMT").val().replace(/,/gi, "") || 0);	// 총부채
		    var currentAssetAmount = ($("#CURRENT_ASSET_AMOUNT").val().replace(/,/gi, "") || 0);	// 유동자산
		    var currentAssetLiabilityAmount = ($("#CURRENT_ASSET_LIABILITY_AMOUNT").val().replace(/,/gi, "") || 0);	// 유동부채
			
		    if( totLiabAmt.indexOf("-") > -1 || currentAssetAmount.indexOf("-") > -1 || currentAssetLiabilityAmount.indexOf("-") > -1 ) {
				return alert("총부채, 유동자산, 유동부채는 마이너스(-) 문자를 입력할 수 없습니다.");
			}
		    
	        if("${form.CONFIRM_FLAG}" != "R") {
		        if (changeIdFlag) {
			        return alert("사용자 ID 중복체크를 하여 주시기 바랍니다.");
		        }
	        }

			// 거래희망 고객사 필수 체크
	        $('input[name=BUYER_CD]').each(function(k,v) {
		        if(v.value == "") {
			        vendorFlag = true;
				}
	        });

	        if($('input[name=BUYER_CD]').length == 0 || vendorFlag) {
		        return alert("거래희망 고객사를 선택하여 주시기 바랍니다.");
			}

	        // 거래희망 고객사 존재 시 사유 체크
	        $(".customer > tbody > tr > td > [name=REQ_REASON]").each(function(k, v) {
		        if(v.value == "") {
		        	vendorRmkFlag = true;
		        }
	        });

	        if(vendorRmkFlag) {
		        return alert("사유를 입력하여 주시기 바랍니다.");
	        }

	        // 첨부파일 필수인 경우 체크
			var fileFlag = false;
	        $(".attach > tbody > tr > td > [name=REQUIRED_FLAG]").each(function(k, v) {
		        if(v.value == "1") {
			        if( $("#" + v.id.replace("REQUIRED_FLAG", "ATTS_ATT_FILE_NM")).val() == "" ) {
				        fileFlag = true;
			        }
		        }
	        });

	       	if(fileFlag) {
	        	return alert("[첨부파일]란의 필수여부를 확인하여 필수여부가 'Y'인 파일을 첨부하여 주시기 바랍니다.");
			}

	       	var payFlag = false;
	       	var payAttFlag = false;
	        // 결제정보 체크가 있는 경우 validation 체크
	        $(".pay > tbody > tr > td input[name=PAY_CB]").each(function(k, v) {
		        if(v.checked) {
			        $(".pay > tbody > tr:eq("+k+") > td input[type=text]").each(function(k1, v1) {
				        if(v1.value == "") {
				        	payFlag = true;
						}
			        });

			        $(".pay > tbody > tr:eq("+k+") > td > select").each(function(k1, v1) {
			        	if(v1.value == "") {
					        payFlag = true;
			        	}
			        });
		        }
	        });

	        if(payFlag) {
	        	return alert("결제정보를 입력하여 주시기 바랍니다.");
			};
	        
	        $(".pay > tbody > tr > td > [name=PAY_REQUIRED_FLAG]").each(function(k, v) {
		        if(v.value == "1") {
			        if( $("#" + v.id.replace("PAY_REQUIRED_FLAG", "PAY_ATT_FILE_NM")).val() == "" ) {
			        	payAttFlag = true;
			        }
		        }
	        });
	        
	        if(payAttFlag) {
	        	return alert("결제정보 첨부파일에 통장사본을 첨부해주시기 바랍니다.");
			};
	        
	        if(confirm("가입등록 하시겠습니까?")) {
	        	var param = $("form[name=form]").serializeObject();

		        var key = Object.keys(param);
		        for(var i in key) {
			        if(typeof param[key[i]] == "string") {
				        if(key[i] == "OWNER_CAPITAL_AMOUNT" ||
					        key[i] == "TOT_FUND_AMT" ||
					        key[i] == "TOT_LIAB_AMT" ||
					        key[i] == "TOTAL_LIABILITY_RATE" ||
					        key[i] == "CURRENT_ASSET_AMOUNT" ||
					        key[i] == "CURRENT_ASSET_LIABILITY_AMOUNT" ||
					        key[i] == "CURRENT_ASSET_LIABILITY_RATE" ||
					        key[i] == "SALES_AMOUNT" ||
					        key[i] == "NET_PROFIT_AMOUNT") {
				        	param[key[i]] = param[key[i]].replace(/,/gi, "");
						}
			        }
		        }

	        	// 특허 및 취급면허 데이터 파싱
		        var slSize = $(".sl > tbody > tr").length;
		        if(slSize > 0) {
			        var slArrInfo = [];

		        	if(slSize == 1) {
				        slArrInfo.push({
					        SL_TYPE: param.SL_TYPE,
					        SL_NM: param.SL_NM,
					        SL_NUM: param.SL_NUM,
					        ISSUE_NM: param.ISSUE_NM,
					        EXPIRY_DATE: param.EXPIRY_DATE,
					        SL_ATT_FILE_NUM: param.SL_ATT_FILE_NUM
				        });
					} else {
				        for(var i = 0; i < slSize; i++) {
					        slArrInfo.push({
						        SL_TYPE: param.SL_TYPE[i],
						        SL_NM: param.SL_NM[i],
						        SL_NUM: param.SL_NUM[i],
						        ISSUE_NM: param.ISSUE_NM[i],
						        EXPIRY_DATE: param.EXPIRY_DATE[i],
						        SL_ATT_FILE_NUM: param.SL_ATT_FILE_NUM[i]
					        });
				        }
					}

			        param.SL_INFO = slArrInfo;
				}

		        // 결제정보
		        var paySize = $(".pay > tbody > tr").length;
		        if(paySize > 0) {
			        var payArrInfo = [];

			        if(paySize == 1) {
				        payArrInfo.push({
					        PAY_ACC_NM: param.PAY_ACC_NM,
					        PAY_BANK: param.PAY_BANK,
					        PAY_ACCOUNT_NUM: param.PAY_ACCOUNT_NUM,
					        PAY_ACCOUNT_USER_NM: param.PAY_ACCOUNT_USER_NM,
					        PAY_ACC_MNG_NM: param.PAY_ACC_MNG_NM,
					        PAY_ACC_NMG_TEL_NUM: param.PAY_ACC_NMG_TEL_NUM,
					        PAY_ACC_MNG_EMAIL: param.PAY_ACC_MNG_EMAIL,
					        PAY_ATT_FILE_NUM: param.PAY_ATT_FILE_NUM
				        });
			        } else {
				        for(var i = 0; i < paySize; i++) {
					        payArrInfo.push({
						        PAY_ACC_NM: param.PAY_ACC_NM[i],
						        PAY_BANK: param.PAY_BANK[i],
						        PAY_ACCOUNT_NUM: param.PAY_ACCOUNT_NUM[i],
						        PAY_ACCOUNT_USER_NM: param.PAY_ACCOUNT_USER_NM[i],
						        PAY_ACC_MNG_NM: param.PAY_ACC_MNG_NM[i],
						        PAY_ACC_NMG_TEL_NUM: param.PAY_ACC_NMG_TEL_NUM[i],
						        PAY_ACC_MNG_EMAIL: param.PAY_ACC_MNG_EMAIL[i],
					        	PAY_ATT_FILE_NUM: param.PAY_ATT_FILE_NUM[i]
					        });
				        }
			        }

			        param.PAY_INFO = payArrInfo;
		        }

		        // 거래희망 고객사 데이터 파싱
				var customerSize = $(".customer > tbody > tr").length;
		        if(customerSize > 0) {
			        var buyerArrInfo = [];

			        if(customerSize == 1) {
				        buyerArrInfo.push({
					        BUYER_NM: param.BUYER_NM,
					        BUYER_CD: param.BUYER_CD,
					        // DEPT_NM: param.DEPT_NM,
					        // DEPT_CD: param.DEPT_CD,
					        REQ_REASON: param.REQ_REASON
				        });
			        } else {
				        for(var i = 0; i < customerSize; i++) {
					        buyerArrInfo.push({
						        BUYER_NM: param.BUYER_NM[i],
						        BUYER_CD: param.BUYER_CD[i],
						        // DEPT_NM: param.DEPT_NM[i],
						        // DEPT_CD: param.DEPT_CD[i],
						        REQ_REASON: param.REQ_REASON[i]
					        });
				        }
			        }

			        param.BUYER_INFO = buyerArrInfo;
		        }

		        // 첨부파일
				var attachSize = $(".attach > tbody > tr").length;
		        if (attachSize > 0) {
			        var attsFileArrInfo = [];

			        if(attachSize == 1) {
				        attsFileArrInfo.push({
					        TMPL_FILE_NM: param.TMPL_FILE_NM,
					        VALID_PERIOD: param.VALID_PERIOD,
					        REQUIRED_FLAG: param.REQUIRED_FLAG,
					        TMPL_BUYER_CD: param.TMPL_BUYER_CD,
					        TMPL_NUM: param.TMPL_NUM,
					        TMPL_SQ: param.TMPL_SQ,
					        VALID_START_DATE: param.VALID_START_DATE,
					        VALID_END_DATE: param.VALID_END_DATE,
					        ATTS_ATT_FILE_NUM: param.ATTS_ATT_FILE_NUM,
					        // TMPL_FILE_NUM: param.TMPL_FILE_NUM
				        });
			        } else {
				        for(var i = 0; i < attachSize; i++) {
					        attsFileArrInfo.push({
						        TMPL_FILE_NM: param.TMPL_FILE_NM[i],
						        VALID_PERIOD: param.VALID_PERIOD[i],
						        REQUIRED_FLAG: param.REQUIRED_FLAG[i],
						        TMPL_BUYER_CD: param.TMPL_BUYER_CD[i],
						        TMPL_NUM: param.TMPL_NUM[i],
						        TMPL_SQ: param.TMPL_SQ[i],
						        VALID_START_DATE: param.VALID_START_DATE[i],
						        VALID_END_DATE: param.VALID_END_DATE[i],
						        ATTS_ATT_FILE_NUM: param.ATTS_ATT_FILE_NUM[i],
						        // TMPL_FILE_NUM: param.TMPL_FILE_NUM[i]
					        });
				        }
			        }

			        param.ATTS_ATT_FILE_INFO = attsFileArrInfo;
		        }

		        // 마스킹 처리
		        new EVF.Mask().mask();

		        // 데이터 저장
		        $.post(baseUrl + 'doSave.so', {json: JSON.stringify(param)}, function(data) {
			        //if(data.responseCode == 'success') {
			        new EVF.Mask().unMask();
					alert("회원가입이 완료되었습니다.");

					var url = "/mainHtml/02_sigin_in/sigin_in_03.jsp";
					everPopup.openWindowPopup(url, 700, 600, null, '_self', true);
			        // }
		        }, "json" );
	        }
        }

        function doHome() {
	        if(confirm("가입취소 하시겠습니까?")) {
		        location.href = "/welcome.so";
	        }
        }
		
      	//2021.03.17 비밀번호 입력 시 '%' 특수문자 입력 불가하도록 체크 추가
      	//2021.05.14 비밀번호 입력 시 금지어 체크
        function checkCall() {
        	
			var pass = everString.getCheckPassWord($("#PPDD").val());
			if (!pass.success) {
		        alert(pass.msg);

		        $("#PPDD").val("");
		        $("#PPDD_CHECK").val("");
		        $("#PPDD").focus();
	        }
            
	        var map = everString.getChkPwd($("#PPDD").val());
	        if (!map.success) {
		        alert(map.msg);

		        $("#PPDD").val("");
		        $("#PPDD_CHECK").val("");
		        $("#PPDD").focus();
	        }
	        
			var inject = everString.Injection($("#PPDD").val());
            
            if (!inject.success) {
            	alert(inject.msg);
            	
            	$("#PPDD").val("");
		        $("#PPDD_CHECK").val("");
		        $("#PPDD").focus();
            }
	        
        }
        
        function ppddCheck() {
	        if($("#PPDD").val() != $("#PPDD_CHECK").val()) {
		        $("#PPDD").val("");
		        $("#PPDD_CHECK").val("");
		        $("#PPDD").focus();

		        return alert("비밀번호가 일치하지 않습니다.");
	        }
        }
        
        //2022.01.10 법인등록번호 자리수 및 유효성 체크
        function companyRegNoCheck(element, type){
        	if(type == "C") {
        		var as_Biz_no= $("#"+element.id).val();
    			var I_TEMP_SUM = 0 ;
    			var I_TEMP = 0;
    			var S_TEMP;
    			var I_CHK_DIGIT = 0;
    			
    			if(as_Biz_no.length != 13) {
    				clearValidCheck(element);
        			return alert("올바른 법인등록번호가 아닙니다.");
    			}

    			for(index01 = 1; index01 < 13; index01++) {
    				var i = index01 % 2;
    				var j = 0;

    				if(i == 1) j = 1;
    				else if( i == 0) j = 2;

    				I_TEMP_SUM = I_TEMP_SUM + parseInt(as_Biz_no.substring(index01-1, index01),10) * j;
    			}

    			I_CHK_DIGIT= I_TEMP_SUM%10 ;
    			if(I_CHK_DIGIT != 0 ) I_CHK_DIGIT = 10 - I_CHK_DIGIT;

    			if (as_Biz_no.substring(12,13) != String(I_CHK_DIGIT)){
    				clearValidCheck(element);
        			return alert("올바른 법인등록번호가 아닙니다.");
    			}
        	}
        }
        
        //2021.05.14 이메일 입력 시 금지어 체크
        function validCheck(element, type) {
	        var check = false;
	        if(type == "E") {
		        if(!everString.isValidEmail($("#"+element.id).val())) {
			        check = true;
			        clearValidCheck(element);
			        return alert("이메일 형식이 일치하지 않습니다.");
		        }
		        
				var map = everString.Injection($("#"+element.id).val());
	            
	            if(!map.success) {
	            	check = true;
			        clearValidCheck(element);
	            	return alert(map.msg);
	            }
	            
	        } else {
		        if(!everString.isTel($("#"+element.id).val())) {
			        clearValidCheck(element);
			        if(type == "C") {
				        return alert("형식이 일치하지 않습니다. ex)010-0000-0000");
			        } else {
				        return alert("형식이 일치하지 않습니다. ex)02-0000-0000");
			        }
		        }
	        }
        }

        function clearValidCheck(element) {
	        $("#"+element.id).val("");
	        $("#"+element.id).focus();
        }

        function getBuyer(rowIdx) {
	        var param = {
		        callBackFunction: "setBuyer",
				rowIdx: rowIdx
	        };
	        everPopup.openCommonWindowPopup(param, 'SP0066', 860, 600);
		}
        
        function getBidBuyer(rowIdx) {
	        var param = {
		        callBackFunction: "setBuyer",
				rowIdx: rowIdx
	        };
	        everPopup.openCommonWindowPopup(param, 'SP0035', 860, 600);
		}

		function setBuyer(data) {
        	$("#BUYER_CB" + data.rowIdx).prop("checked", true);
			$("#BUYER_NM" + data.rowIdx).val(data.CUST_NM);
			$("#BUYER_CD" + data.rowIdx).val(data.CUST_CD);

			// 거래희망 고객사의 첨부파일이 존재하면 ADD
			var param = {
				BUYER_CD: data.CUST_CD
			};

			$.post(baseUrl + "/doBuyerAttr.so", param, function (data) {

				var idx = $('.attach tr').length;
				$('input[name=TMPL_NUM]').each(function(k, v) {
					for(var i in data) {
						if($("#"+v.id.replace("_NUM", "_BUYER_CD")).val() == data[i].BUYER_CD && // BUYER_CD 비교
							v.value == data[i].TMPL_NUM && // TMPL_NUM 비교
							$("#"+v.id.replace("_NUM", "_SQ")).val() == data[i].TMPL_SQ) // TMPL_SQ 비교
						{
							data.splice(i, 1);
						}
					}
				});

				for(var i in data) {
					var uuid = EVF.getUUID(true);
					var validStartDate = data[i].VALID_START_DATE != undefined ? data[i].VALID_START_DATE : " ";
					var validEndDate = data[i].VALID_END_DATE != undefined ? data[i].VALID_END_DATE : " ";
					var requiredFlag = data[i].REQUIRED_FLAG == "1" ? "Y" : "N";
					var buyerHtml = "";
						buyerHtml += "<tr>\n";
						buyerHtml += "<td class=\"text-left\">\n";
						buyerHtml += data[i].TMPL_FILE_NM;
						buyerHtml += "<input type=\"hidden\" id=\"TMPL_BUYER_CD" + idx + "\" name=\"TMPL_BUYER_CD\" value=\"" + data[i].BUYER_CD + "\" />";
						buyerHtml += "<input type=\"hidden\" id=\"TMPL_NUM" + idx + "\" name=\"TMPL_NUM\" value=\"" + data[i].TMPL_NUM + "\" />";
						buyerHtml += "<input type=\"hidden\" id=\"TMPL_SQ" + idx + "\" name=\"TMPL_SQ\" value=\"" + data[i].TMPL_SQ + "\" />";
						buyerHtml += "<input type=\"hidden\" id=\"TMPL_FILE_NM" + idx + "\" name=\"TMPL_FILE_NM\" value=\"" + data[i].TMPL_FILE_NM + "\" />";
						buyerHtml += "</td>\n";
						buyerHtml += "<td>\n";
						buyerHtml += data[i].VALID_PERIOD;
						buyerHtml += "<input type=\"hidden\" id=\"VALID_PERIOD" + idx + "\" name=\"VALID_PERIOD\" value=\"" + data[i].VALID_PERIOD + "\" />";
						buyerHtml += "</td>\n";
						buyerHtml += "<td>\n";
						buyerHtml += "<div class=\"input-group date\" data-provide=\"datepicker\" data-date-today-highlight=\"true\" data-date-language=\"kr\" data-date-format=\"yyyy-mm-dd\" autoclose=\"true\">\n";
						buyerHtml += "<input type=\"text\" id=\"VALID_START_DATE" + idx + "\" name=\"VALID_START_DATE\" class=\"form-control\" value=\"" + validStartDate + "\" title=\"datepicker\" data-autohide=\"true\" >\n";
						buyerHtml += "<a href=\"#\" class=\"btn btn-outline-light btn-calendar add-on\"><i class=\"fas fa-calendar-alt\"></i></a>\n";
						buyerHtml += "</div>\n";
						buyerHtml += "</td>\n";
						buyerHtml += "<td>\n";
						buyerHtml += "<div class=\"input-group date\" data-provide=\"datepicker\" data-date-today-highlight=\"true\" data-date-language=\"kr\" data-date-format=\"yyyy-mm-dd\" autoclose=\"true\">\n";
						buyerHtml += "<input type=\"text\" id=\"VALID_END_DATE" + idx + "\" name=\"VALID_END_DATE\" class=\"form-control\" value=\"" + validEndDate + "\" title=\"datepicker\" data-autohide=\"true\">\n";
						buyerHtml += "<a href=\"#\" class=\"btn btn-outline-light btn-calendar add-on\"><i class=\"fas fa-calendar-alt\"></i></a>\n";
						buyerHtml += "</div>\n";
						buyerHtml += "</td>\n";
						buyerHtml += "<td>\n";
						buyerHtml += requiredFlag;
						buyerHtml += "<input type=\"hidden\" id=\"REQUIRED_FLAG" + idx + "\" name=\"REQUIRED_FLAG\" value=\"" + data[i].REQUIRED_FLAG + "\" />";
						buyerHtml += "</td>\n";
						/*
						buyerHtml += "<td>\n";
						if(data[i].TMPL_FILE_NUM_CNT > 0) {
							buyerHtml += "<a href=\"javascript:doAtt_File('" + idx + "', 'TMPL_FILE_NUM')\" class=\"btn btn-outline-light btn-search\"><i class=\"fas fa-file\"></i></a>\n";
							buyerHtml += "<input type=\"hidden\" id=\"TMPL_FILE_NUM" + idx +"\" name=\"TMPL_FILE_NUM\" value=\"" + data.TMPL_FILE_NUM + "\" />\n";
						}
						buyerHtml += "</td>\n";
						*/
						buyerHtml += "<td>\n";
						buyerHtml += "<a href=\"javascript:doAtt_File('" + idx + "', 'ATTS_ATT_FILE_NUM')\" class=\"btn btn-outline-light btn-search\"><i class=\"fas fa-search\"></i></a>\n";
						buyerHtml += "<input type=\"hidden\" id=\"ATTS_ATT_FILE_NM" + idx +"\" name=\"ATTS_ATT_FILE_NM\" />\n";
						buyerHtml += "<input type=\"hidden\" id=\"ATTS_ATT_FILE_NUM" + idx + "\" name=\"ATTS_ATT_FILE_NUM\" value=\"" + uuid + "\"/>\n";
						buyerHtml += "</td>\n";
						buyerHtml += "</tr>";

					$(".attach > tbody").append(buyerHtml);
					idx++;
				}

			}, "json");
		}

		function doRemark(rowIdx) {
			var param = {
				title: "사유",
				message: $("#REQ_REASON" + rowIdx).val(),
				callbackFunction: 'setRmk',
				rowIdx: rowIdx,
				detailView : false
			};
			var url = '/common/popup/common_text_input/view.so';
			everPopup.openWindowPopup(url, 500, 320, param);
		}

		function setRmk(data) {
			$("#BUYER_CB" + data.rowIdx).prop("checked", true);

			if(data.message == "") {
				$("#REQ_REASON" + data.rowIdx).prev().removeAttr("style");
			} else {
				$("#REQ_REASON" + data.rowIdx).prev().css("color", "#0a8eeb");
			}

			$("#REQ_REASON" + data.rowIdx).val(data.message);
		}

		function doAtt_File(rowIdx, id) {
        	var flag;
        	var callBackMethod;

			if( id.indexOf("TMPL") > -1 ) {
				flag = true;

				callBackMethod = "callbackTMPL_FILE_NUM";
			} else {
				flag = false;

				if (id.indexOf("ATTS") > -1) {
					callBackMethod = "callbackATTS_ATT_FILE_NUM";
				} else if (id.indexOf("SL") > -1) {
					callBackMethod = "callbackSL_ATT_FILE_NUM";
				} else if (id.indexOf("PAY") > -1) {
					callBackMethod = "callbackPAY_ATT_FILE_NUM";	
				} else if (id.indexOf("VNFI") > -1) {
					callBackMethod = "callbackVNFI_ATT_FILE_NUM";
				} else if (id.indexOf("EV") > -1) {
					callBackMethod = "callbackEV_ATT_FILE_NUM";
				}
			}

			var param = {
				bizType: 'AD',
				attFileNum: $("#"+id+rowIdx).val(),
				callBackFunction: callBackMethod,
				rowIdx: rowIdx,
				detailView: flag,
				maxFileCount: 1
			};
			everPopup.fileAttachWindowPopup(param);
		}

		function callbackTMPL_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
        	console.log(data);
		}

		function callbackATTS_ATT_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
			//alert("1===>"+rowIdx+'======='+fileid+'======='+fileCount+'======='+fileName);
			var fileExts = 'ppt;pptx;pptm;doc;docx;docm;xls;xlsx;xlsm;xlsb;pdf;hwp;jpg;png;zip;7z';
			if( fileName == 'undefined' || fileName == "" ) {
				$("#ATTS_ATT_FILE_NM"+rowIdx).prev().removeAttr("style");
				$("#ATTS_ATT_FILE_NM"+rowIdx).val("");
			} else {
				var filenm = fileName.fileName;
				var ext = filenm.substring(filenm.lastIndexOf('.')+1 , filenm.length  );
				if( fileExts.indexOf(ext.toLowerCase()) < 0 ) {
					return;
				} else {
					$("#ATTS_ATT_FILE_NM"+rowIdx).prev().css("color", "#0a8eeb");
					$("#ATTS_ATT_FILE_NM"+rowIdx).val(fileName.fileName);
				}
			}
		}

	    function callbackSL_ATT_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
	    	//alert("2===>"+rowIdx+'======='+fileid+'======='+fileCount+'======='+fileName);
			if( fileName == 'undefined' || fileName == "" ) {
			    $("#SL_ATT_FILE_NUM"+rowIdx).prev().removeAttr("style");
	        	$("#SL_ATT_FILE_NUM").val("");
		    } else {
			    $("#SL_ATT_FILE_NUM"+rowIdx).prev().css("color", "#0a8eeb");
	        	$("#SL_ATT_FILE_NUM").val(fileName.fileName);
			}
	    }
	    
	    function callbackPAY_ATT_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
			if( fileName == 'undefined' || fileName == "" ) {
				$("#PAY_ATT_FILE_NM"+rowIdx).prev().removeAttr("style");
				$("#PAY_ATT_FILE_NM"+rowIdx).val("");
			} else {
				$("#PAY_ATT_FILE_NM"+rowIdx).prev().css("color", "#0a8eeb");
				$("#PAY_ATT_FILE_NM"+rowIdx).val(fileName.fileName);
			}
			
	    }

		function callbackVNFI_ATT_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
			//alert("3===>"+rowIdx+'======='+fileid+'======='+fileCount+'======='+fileName);
			if( fileName == 'undefined' || fileName == "" ) {
		        $("#VNFI_ATT_FILE_NM").next().removeAttr("style");
	        	$("#VNFI_ATT_FILE_NM").val("");
			} else {
		        $("#VNFI_ATT_FILE_NM").next().css("color", "#0a8eeb");
	        	$("#VNFI_ATT_FILE_NM").val(fileName.fileName);
			}
		}

		function callbackEV_ATT_FILE_NUM(rowIdx, fileid, fileCount, fileName) {
			//alert("4===>"+rowIdx+'======='+fileid+'======='+fileCount+'======='+fileName);
			if( fileName == 'undefined' || fileName == "" ) {
				$("#EV_ATT_FILE_NM").next().removeAttr("style");
	        	$("#EV_ATT_FILE_NM").val("");
			} else {
				$("#EV_ATT_FILE_NM").next().css("color", "#0a8eeb");
	        	$("#EV_ATT_FILE_NM").val(fileName.fileName);
			}
		}

	    function goAddrPopup() {
		    var url = '/common/code/BADV_020/view.so';
		    var param = {
			    callBackFunction : "setZipCode",
			    modalYn : false
		    };
		    everPopup.openWindowPopup(url, 700, 600, param);
	    }

	    function setZipCode(data) {
		    activeGrid.setCellValue(activeRow, ZIP_CD, data.ZIP_CD);
		    activeGrid.setCellValue(activeRow, ADDR1, data.ADD);
	    }

	    function onChangeEXEC() {
		    var totFundAmt = parseInt($("#TOT_FUND_AMT").val().replace(/,/gi, "") || 0);
		    var totLiabAmt = parseInt($("#TOT_LIAB_AMT").val().replace(/,/gi, "") || 0);
		    var currentAssetLiabilityAmount = parseInt($("#CURRENT_ASSET_LIABILITY_AMOUNT").val().replace(/,/gi, "") || 0);
		    var currentAssetAmount = parseInt($("#CURRENT_ASSET_AMOUNT").val().replace(/,/gi, "") || 0);
			
		    // 총자산 = 총자본 + 총부채
		    var totCapitalAmt = totFundAmt + totLiabAmt;
		    $("#OWNER_CAPITAL_AMOUNT").val(castMinusComma(totCapitalAmt + ""));
			
		    // 2021.06.02 부채비율 계산방식 변경 
		    // 부채비율 = (총부채 / 총자산) * 100 : 소숫점 1자리(변경 전 방식)
		    // 부채비율 = (총부채 / 총자본) * 100 : 소숫점 1자리(변경 후 방식)
		    if(totFundAmt != 0) {
			    $("#TOTAL_LIABILITY_RATE").val(((Math.floor(((totLiabAmt / totFundAmt) * 100) * 10) / 10) + "") );
		    }
		    else {
			    $("#TOTAL_LIABILITY_RATE").val(0);
		    }
			
		    // 유동비율 = (유동부채 / 유동자산) * 100 : 소숫점 1자리
		    if(currentAssetLiabilityAmount > 0) {
			    $("#CURRENT_ASSET_LIABILITY_RATE").val( everString.comma((Math.floor(((currentAssetAmount / currentAssetLiabilityAmount) * 100) * 10) / 10) + "") );
		    } else {
			    $("#CURRENT_ASSET_LIABILITY_RATE").val(0);
		    }

	    }

		function relatChange() {
			if ($("#RELAT_YN").val() == 0) {
				$('#CORP_TYPE').closest('div').prev().append("<i class=\"fas fa-check\"></i>");
			} else {
				$('#CORP_TYPE').closest('div').prev().find(".fa-check").remove();
			}
		}

		function onRegTypeChange() {
        	var reg_type = $("#REG_TYPE").val();
        	//console.log(reg_type);
			$(".attach > tbody > tr > td > [name=REQUIRED_FLAG]").each(function(k, v) {
				var sText = $(v).closest("tr").find("td:eq(0)").text().trim(); // 서류명
				var txt = "";
				if (reg_type == "C" || reg_type == "P") {
					if(sText == "법인등기부등본" || sText == "법인인감증명") {
						txt = $(v).parent().text("Y");
						$(txt).append("<input type=\"hidden\" id=\"REQUIRED_FLAG"+ (k + 1) +"\" name=\"REQUIRED_FLAG\" value=\"1\">")
					}
				} else {
					//console.log(sText);
					if(sText == "법인등기부등본" || sText == "법인인감증명") {
						var txt = $(v).parent().text("N");
						$(txt).append("<input type=\"hidden\" id=\"REQUIRED_FLAG"+ (k + 1) +"\" name=\"REQUIRED_FLAG\" value=\"0\">")
					}
				}
			});

			if (reg_type == "C") {
				$("#COMPANY_REG_NO").parent().parent().find('.col-title span').append('<i class="fas fa-check"></i>');
			} else {
				$("#COMPANY_REG_NO").parent().parent().find('.col-title span i').remove();
			}
		}

		function onValidDate(idNum, ft) {
        	var valid_start_date = $("#VALID_START_DATE"+idNum).val().replace(/["/"-/]/gi, "");
			var valid_end_date = $("#VALID_END_DATE"+idNum).val().replace(/["/"-/]/gi, "");

			if (Number(valid_start_date) > Number(valid_end_date)) {
				if (ft == "F") {
					$("#VALID_START_DATE" + idNum).val("");
					return alert("유효종료일보다 유효시작일이 클 수 없습니다.");
				} else if (ft == "T") {
					$("#VALID_END_DATE" + idNum).val("");
					return alert("유효종료이 유효시작일보다 작을 수 없습니다.");
				}
			}

		}

		function jusoPop() {
			var url = '/common/code/BADV_020/view.so';

			var param = {
				callBackFunction : "setZipCode",
				modalYn : false
			};

			everPopup.jusoPop(url, param);
		}

	    function setZipCode(zipcd) {
		    if (zipcd.ZIP_CD != "") {
			    $('#HQ_ZIP_CD').val(zipcd.ZIP_CD_5 == '' ? zipcd.ZIP_CD : zipcd.ZIP_CD_5);
			    $('#HQ_ADDR_1').val(zipcd.ADDR1);
			    $('#HQ_ADDR_2').val(zipcd.ADDR2);
			    $('#HQ_ADDR_2').focus();
		    }
	    }
	    
	    function setPlusComma(el) {
        	var val = $(el).val().replace(/[^-0-9]/gi, "");
			$(el).val(everString.comma(val.replace(/[^0-9]/gi, "")));
			
			onChangeEXEC();
		}
		
		function setMinusComma(el) {
        	var val = $(el).val().replace(/[^-0-9]/gi, "");
        	var minus = "";
        	if(val.indexOf("-") > -1) {
        		minus = "-";
			} else {
        		minus = "";
			}
			$(el).val(minus + everString.comma(val.replace(/[^0-9]/gi, "")));
			
			onChangeEXEC();
		}
		
		function castMinusComma(val) {
			//console.log('333333333333333333333');
			
        	var minus = "";
        	if(val.indexOf("-") > -1) {
        		minus = "-";
			} else {
        		minus = "";
			}
        	//console.log("val=====> " +minus + everString.comma(val.replace(/[^0-9]/gi, "")))
			return minus + everString.comma(val.replace(/[^0-9]/gi, ""));
		}
		
    </script>
</head>

<body>
<div id="e-mask"></div>
<div class="wrap">
    <c:import url="/mainHtml/header/header.jsp" charEncoding="UTF-8"/>
	<section class="personal sign_in">
		<h2 class="sr-only">회원가입</h2>
		<div class="title">
			<p>회원가입</p>
		</div>
		<div class="box">
			<div class="content">
				<div class="clearfix pb-3">
					<ul class="step">
						<li class="active">STEP 1. 약관동의</li>
						<li class="current">STEP 2. 정보입력</li>
						<li>STEP 3. 가입완료</li>
					</ul>
				</div>
				<div class="p-content">
					<p class="p-title">회원사 정보</p>
					<form id="vendor_form" name="form" >
						<input type="hidden" id="VENDOR_CD" name="VENDOR_CD" value="${form.VENDOR_CD}"/>
						<input type="hidden" id="CONFIRM_FLAG" name="CONFIRM_FLAG" value="${form.CONFIRM_FLAG}"/>
						<div class="row border-0" style="border-bottom: 1px solid #ababab !important;">
							<p class="title">
								<i class="fas fa-dot-circle"></i>기본정보
								<span style="color: red; font-size: 15px; float:right;">※ 신규 협력회사 가입에 필요한 첨부파일과 재무정보등을 사전에 확인하시고 준비하여 주시기 바랍니다.</span>
							</p>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>회사명(국문)<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="VENDOR_NM" name="VENDOR_NM" value="${form.VENDOR_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>회사명(영문)</span>
									</div>
									<div class="col-desc">
										<input type="text" id="VENDOR_ENG_NM" name="VENDOR_ENG_NM" value="${form.VENDOR_ENG_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사업자등록번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="IRS_NUM" name="IRS_NUM" class="form-control" value="${form.IRS_NUM}" readonly>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사업자구분<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" name="REG_TYPE" id="REG_TYPE" onchange="onRegTypeChange();">
											<option value=""></option>
											<c:forEach var="reg" items="${regType}">
												<option value="${reg.value}">${reg.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>법인등록번호</span>
									</div>
									<div class="col-desc">
										<input type="text" id="COMPANY_REG_NO" name="COMPANY_REG_NO" value="${form.COMPANY_REG_NO}" class="form-control" title="example" placeholder="-없이 입력해 주세요." maxlength="13" onchange="companyRegNoCheck(this, 'C');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>기업규모<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" name="BUSINESS_SIZE" id="BUSINESS_SIZE">
											<option value=""></option>
											<c:forEach var="size" items="${businessSize}">
												<option value="${size.value}">${size.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>대표자명<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="CEO_USER_NM" name="CEO_USER_NM" value="${form.CEO_USER_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>설립일자<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
											<input type="text" id="FOUNDATION_DATE" name="FOUNDATION_DATE" class="form-control" value="${form.FOUNDATION_DATE}" title="datepicker" data-autohide="true">
											<a class="btn btn-outline-light btn-calendar add-on"><i class="fas fa-calendar-alt"></i></a>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>농협구분<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" name="RELAT_YN" id="RELAT_YN" onchange="relatChange();">
											<option value=""></option>
											<c:forEach var="relat" items="${relatType}">
												<option value="${relat.value}">${relat.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>법인구분(농협일경우)</span>
									</div>
									<div class="col-desc">
										<select class="custom-select" name="CORP_TYPE" id="CORP_TYPE">
											<option value=""></option>
											<c:forEach var="corp" items="${corpType}">
												<option value="${corp.value}">${corp.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row double">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>주소<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<div class="row">
											<div class="input-group" style="width: 366px">
												<input id="HQ_ZIP_CD" name="HQ_ZIP_CD" value="${form.HQ_ZIP_CD}" class="form-control" type="search" placeholder="" aria-label="Search" readonly>
												<a href="javascript:jusoPop();" class="btn btn-outline-light btn-search"><i class="fas fa-search"></i></a>
											</div>
										</div>
										<div class="row">
											<input type="text" id="HQ_ADDR_1" name="HQ_ADDR_1" value="${form.HQ_ADDR_1}" class="form-control d-inline mr-2" title="example" placeholder="" style="width: 568px">
											<input type="text" id="HQ_ADDR_2" name="HQ_ADDR_2" value="${form.HQ_ADDR_2}" class="form-control d-inline" title="example" placeholder="" style="width: 366px">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>업태<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="BUSINESS_TYPE" name="BUSINESS_TYPE" value="${form.BUSINESS_TYPE}" class="form-control" title="example" placeholder="" maxlength="100">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>업종<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="INDUSTRY_TYPE" name="INDUSTRY_TYPE" value="${form.INDUSTRY_TYPE}" class="form-control" title="example" placeholder="" maxlength="100">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>대표전화번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="tel" id="TEL_NO" name="TEL_NO" class="form-control" value="${form.TEL_NO}" title="example" placeholder="EX) 00-0000-0000" onchange="validCheck(this, 'T');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>대표팩스번호</span>
									</div>
									<div class="col-desc">
										<input type="tel" id="FAX_NO" name="FAX_NO" class="form-control" value="${form.FAX_NO}" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'T');">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>대표 e-mail<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="email" id="EMAIL" name="EMAIL" class="form-control" value="${form.EMAIL}" title="example" placeholder="Email 형식에 맞게 입력해 주세요." onchange="validCheck(this, 'E');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>홈페이지</span>
									</div>
									<div class="col-desc">
										<input type="text" id="HOMEPAGE_URL" name="HOMEPAGE_URL" value="${form.HOMEPAGE_URL}" class="form-control" title="example" >
									</div>
								</div>
							</div>
						</div>
						<div class="row double">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>회사소개</span>
									</div>
									<div class="col-desc">
										<textarea title="text" id="BUSINESS_REMARK" name="BUSINESS_REMARK" style="width:100%; height: 100%; resize: none">${form.BUSINESS_REMARK}</textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="row double">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>특이사항</span>
									</div>
									<div class="col-desc">
										<textarea title="text" id="REMARK_TEXT" name="REMARK_TEXT" style="width:100%; height: 100%; resize: none">${form.REMARK_TEXT}</textarea>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="sl_form" name="form">
						<div class="row border-0">
							<p class="title"><i class="fas fa-dot-circle"></i>특허 및 취급면허</p>
						</div>
						<div class="p-table">
							<table class="table sl">
								<colgroup>
									<col width="5%"/>
									<col width="18%"/>
									<col width="18%"/>
									<col width="18%"/>
									<col width="17%"/>
									<col width="17%"/>
									<col width="5"/>
								</colgroup>
								<thead class="thead-light">
								<tr>
									<th scope="col">선택</th>
									<th scope="col">구분</th>
									<th scope="col">특허/면허 번호</th>
									<th scope="col">특허/면허 명</th>
									<th scope="col">발급처</th>
									<th scope="col">유효기간</th>
									<th scope="col">첨부파일</th>
								</tr>
								</thead>
								<tbody>
									<c:forEach var="vnsl" items="${vnslList}" varStatus="idx">
										<tr>
											<td>
												<div class="custom-control custom-checkbox custom-checkbox-sm">
													<input type="checkbox" id="SL_CB${idx.index + 1}" name="SL_CB" class="custom-control-input" title="text" checked>
													<label class="custom-control-label font-weight-bold"></label>
												</div>
											</td>
											<td>
												<select class="custom-select" id="SL_TYPE${idx.index + 1}" name="SL_TYPE">
												<option value=""></option>
												<c:forEach var="sl" items="${slType}">
													<option value="${sl.value}" <c:if test="${sl.value == vnsl.SL_TYPE}">selected</c:if>>${sl.text}</option>
												</c:forEach>
												</select>
											</td>
											<td>
												<input type="text" id="SL_NUM${idx.index + 1}" name="SL_NUM" value="${vnsl.SL_NUM}" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="SL_NM${idx.index + 1}" name="SL_NM" value="${vnsl.SL_NM}" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="ISSUE_NM${idx.index + 1}" name="ISSUE_NM" value="${vnsl.ISSUE_NM}" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="EXPIRY_DATE${idx.index + 1}" name="EXPIRY_DATE" value="${vnsl.EXPIRY_DATE}" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<a href="javascript:doAtt_File('${idx.index + 1}', 'SL_ATT_FILE_NUM')" class="btn btn-outline-light btn-search" style="${(not empty vnsl.SL_ATT_FILE_NM) ? 'color:#0a8eeb' : ''}"><i class="fas fa-search"></i></a>
												<input type="hidden" id="SL_ATT_FILE_NUM${idx.index + 1}" name="SL_ATT_FILE_NUM" value="${vnsl.SL_ATT_FILE_NUM}"/>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div class="btn-area">
								<a href="#" class="btn btn-outline-secondary" onclick="addEvent('sl')">행추가</a>
								<a href="#" class="btn btn-outline-secondary" onclick="delEvent('SL_CB')">행삭제</a>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="fi_form" name="form">
						<div class="row">
							<p class="title">
                                <i class="fas fa-dot-circle"></i>재무정보
                                <span class="font-weight-normal"> (직전년도 정보 입력가능)</span>
                                <span class="right">단위(백만원)</span>
                            </p>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>기준년도<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select id="FI_YEAR" name="FI_YEAR" class="custom-select">
											<option value=""></option>
											<c:forEach var="fi" items="${fiYear}">
												<option value="${fi.value}">${fi.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>자료근거<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select id="EVIDENCE_TYPE" name="EVIDENCE_TYPE" class="custom-select">
											<option value=""></option>
											<c:forEach var="evidence" items="${evidenceType}">
												<option value="${evidence.value}">${evidence.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>총자산</span>
									</div>
									<div class="col-desc">
										<input type="text" id="OWNER_CAPITAL_AMOUNT" name="OWNER_CAPITAL_AMOUNT" class="form-control text-right" title="example" placeholder="(자동계산)" readonly>
									</div>
								</div>
							</div>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>총자본<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="TOT_FUND_AMT" name="TOT_FUND_AMT" value="${form.TOT_FUND_AMT}" class="form-control text-right" title="example" placeholder="" onChange="setMinusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>총부채<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="TOT_LIAB_AMT" name="TOT_LIAB_AMT" value="${form.TOT_LIAB_AMT}" class="form-control text-right" title="example" placeholder="" onChange="setPlusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>부채비율</span>
									</div>
									<div class="col-desc">
										<input type="text" id="TOTAL_LIABILITY_RATE" name="TOTAL_LIABILITY_RATE" class="form-control text-right" title="example" placeholder="(자동계산)" readonly>
									</div>
								</div>
							</div>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>유동자산<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="CURRENT_ASSET_AMOUNT" name="CURRENT_ASSET_AMOUNT" value="${form.CURRENT_ASSET_AMOUNT}" class="form-control text-right" title="example" placeholder="" onChange="setPlusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>유동부채<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="CURRENT_ASSET_LIABILITY_AMOUNT" name="CURRENT_ASSET_LIABILITY_AMOUNT" value="${form.CURRENT_ASSET_LIABILITY_AMOUNT}" class="form-control text-right" title="example" placeholder="" onChange="setPlusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>유동비율</span>
									</div>
									<div class="col-desc">
										<input type="text" id="CURRENT_ASSET_LIABILITY_RATE" name="CURRENT_ASSET_LIABILITY_RATE" class="form-control text-right" title="example" placeholder="(자동계산)" readonly>
									</div>
								</div>
							</div>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>총매출액<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="SALES_AMOUNT" name="SALES_AMOUNT" value="${form.SALES_AMOUNT}" class="form-control text-right" title="example" placeholder="" onChange="setMinusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>당기순이익<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="NET_PROFIT_AMOUNT" name="NET_PROFIT_AMOUNT" value="${form.NET_PROFIT_AMOUNT}" class="form-control text-right" title="example" placeholder="" onChange="setMinusComma(this);">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>첨부파일</span>
									</div>
									<div class="col-desc">
										<div class="input-group">
											<input class="form-control" type="search" id="VNFI_ATT_FILE_NM" name="VNFI_ATT_FILE_NM" placeholder="" aria-label="Search" readonly>
											<a href="javascript:doAtt_File('', 'VNFI_ATT_FILE_NUM')" class="btn btn-outline-light btn-search" style="${(not empty form.VNFI_ATT_FILE_NM) ? 'color:#0a8eeb' : ''}"><i class="fas fa-search"></i></a>
											<input type="hidden" id="VNFI_ATT_FILE_NUM" name="VNFI_ATT_FILE_NUM" value="${form.VNFI_ATT_FILE_NUM}"/>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="credit_form" name="form">
						<div class="row">
							<p class="title"><i class="fas fa-dot-circle"></i>관리정보</p>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>계산서발행구분<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" id="E_BILL_ASP_TYPE" name="E_BILL_ASP_TYPE">
											<option value=""></option>
											<c:forEach var="eBillAsp" items="${eBillAspType}">
												<option value="${eBillAsp.value}">${eBillAsp.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title line-2">
										<span>계산서<br/>발행사이트</span>
									</div>
									<div class="col-desc">
										<input type="text" id="TAX_ASP_NM" name="TAX_ASP_NM" value="${form.TAX_ASP_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>발행타입<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" id="TAX_SEND_TYPE" name="TAX_SEND_TYPE">
											<option value=""></option>
											<c:forEach var="taxSend" items="${taxSendType}">
												<option value="${taxSend.value}">${taxSend.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row row-3">
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>신용평가사</span>
									</div>
									<div class="col-desc">
										<input type="text" id="CREDIT_EVAL_COMPANY" name="CREDIT_EVAL_COMPANY" value="${form.CREDIT_EVAL_COMPANY}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>신용등급</span>
									</div>
									<div class="col-desc">
										<select class="custom-select" id="CREDIT_CD" name="CREDIT_CD">
											<option value=""></option>
											<c:forEach var="credit" items="${creditType}">
												<option value="${credit.value}">${credit.text}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="col-4">
								<div class="row">
									<div class="col-title">
										<span>첨부파일</span>
									</div>
									<div class="col-desc">
										<div class="input-group">
											<input class="form-control" type="search" id="EV_ATT_FILE_NM" name="EV_ATT_FILE_NM" placeholder="" aria-label="Search" readonly>
											<a href="javascript:doAtt_File('','EV_ATT_FILE_NUM')" class="btn btn-outline-light btn-search" style="${(not empty form.EV_ATT_FILE_NM) ? 'color:#0a8eeb' : ''}"><i class="fas fa-search"></i></a>
											<input type="hidden" id="EV_ATT_FILE_NUM" name="EV_ATT_FILE_NUM" value="${form.EV_ATT_FILE_NUM}"/>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="pay_form" name="form">
						<div class="row">
							<p class="title">
								<i class="fas fa-dot-circle"></i>결제정보
								<span style="color: red; font-size: 15px; float:right;">※ 1 건 이상 필수로 등록하세요.</span>
							</p>
						</div>
						<div class="p-table">
							<table class="table pay">
								<colgroup>
									<col width="5%"/>
									<col width="10%"/>
									<col width="15%"/>
									<col width="17%"/>
									<col width="8%"/>
									<col width="9%"/>
									<col width="14%"/>
									<col width="17%"/>
									<col width="0%"/>
									<col width="5%"/>
								</colgroup>
								<thead class="thead-light">
								<tr>
									<th scope="col">선택</th>
									<th scope="col">계좌별칭</th>
									<th scope="col">은행 및 지점명</th>
									<th scope="col">계좌번호</th>
									<th scope="col">예금주</th>
									<th scope="col">계좌담당자</th>
									<th scope="col">담당자연락처</th>
									<th scope="col">담당자Email</th>
									<th scope="col"></th>
									<th scope="col">첨부파일</th>
								</tr>
								</thead>
								<tbody>
									<c:forEach var="vnap" items="${vnapList}" varStatus="idx">
										<tr>
											<td>
												<div class="custom-control custom-checkbox custom-checkbox-sm">
													<input type="checkbox" id="PAY_CB${idx.index + 1}" name="PAY_CB" class="custom-control-input" title="text" checked>
													<label class="custom-control-label font-weight-bold"></label>
												</div>
											</td>
											<td>
												<input type="text" id="PAY_ACC_NM${idx.index + 1}" value="${vnap.PAY_ACC_NM}" name="PAY_ACC_NM" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<select class="custom-select" id="PAY_BANK${idx.index + 1}" name="PAY_BANK">
													<option value=""></option>
													<c:forEach var="pay" items="${payBank}">
														<option value="${pay.value}" <c:if test="${pay.value == vnap.PAY_BANK}">selected</c:if>>${pay.text}</option>
													</c:forEach>
												</select>
											</td>
											<td>
												<input type="text" id="PAY_ACCOUNT_NUM${idx.index + 1}" value="${vnap.PAY_ACCOUNT_NUM}" name="PAY_ACCOUNT_NUM" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="PAY_ACCOUNT_USER_NM${idx.index + 1}" value="${vnap.PAY_ACCOUNT_USER_NM}" name="PAY_ACCOUNT_USER_NM" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="PAY_ACC_MNG_NM${idx.index + 1}" value="${vnap.PAY_ACC_MNG_NM}" name="PAY_ACC_MNG_NM" class="form-control" title="example" placeholder="">
											<td>
												<input type="text" id="PAY_ACC_NMG_TEL_NUM${idx.index + 1}" value="${vnap.PAY_ACC_NMG_TEL_NUM}" name="PAY_ACC_NMG_TEL_NUM" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="text" id="PAY_ACC_MNG_EMAIL${idx.index + 1}" value="${vnap.PAY_ACC_MNG_EMAIL}" name="PAY_ACC_MNG_EMAIL" class="form-control" title="example" placeholder="">
											</td>
											<td>
												<input type="hidden" id="PAY_REQUIRED_FLAG${idx.index + 1}" name="PAY_REQUIRED_FLAG" value="1" />
											</td>
											<td>
												<a href="javascript:doAtt_File('${idx.index + 1}', 'PAY_ATT_FILE_NUM');" class="btn btn-outline-light btn-search" style="${(not empty vnap.PAY_ATT_FILE_NM) ? 'color:#0a8eeb' : ''}"><i class="fas fa-search"></i></a>
												<input type="hidden" id="PAY_ATT_FILE_NM${idx.index + 1}" name="PAY_ATT_FILE_NM" value="${vnap.PAY_ATT_FILE_NM}"/>
												<input type="hidden" id="PAY_ATT_FILE_NUM${idx.index + 1}" name="PAY_ATT_FILE_NUM" value="${vnap.PAY_ATT_FILE_NUM}"/>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div class="btn-area">
								<a href="#" class="btn btn-outline-secondary" onclick="addEvent('pay')">행추가</a>
								<a href="#" class="btn btn-outline-secondary" onclick="delEvent('PAY_CB')">행삭제</a>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<form id="att_form" name="form">
						<div class="row border-0">
							<p class="title">
								<i class="fas fa-dot-circle"></i>첨부파일
								<span style="color: red; font-size: 15px; float:right;">※ 법인인감증명서 첨부시 주민등록번호 뒷자리를 삭제 후 첨부하여 주시기 바랍니다.</span>
							</p>
						</div>
						<div class="p-table">
							<table class="table attach">
								<colgroup>
									<col width="41%">
									<col width="13%">
									<col width="14%">
									<col width="14%">
									<col width="9%">
									<%--<col width="9%">--%>
									<col width="9%">
								</colgroup>
								<thead class="thead-light">
								<tr>
									<th scope="col">서류명</th>
									<th scope="col">유효기간</th>
									<th scope="col">유효시작일</th>
									<th scope="col">유효종료일</th>
									<th scope="col">필수여부</th>
									<%--<th scope="col">템플릿파일</th>--%>
									<th scope="col">첨부파일</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${attachList}" var="attach" varStatus="idx">
									<tr>
										<td class="text-left">
											${attach.TMPL_FILE_NM}
											<input type="hidden" id="TMPL_BUYER_CD${idx.index + 1}" name="TMPL_BUYER_CD" value="${attach.BUYER_CD}" />
											<input type="hidden" id="TMPL_NUM${idx.index + 1}" name="TMPL_NUM" value="${attach.TMPL_NUM}" />
											<input type="hidden" id="TMPL_SQ${idx.index + 1}" name="TMPL_SQ" value="${attach.TMPL_SQ}" />
											<input type="hidden" id="TMPL_FILE_NM${idx.index + 1}" name="TMPL_FILE_NM" value="${attach.TMPL_FILE_NM}" />
										</td>
										<td>
											${attach.VALID_PERIOD}
											<input type="hidden" id="VALID_PERIOD${idx.index + 1}" name="VALID_PERIOD" value="${attach.VALID_PERIOD}" />
										</td>
										<td>
											<div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
												<input type="text" id="VALID_START_DATE${idx.index + 1}" name="VALID_START_DATE" class="form-control" value="${empty attach.VALID_START_DATE ? ' ' : attach.VALID_START_DATE}" title="datepicker" data-autohide="true" onchange="onValidDate(${idx.index + 1}, 'F');">
												<a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="fas fa-calendar-alt"></i></a>
											</div>
										</td>
										<td>
											<div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
												<input type="text" id="VALID_END_DATE${idx.index + 1}" name="VALID_END_DATE" class="form-control" value="${empty attach.VALID_END_DATE ? ' ' : attach.VALID_END_DATE}" title="datepicker" data-autohide="true" onchange="onValidDate(${idx.index + 1}, 'T');">
												<a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="fas fa-calendar-alt"></i></a>
											</div>
										</td>
										<td>
											${attach.REQUIRED_FLAG eq '1' ? 'Y' : 'N'}
											<input type="hidden" id="REQUIRED_FLAG${idx.index + 1}" name="REQUIRED_FLAG" value="${attach.REQUIRED_FLAG}" />
										</td>
										<%--
										<td>
											<c:if test="${not empty attach.TMPL_FILE_NUM_CNT}">
												<a href="javascript:doAtt_File('${idx.index + 1}', 'TMPL_FILE_NUM')" class="btn btn-outline-light btn-search"><i class="fas fa-file"></i></a>
												<input type="hidden" id="TMPL_FILE_NUM${idx.index + 1}" name="TMPL_FILE_NUM" value="${attach.TMPL_FILE_NUM}" />
											</c:if>
										</td>
										--%>
										<td>
											<a href="javascript:doAtt_File('${idx.index + 1}', 'ATTS_ATT_FILE_NUM');" class="btn btn-outline-light btn-search" style="${(not empty attach.ATTS_ATT_FILE_NM) ? 'color:#0a8eeb' : ''}"><i class="fas fa-search"></i></a>
											<input type="hidden" id="ATTS_ATT_FILE_NM${idx.index + 1}" name="ATTS_ATT_FILE_NM" value="${attach.ATTS_ATT_FILE_NM}"/>
											<input type="hidden" id="ATTS_ATT_FILE_NUM${idx.index + 1}" name="ATTS_ATT_FILE_NUM" value="${attach.ATTS_ATT_FILE_NUM}"/>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</div>
					</form>
				</div>
				<c:if test="${USER_TYPE eq 'S'}">
					<div class="p-content">
						<form id="customer_form" name="form">
							<div class="row border-0">
								<p class="title"><i class="fas fa-dot-circle"></i>거래희망 고객사</p>
							</div>
							<div class="p-table">
								<table class="table customer">
									<colgroup>
										<col width="10%">
										<col width="50%">
										<%--<col width="20%">--%>
										<col width="40%">
									</colgroup>
									<thead class="thead-light">
									<tr>
										<th scope="col">선택</th>
										<th scope="col">고객사</th>
										<%--<th scope="col">부서명</th>--%>
										<th scope="col">사유</th>
									</tr>
									</thead>
									<tbody>
										<c:forEach items="${vncmList}" var="vncm" varStatus="idx">
											<tr>
												<td>
													<div class="custom-control custom-checkbox custom-checkbox-sm">
														<input type="checkbox" id="BUYER_CB${idx.index + 1}" name="BUYER_CB" class="custom-control-input" title="text" checked>
														<label class="custom-control-label font-weight-bold"></label>
													</div>
												</td>
												<td>
													<div class="input-group">
														<input type="search" id="BUYER_NM${idx.index + 1}" name="BUYER_NM" value="${vncm.BUYER_NM}" class="form-control" placeholder="" aria-label="Search" readonly style="top: 1px;right: 1px;">
														<input type="hidden" id="BUYER_CD${idx.index + 1}" name="BUYER_CD" value="${vncm.BUYER_CD}"/>&nbsp;
														<a class="btn btn-outline-secondary d-inline-block" onclick="javascript:getBuyer('${idx.index + 1}');">일반고객</a>&nbsp;
														<a class="btn btn-outline-secondary d-inline-block" onclick="javascript:getBidBuyer('${idx.index + 1}');">입찰공고고객</a>
														<%--
														<a href="javascript:getBuyer('${idx.index + 1}');" class="btn btn-outline-light btn-search" style="position: relative; left: 0; top: 3px; height: 37px;" type="submit"><i class="fas fa-search"></i></a>
														--%>
													</div>
												</td>
												<td>
													<input type="text" id="REQ_REASON${idx.index + 1}" name="REQ_REASON" value="${vncm.REQ_REASON}" class="form-control"/>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<div class="btn-area">
									<a href="#" class="btn btn-outline-secondary" onclick="addEvent('customer')">행추가</a>
									<a href="#" class="btn btn-outline-secondary" onclick="delEvent('BUYER_CB')">행삭제</a>
								</div>
							</div>
						</form>
					</div>
				</c:if>
				<div class="p-content">
					<form id="user_form" name="form">
						<div class="row">
							<p class="title"><i class="fas fa-dot-circle"></i>관리자 정보</p>
						</div>
						<input type="hidden" id="CASE" name="CASE" value="1">
						<input type="hidden" id="USER_TYPE" name="USER_TYPE" value="${form.USER_TYPE}">
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사용자 ID<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="USER_ID" name="USER_ID" value="${user.USER_ID}" class="form-control d-inline-block" title="example" placeholder="" style="width: 278px" onchange="checkId();" autocomplete="new-password">
										<a class="btn btn-outline-secondary d-inline-block" onclick="userIdCheck();">중복체크</a>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>사용자명<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="text" id="USER_NM" name="USER_NM" value="${user.USER_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>비밀번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="password" id="PPDD" name="PPDD" class="form-control" title="example" placeholder="" onchange="checkCall();" autocomplete="off"></div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>비밀번호확인<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="password" id="PPDD_CHECK" name="PPDD_CHECK" class="form-control" title="example" placeholder="" onchange="ppddCheck();" autocomplete="off"></div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>전화번호<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="tel" id="TEL_NUM" name="TEL_NUM" value="${user.TEL_NUM}" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'T');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>e-Mail<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="email" id="USER_EMAIL" name="USER_EMAIL" value="${user.EMAIL}" class="form-control" title="example" placeholder="Email 형식에 맞게 입력해 주세요." onchange="validCheck(this, 'E');">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>팩스번호</span>
									</div>
									<div class="col-desc">
										<input type="tel" id="FAX_NUM" name="FAX_NUM" value="${user.FAX_NUM}" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'F');">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>휴대전화<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<input type="email" id="CELL_NUM" name="CELL_NUM" value="${user.CELL_NUM}" class="form-control" title="example" placeholder="EX) 000-000-0000" onchange="validCheck(this, 'C');">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>메일수신여부<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" title="Text" id="MAIL_FLAG" name="MAIL_FLAG">
											<option value=""></option>
											<option value="1">Y</option>
											<option value="0">N</option>
										</select>
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>SMS 수신여부<i class="fas fa-check"></i></span>
									</div>
									<div class="col-desc">
										<select class="custom-select" title="Text" id="SMS_FLAG" name="SMS_FLAG">
											<option value=""></option>
											<option value="1">Y</option>
											<option value="0">N</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>직위(직급)</span>
									</div>
									<div class="col-desc">
										<input type="text" id="POSITION_NM" name="POSITION_NM" value="${user.POSITION_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
							<div class="col-6">
								<div class="row">
									<div class="col-title">
										<span>직책</span>
									</div>
									<div class="col-desc">
										<input type="text" id="DUTY_NM" name="DUTY_NM" value="${user.DUTY_NM}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12">
								<div class="row">
									<div class="col-title">
										<span>담당업무</span>
									</div>
									<div class="col-desc">
										<input type="text" id="ROLE_TEXT" name="ROLE_TEXT" value="${user.ROLE_TEXT}" class="form-control" title="example" placeholder="">
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="p-content">
					<div class="btn-area">
						<button class="btn btn-xl btn-primary mr-3" onclick="doSave();">가입등록</button>
						<button class="btn btn-xl btn-primary" onclick="doHome();">가입취소</button>
					</div>
				</div>
			</div>
		</div>
	</section>
    <c:import url="/mainHtml/footer/footer.jsp" charEncoding="UTF-8"/>
</div>
</body>
</html>
