<!--

화면ID : mobileHome.jsp
화면명 : 근로계약시스템 _모바일 화면(농협파트너스)
작성자 : 김하은
생성일 : 2022.10.12

-->

<%@page import="jxl.demo.Write"%>
<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@ page import="com.st_ones.common.util.clazz.EverDate" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/ozUrlInfo.jsp" %>

<%
    String ozSchedulerIp = PropertiesManager.getString("oz.scheduler.ip");
    String ozSchedulerPort = PropertiesManager.getString("oz.scheduler.port");
    String tempDirectory = PropertiesManager.getString("oz.source.file.path");
    String filePath = PropertiesManager.getString("everf.fileUpload.path") + EverDate.getYear() + "/" + EverDate.getYear() + EverDate.getMonth() + "/TC/PDF/";

%>
<c:set value="<%=ozExportUrl%>" var="ozExportUrl"/>
<c:set var="ozUrl" value="<%=ozUrl%>" />
<c:set var="ozServer" value="<%=ozServer%>" />
<c:set var="ozSchedulerIp" value="<%=ozSchedulerIp%>" />
<c:set var="ozSchedulerPort" value="<%=ozSchedulerPort%>" />
<c:set var="tempDirectory" value="<%=tempDirectory%>" />
<c:set var="filePath" value="<%=filePath%>" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
	<link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
	<link rel="shortcut icon" href="/images/favicon.ico"/>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
    <script type="text/javascript" src="/js/ever-formutils.js"></script>
</head>
<script>
    var regExpEMAIL = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
    var regExpTEL_NUM = /^\d{2,3}\d{3,4}\d{4}$/;
    var regExpCELL_NUM = /^\d{3,4}$/;

    var emailChangeFlag = false; // 이메일 변경 여부
    var cellChangeFlag = false;
    var passChangeFlag = false;
    var emailValidFlag = false;

    var certifiedFlag = true; // 인증시간 초과여부
    var certifiedSendFlag = false; // 인증번호전송 여부
    var certifiedConfirmFlag = false; // 인증성공여부

    var signFlag;

    var interval;

    var contractData;
    var pledgeData;

    function onChangeMonth() {
        var url = "/nhepro/MOBILE_NHPT/getDay.so";
        var param = {
            YEAR: $('#BIRTH_DATE1').val(),
            MONTH: $('#BIRTH_DATE2').val()
        };

        $.post(url, param, function (data) {

            var birth_date3 = "";
            for (var i = 1; i <= Number(data.DAY); i++) {
                if(i < 10) {
                    birth_date3 += "<option value='0" + i + "'>" + i + "일</option>";
                } else {
                    birth_date3 += "<option value='" + i + "'>" + i + "일</option>";
                }

            }

            $('#BIRTH_DATE3').html(birth_date3)
        }, "json");
    }

    function downloadFile(uuid, uuid_sq, fileType) {
        if (!top['hidden_workspace'] || top['hidden_workspace'] == undefined) {
            var $aLink = $("<a id='hidden_workspace' download></a>");
            $aLink.appendTo(document.body);
        }

        var url = "/common/file/fileAttach/viewPdf.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=" + uuid + "&UUID_SQ=" + uuid_sq;
        window.open(url, "eform", "width=850,height=1265,scrollbars=yes,resizeable=no,left=0,top=0");

        document.getElementById("hidden_workspace").click();
    }

    // 근로계약서
    function doContract() {
        var url = "/nhepro/MOBILE_NHPT/mobileHome_contract_list.so";
        $.post(url, {}, function (data) {
            contractData = data;

            var contractHtml = "";
            for(var i in data) {
                contractHtml += '<tr>';
                contractHtml += '   <td><a href="javascript:doSearchForms(' + i + ', \'cont\');"><span class="txt-sgn-target">' + data[i].CODE_DESC + '</span></a></td>';
                contractHtml += '   <td><a href="javascript:doSearchForms(' + i + ', \'cont\');">' + data[i].CONT_DATE + '</a></td>';
                contractHtml += '   <td class="txt-left"><a href="javascript:doSearchForms(' + i + ', \'cont\');">' + data[i].CONT_DESC + '</a></td>';
                if( !(everString.isEmpty(data[i].SIGN_DATE)) ) {
                	contractHtml += '   <td>' + data[i].SIGN_DATE  + '</td>';
                } else {
                    contractHtml += '   <td></td>';
                }
                if( !(everString.isEmpty(data[i].SIGN_DATE)) ) {
                    //contractHtml += '   <td><a href="/common/file/fileAttach/download.so?EVER_REQUEST_DATA_TYPE=FILE_DOWNLOAD&UUID=' + data[i].UUID + '&UUID_SQ=' + data[i].UUID_SQ + '"><img src="resource/images/lghnh-m-file.png" alt="첨부파일" class="ico-file"></a></td>';
                    contractHtml += '   <td><a href="javascript:downloadFile(\''+data[i].UUID+'\', \''+data[i].UUID_SQ+'\', \'cont\')"><img src="/images/nhepro/mobile/m-file.png" alt="첨부파일" class="ico-file"></a></td>';
                } else {
                    contractHtml += '   <td></td>';
                }
                contractHtml += '</tr>';
            }

            $('#contract-list tbody').html(contractHtml);
        }, "json");
    }

    function doSearchForms(contNum,contType ) {    	
    	//폼 파일명 가져오기
    	var url = "/nhepro/MOBILE_NHPT/mobileHome_subFormList.so";

    	 var param = {
    	            "CONT_NUM": contractData[contNum].CONT_NUM
    	        };
    	 
         $.post(url, param, function (data) {
            
        	 mainFormFileNm = data[0].FORM_FILE_NM;
          	// 서브 폼 파일명
     	
     		for(var i in data) {
     			if(i==0){ //0일때는 메인서식명
     				continue;
     			}else{
     				var value = data[i].FORM_FILE_NM;
     				subFormFileNm += value + ",";
     			}
     		}
     		 console.log("subFormFileNm"+subFormFileNm);
       	 
         }, "json");

    	
    	var mainFormFileNm = "";
     	var subFormFileNm = "";
     	
         setTimeout(function() {
        	 doContractReport(contNum, contType, mainFormFileNm, subFormFileNm);
         }, 1000);

         
    }
    
    
    function doContractReport(contNum, contType, mainFormFileNm, subFormFileNm ) {
    	
        var contData = contractData[contNum];
    
        if(contData.CODE_DESC == '근로자 서명대기') {
          
            var param = {
            		
                //detailView: false,
                // 파라미터 값 셋팅
                bizType: "TC",
                BUYER_CD: contData.BUYER_CD,
                CONT_NUM: contData.CONT_NUM,
                CONT_CNT: contData.CONT_CNT,
                // 파일명
              	ozrName: mainFormFileNm,
                // 서브 파일명
                SUB_FORM_FILE_NM: subFormFileNm.substring(0, subFormFileNm.length - 1),
                // ODI 명
                odiName: "CONTRACT",
                // OZ Scheduler Info
                serverUrl: "${ozServer}",
                schedulerIp: "${ozSchedulerIp}",
                schedulerPort: "${ozSchedulerPort}",
                exportFileName: contData.BUYER_CD + contData.CONT_NUM + contData.CONT_CNT + "${ses.userId}",
                exportFormat: "ozr",             
                callbackFunction: "contract_reload",
                url: "${ozUrl}",
                ozExportUrl: "${ozExportUrl}"
            };
			
		
            var url = "${ozUrl}" + "/ozhviewer_canvas_eform2.jsp";
            everPopup.openWindowPopup(url, 1085, 1265, param, 'eform');

        } else if(contData.CODE_DESC == '계약체결 완료') {
            doPdfPage(contNum, contType);
        }

    }
    


    function contract_reload(data) {
        // 계약완료 처리
        //123
        var url = "/nhepro/MOBILE_NHPT/mobile_doContract.so";
        var param = {
            "UUID" : EVF.getUUID(true),
            "UUID_SQ" : new Date().getTime(),
            "USER_ID" : '${ses.userId}',
            "BIZ_TYPE" : 'TC',
            "filePath" : '${filePath}',
            "sourcePath": '${tempDirectory}' + 'pdf/',
            "fileNm": data.exportFileName,
            "CONT_NUM": data.CONT_NUM,
            "CONT_CNT": data.CONT_CNT,
            "BUYER_CD": data.BUYER_CD
        };

        $.post(url, param, function (data) {
        }, "json");

        setTimeout(function() {
            location.reload();
        }, 1000);

        //doContract();
    }

    // 공지사항
    function doNotice() {
        var url = "/nhepro/MOBILE_NHPT/mobileHome_doNotice_list.so";
        $.post(url, {}, function (data) {
            var contractHtml = "";
            for(var i in data) {
                contractHtml += '<tr>';
                contractHtml += '   <td class="txt-left"><a href="javascript:doNoticePage(\'' + data[i].NOTICE_NUM + '\');">' + data[i].SUBJECT + '</a></td>';
                contractHtml += '   <td>' + data[i].START_DATE + '</td>';
                contractHtml += '   <td>' + data[i].CODE_DESC + '</td>';
                contractHtml += '</tr>';
            }

            $('#notice-list tbody').html(contractHtml);
        }, "json");
    }
   
    // 회원정보
    function doMember() {
        var url = "/nhepro/MOBILE_NHPT/mobileHome_doMember.so";

        $.post(url, {}, function (data) {
            signFlag = data.PROGRESS_CD;

            $('input').each(function (k, v) {
                if (v.type == 'text') {
                    if (data[v.id] == undefined) {
                        v.value = '';
                    } else {
                        v.value = data[v.id];
                    }
                }
                if (v.type == 'radio') {
                    if (data[v.name] == 'M') {
                        $('#MALE').attr('checked', true);
                    } else if (data[v.name] == 'F') {
                        $('#FEMALE').attr('checked', true);
                    }
                }
                if(v.type == 'hidden') {
                    if (data[v.id] == undefined) {
                        v.value = '';
                    } else {
                        v.value = data[v.id];
                    }
                }
            });

            $('select').each(function(k, v) {
                if (data[v.id] != undefined) {
                    v.value = data[v.id];
                }
            });
        }, "json");
    }

    function logout() {
        if (confirm('${msg.M0039}')) {
            var store = new EVF.Store();
            store.setParameter("userId", "${ses.userId }");
            store.setParameter("userName", "${ses.userNm }");
            store.load('/logout.so', function () {
                alert(this.getResponseMessage());
                window.open('', '_self', '');

                location.href = '/mobileNHPT/';
            });
        }
    }

    function doPdfPage(num, type) {

        var value;
        // 근로계약서, 서약서 상세페이지 호출
        if(type == 'cont') {
            value = contractData[num];
        } else {
            value = pledgeData[num];
        }

        var filter = "win16|win32|win64|mac|macintel";
        if (navigator.platform) {
            if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
                downloadFile(value.UUID, value.UUID_SQ, type);
            } else {
                downloadFile(value.UUID, value.UUID_SQ, type);
                /*
                var store = new EVF.Store();
                store.setParameter('bizType', 'PDF');
                store.setParameter('fileId', value.UUID);

                store.load('/common/file/fileAttach/getUploadedFileInfo.so', function() {
                    var fileInfoJson = JSON.parse(this.getParameter('fileInfo'));

                    $.each(fileInfoJson, function(i, datum) {
                        var width = $('body').outerWidth(true);
                        var height = $('body').outerHeight(true);

                        if (window.navigator && window.navigator.msSaveOrOpenBlob) { // IE workaround
                            downloadFile(value.UUID, value.UUID_SQ);
                        }
                        else { // much easier if not IE
                            var pdfWindow = window.open('', 'pdfView', 'width='+ width +', height='+ height);
                            pdfWindow.document.write("<iframe width='" + (width - 20) + "' height='" + height + "' src='data:application/pdf;base64, " + encodeURI(datum.BYTE_ARRAY)+"'></iframe>")
                        }
                    });
                });
                */
            }
        }

        /*
        var url = "/ClipReport4/exportForPartPDFView.jsp";

        var width = $('body').outerWidth(true);
        var height = $('body').outerHeight(true);

        var pdfWindow = window.open('', '_self', 'width='+ width +', height='+ height);

        // 1번 방식
        if(type == 'cont') {
            var cont = contractData[num];
            pdfWindow.document.write('<iframe width="' + (width - 20) + '" height="' + height + '" src="' + url + '?EFORM_KEY=' + cont.EFORM_KEY + '&UUID=' + cont.UUID + '&UUID_SQ=' + cont.UUID_SQ + '&FILE_PATH=' + cont.FILE_PATH + '"></iframe>');
        } else {
            var pledge = pledgeData[num];
            pdfWindow.document.write('<iframe width="' + (width - 20) + '" height="' + height + '" src="' + url + '?EFORM_KEY=' + pledge.EFORM_KEY + '&UUID=' + pledge.UUID + '&UUID_SQ=' + pledge.UUID_SQ + '&FILE_PATH=' + pledge.FILE_PATH + '"></iframe>');
        }

        // 2번 방식
        if(type == 'cont') {
            everPopup.openWindowPopup(url, 1020, 700, contractData[num], 'userAgreeCheck');
        } else {
            everPopup.openWindowPopup(url, 1020, 700, pledgeData[num], 'userAgreeCheck');
        }
        */
    }

    function doNoticePage(notice_num) {
        // 공지사항 상세
        var url = "/nhepro/MOBILE_NHPT/MPTECM_060/view.so";
        var param = {
            NOTICE_NUM: notice_num
        };

        everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
    }
	
 	// 2021.05.17 사용자 ID 입력 시 금지어 체크
    function checkUserId(){
    	
    	var str = $('#USER_ID').val();
    	
    	var map = everString.Injection(str);
        
		if(!map.success) {
			changeIdFlag = true;
			$('#USER_ID').val('');
           	$('#USER_ID').focus();
           	
        	return alert(map.msg);
        }
    }
 
    function ppddCheck() {
        if($('#PASSWORD').val() != $('#PASSWORD_CFN').val()) {
            $('#PASSWORD').val('');

            if($('#PASSWORD_CFN').val() != '') {
                $('#PASSWORD_FLAG').val('1');
            }

            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();

            return alert("비밀번호가 일치하지 않습니다.");
        } else {
            passChangeFlag = false;
        }
    }

    function checkCall(){
        passChangeFlag = true;

        var str = $('#PASSWORD').val();
        if(!CheckPassWord(str)){
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
        }
        
        if(!chkPwd(str)){2
            $('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
        }
        
		var inject = everString.Injection(str);
        
        if(inject.success) {
        } else {
        	$('#PASSWORD').val('');
            $('#PASSWORD_CFN').val('');
            $('#PASSWORD').focus();
            alert(inject.msg);
        }
    }
    
  	//2021.03.17 비밀번호 입력시 '%' 특수문자 입력 불가하도록 체크
    function CheckPassWord(str){
    	var reg_pwd = new Array();
    	reg_pwd.push("%");
    	for(var i=0; i < reg_pwd.length; i++){
    		if(str.indexOf(reg_pwd[i])!= -1){
        		EVF.alert("비밀번호 입력 시 % 특수문자는 사용할 수 없습니다.");
        		return false;
    		}
    	}
    	
    	return true;
    }

    function chkPwd(str){
        var SamePass_1 = 0;
        var SamePass_2 = 0;

        var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
        var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
        
        if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){
        } else {
            alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요.");
            return false;
        }
        
        if(str.length > 20){
            alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요.");
            return false;
        }

        for(var i=0; i < str.length; i++) {
            var chr_pass_0 = str.charAt(i);
            var chr_pass_1 = str.charAt(i+1);
            
            var SamePass_0 = 0;
			for(var j = i; j < str.length; j++) {
				if(chr_pass_0 == str.charAt(j)) {
					SamePass_0 = SamePass_0 + 1
				}
			}
			
			if(SamePass_0 > 2) {
				alert("동일문자를 3번 이상 사용할 수 없습니다.");
				return false;
			}
			
            var chr_pass_2 = str.charAt(i+2);
            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
                SamePass_1 = SamePass_1 + 1
            }

            if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
                SamePass_2 = SamePass_2 + 1
            }
        }
        
        if(SamePass_1 > 1 || SamePass_2 > 1) {
            alert("연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다.");
            return false;
        }

        return true;
    }

    function validTelCellEmail(e, type) {
        var id = e.id;
        var value = $('#' + id).val();

        if (type == 'C') {
            if(id != "CELL_NUM1") {
                if (!value.match(regExpCELL_NUM)) {
                    alert("전화번호 앞자리 3~4 자리를 입력하여 주시기 바랍니다.");
                    $('#' + id).val('');
                    $('#' + id).focus();
                    return;
                } else {
                    cellChangeFlag = true;
                }
            }

        } else if (type == 'T') {
            if (!value.match(regExpTEL_NUM)) {
                alert("형식이 일치하지 않습니다. ex) 02-0000-0000");
                $('#' + id).focus();
                return;
            }
        } else if (type == 'E') {
            emailChangeFlag = true;

            if (!value.match(regExpEMAIL)) {
                $('#' + id).focus();
                emailValidFlag = false;
                return alert("이메일 형식이 일치하지 않습니다.");
            } else {
                emailValidFlag = true;
            }
            
			var map = everString.Injection(value);
            
            if(!map.success) {
            	$('#' + id).val('');
                $('#' + id).focus();
                emailValidFlag = false;
                
            	return alert(map.msg); 
            }
        }
    }

    function perUser() {
        var url = '/nhepro/MOBILE_NHPT/MPTAGG_030/view.so';
        var param = {
            callBackFunction: "setPerUser",
            modalYn: false
        };
        everPopup.openWindowPopup(url, 700, 600, param, 'perUser');
    }

    function setPerUser(data) {
        $('#SITE_USER_ID').val(data.USER_ID);
        $('#SITE_USER_NM').val(data.USER_NM);
    }

    function setZipCode(zipcd) {
	    if (zipcd.ZIP_CD != "") {
		    $('#ZIP_CD').val(zipcd.ZIP_CD_5 == '' ? zipcd.ZIP_CD : zipcd.ZIP_CD_5);
		    $('#ADDR').val(zipcd.ADDR);
		    $('#ADDR_ETC').focus();
	    }
    }

</script>
<body>
<div class="header">
    <h1><img src="/images/nhepro/common/logo_firstepro.png" alt="FIRSTePro 빠르고 투명한 전자구매/계약 서비스"></h1>
    <a href="#" class="btn-logout" onclick="javascript:logout();">로그아웃</a>
</div>
<div class="page-wrap">
    <form id="form" name="form">
    <section class="contents">
        <div class="tabs-box home">
            <ul class="tabs-menu">
                <li style ="width:33%;"><a href="#contract-list" onclick="doContract();">근로계약서</a></li>
                <li style ="width:33%;"><a href="#notice-list" onclick="doNotice();">공지사항</a></li>
                <li style ="width:33%;"><a href="#member-info" onclick="doMember();">회원정보</a></li>
            </ul>
            <div class="tabs-contents">
                <div class="cont" id="contract-list">

                    <div class="table-header-fixed">
                        <div class="data-table">
                            <div class="header-bg"></div>
                            <table class="list">
                                <caption>근로계약서 목록</caption>
                                <colgroup>
                                    <col style="width:17%"/>
                                    <col style="width:23%"/>
                                    <col style="width:25%"/>
                                    <col style="width:23%"/>
                                    <col style="width:12%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">
                                        <div class="th-fx01">상태</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx02">계약일자</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx03">계약명</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx04">서명일자</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx05">PDF</div>
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
				 <div class="cont" id="notice-list">
                    <div class="table-header-fixed">
                        <div class="data-table">
                            <div class="header-bg"></div>
                            <table class="list">
                                <caption>공지사항 목록</caption>
                                <colgroup>
                                    <col style="width:57%"/>
                                    <col style="width:23%"/>
                                    <col style="width:20%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th scope="col">
                                        <div class="th-fx01">제목</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx02">공지일자</div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-fx03">게시구분</div>
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
                <div class="cont" id="member-info">
                    <!-- 회원정보 -->
                    <section class="fbox sign-up">
                        <fieldset class="ins">
                            <legend class="v-hidden">회원가입</legend>
                                <div class="t-row">
                                    <div class="t-cell01"><label for="USER_ID"><i class="title required"></i>사용자 ID</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="USER_ID" id="USER_ID" value="" readonly>
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="USER_NM"><i class="title required"></i>이름</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="USER_NM" id="USER_NM" value="" readonly>
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="PASSWORD"><i class="title"></i>신규 비밀번호</label></div>
                                    <div class="t-cell02">
                                        <input type="password" name="PASSWORD" id="PASSWORD" value="" onchange="javascript:checkCall();" autocomplete=off>
                                        <span class="txt-info">&#40; 영문, 숫자, 특수문자 조합 8자 이상 &#41;</span>
                                    </div>
                                </div>
                                <div class="t-row">
                                    <div class="t-cell01"><label for="PASSWORD_CFN"><i class="title"></i>비밀번호 확인</label></div>
                                    <div class="t-cell02">
                                        <input type="password" name="PASSWORD_CFN" id="PASSWORD_CFN" value="" onchange="javascript:ppddCheck();" autocomplete=off>
                                        <input type="hidden" name="PASSWORD_FLAG" id="PASSWORD_FLAG">
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="CELL_NUM1" class="t10"><i class="title"></i>휴대전화번호</label></div>
                                    <div class="t-cell02">
                                        <div class="t-row">
                                            <div class="t-cell02" style="flex: none;">
                                                <select name="CELL_NUM1" id="CELL_NUM1" onchange="javascript:validTelCellEmail(this, 'C');">
                                                    <option value="010">010</option>
                                                    <option value="011">011</option>
                                                    <option value="016">016</option>
                                                    <option value="017">017</option>
                                                    <option value="018">018</option>
                                                    <option value="019">019</option>
                                                    <option value="0130">0130</option>
                                                </select>
                                            </div>
                                            <div class="t-cell02" style="flex: none;">
                                                <span>&nbsp;</span>
                                            </div>
                                            <div class="t-cell02">
                                                <input type="text" name="CELL_NUM2" id="CELL_NUM2" maxlength="4" style="text-align: center;" onchange="javascript:validTelCellEmail(this, 'C')">
                                            </div>
                                            <div class="t-cell02" style="flex: none;">
                                                <span style="top: 6px; position: relative;">-</span>
                                            </div>
                                            <div class="t-cell02">
                                                <input type="text" name="CELL_NUM3" id="CELL_NUM3" maxlength="4" style="text-align: center;" onchange="javascript:validTelCellEmail(this, 'C')">
                                            </div>
                                            <div class="t-cell03">
                                                <button type="button" class="btn-check" id="certified_send_btn">인증번호전송</button>
                                            </div>
                                        </div>

                                        <div class="t-row">
                                            <div class="t-cell02">
                                                <input type="text" name="CERTIFIED_NUMBER" id="CERTIFIED_NUMBER" value="">
                                            </div>
                                            <div class="t-cell03">
                                                <button type="button" class="btn-check" id="certified_confirm_btn">인증번호확인</button>
                                            </div>
                                        </div>
                                        <div class="t-row t0">
                                            <span class="txt-info"><span id="second">120</span>초 이내에 인증번호를 확인 하세요.</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="t-row">
                                    <div class="t-cell01"><label for="EMAIL"><i class="title"></i>E-mail</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="EMAIL" id="EMAIL" value="" onchange="validTelCellEmail(this, 'E');">
                                    </div>
                                    <div class="t-cell03">
                                        <button type="button" class="btn-check" id="email-btn">중복확인</button>
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="ZIP_CD"><i class="title required"></i>우편번호</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="ZIP_CD" id="ZIP_CD" value="">
                                    </div>
                                    <div class="t-cell03">
                                        <button type="button" class="btn-check" id="zip_search">우편번호검색</button>
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="ADDR"><i class="title required"></i>주소</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="ADDR" id="ADDR" value="" readonly style="background-color: #ebebe4;">
                                    </div>
                                </div>
                                <div class="t-row">
                                    <div class="t-cell01"><label for="ADDR_ETC"><i class="title required"></i>상세주소</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="ADDR_ETC" id="ADDR_ETC" placeholder="상세주소를 입력해 주세요.">
                                    </div>
                                </div>

                                <div class="t-row">
                                    <div class="t-cell01"><label for="BIRTH_DATE1"><i class="title required"></i>생년월일</label></div>
                                    <div class="t-cell02">
                                        <select name="BIRTH_DATE1" id="BIRTH_DATE1" title="년도 선택">

                                        </select>
                                    </div>
                                    <div class="t-cell02">
                                        <select name="BIRTH_DATE2" id="BIRTH_DATE2" title="월 선택" onchange="javascript:onChangeMonth();">
                                            <option value="01" selected>1월</option>
                                            <option value="02">2월</option>
                                            <option value="03">3월</option>
                                            <option value="04">4월</option>
                                            <option value="05">5월</option>
                                            <option value="06">6월</option>
                                            <option value="07">7월</option>
                                            <option value="08">8월</option>
                                            <option value="09">9월</option>
                                            <option value="10">10월</option>
                                            <option value="11">11월</option>
                                            <option value="12">12월</option>
                                        </select>
                                    </div>
                                    <div class="t-cell02">
                                        <select name="BIRTH_DATE3" id="BIRTH_DATE3" title="일 선택">
                                            <option value="01" selected>1일</option>
                                            <option value="02">2일</option>
                                            <option value="03">3일</option>
                                            <option value="04">4일</option>
                                            <option value="05">5일</option>
                                            <option value="06">6일</option>
                                            <option value="07">7일</option>
                                            <option value="08">8일</option>
                                            <option value="09">9일</option>
                                            <option value="10">10일</option>
                                            <option value="11">11일</option>
                                            <option value="12">12일</option>
                                            <option value="13">13일</option>
                                            <option value="14">14일</option>
                                            <option value="15">15일</option>
                                            <option value="16">16일</option>
                                            <option value="17">17일</option>
                                            <option value="18">18일</option>
                                            <option value="19">19일</option>
                                            <option value="20">20일</option>
                                            <option value="21">21일</option>
                                            <option value="22">22일</option>
                                            <option value="23">23일</option>
                                            <option value="24">24일</option>
                                            <option value="25">25일</option>
                                            <option value="26">26일</option>
                                            <option value="27">27일</option>
                                            <option value="28">28일</option>
                                            <option value="29">29일</option>
                                            <option value="30">30일</option>
                                            <option value="31">31일</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="t-row">
                                    <div class="t-cell01"><label for="SITE_USER_NM"><i class="title required"></i>현장담당자</label></div>
                                    <div class="t-cell02">
                                        <input type="text" name="SITE_USER_NM" id="SITE_USER_NM" readonly style="background-color: #ebebe4;" placeholder="담당자를 검색해 주세요.">
                                        <input type="hidden" name="SITE_USER_ID" id="SITE_USER_ID">
                                    </div>
                                    <div class="t-cell03">
                                        <a href="javascript:perUser();" class="btn-check">담당자검색</a>
                                    </div>
                                </div>
                        </fieldset>
                    </section>
                    <div class="btn-area f-none">
                        <button type="button" class="btn-basic" id="doSave">회원정보 수정</button>
                    </div>
                    <!-- //회원정보 -->

                </div>
            </div>
        </div>
    </section>
    </form>
</div>

<script>
    function scroll_nav(n) {
        $('.scroll').scrollLeft($('.scroll').scrollLeft() + n);
    }
</script>
<script>
    $(function () {
        //탭(ul) onoff
        $('.tabs-box .tabs-contents').children().css('display', 'none');
        $('.tabs-box .tabs-contents div:first-child').css('display', 'block');
        $('.tabs-box .tabs-menu li:first-child').addClass('active');
        $('.tabs-box').delegate('.tabs-menu li', 'click', function (e) {
            e.preventDefault();
            var index = $(this).parent().children().index(this);
            $(this).siblings().removeClass();
            $(this).addClass('active');
            $(this).parent().next('.tabs-contents').children().hide().eq(index).show();
        });

        if('${pageType}' == 'N') {
                $('ul.tabs-menu li a[href="#notice-list"]').click();
        } else {
            // 최초 호출 시 근로계약서 불러오기
            doContract();
            doMember();
        }

        // 회원정보 셋팅
        // 현재 날짜를 받아서 -100년의 값을 계산하여 BIRTH_DATE1 에 넣어준다.
        var now_year = ${NOW_YEAR};
        var birth_date1 = "";
        for (var i = now_year - 100; i <= now_year; i++) {
            birth_date1 += "<option value='" + i + "'>" + i + "년</option>";
        }
        $('#BIRTH_DATE1').html(birth_date1);
        // Default 는 현재 날짜
        $('#BIRTH_DATE1').val(now_year);

        /*******************************************************************************
         * 우편번호 검색
         *******************************************************************************/
        $('#zip_search').on('click', function (e) {
	        var url = '/common/code/BADV_022/view.so';

	        var param = {
		        callBackFunction : "setZipCode",
		        modalYn : false
	        };

	        everPopup.jusoPop(url, param);
        });

        /*******************************************************************************
         * 이메일 중복확인
         *******************************************************************************/
        $('#email-btn').on('click', function (e) {
            if($('#EMAIL').val() == '') {
                $('#EMAIL').focus();
                return alert("이메일을 입력하여 주시기 바랍니다.");
            }

            if(emailValidFlag) {
                var url = "/nhepro/MOBILE_NHPT/emailCheck.so";
                var param = {
                    USER_ID: $('#USER_ID').val(),
                    EMAIL: $('#EMAIL').val()
                };
                $.post(url, param, function (data) {

                    if(data.USR_EMAIL_CNT == '1') {
                        emailChangeFlag = false;
                        return alert("사용하실 수 있는 이메일 입니다.");
                    }

                    if(data.EMAIL_CNT == '1') {
                        $('#EMAIL').focus();
                        emailChangeFlag = true;
                        return alert("사용하실 수 없는 이메일 입니다.");
                    } else {
                        emailChangeFlag = false;
                        return alert("사용하실 수 있는 이메일 입니다.");
                    }

                }, 'json');
            } else {
                return;
            }
        });

        /*******************************************************************************
         * 인증번호전송
         *******************************************************************************/
        $('#certified_send_btn').on('click', function (e) {
            var $cell_num2 = $('#CELL_NUM2');
            var $cell_num3 = $('#CELL_NUM3');
            if ($cell_num2.val() == '' || $cell_num2.val().length < 3) {
                $cell_num2.focus();
                return alert("휴대전화번호를 제대로 입력하여 주시기 바랍니다.");
            }

            if ($cell_num3.val() == '' || $cell_num3.val().length < 4) {
                $cell_num3.focus();
                return alert("휴대전화번호를 제대로 입력하여 주시기 바랍니다.");
            }

            // 인증번호전송을 누르면 인증시간 초기화
            $('#second').text('120');

            // 인증 시간 기록
            var url = "/nhepro/MOBILE_NHPT/certified_update.so";
            var param = {
                CELL_NUM: $('#CELL_NUM1').val() + "-" + $('#CELL_NUM2').val() + "-" + $('#CELL_NUM3').val()
            };
            $.post(url, param, function (data) {
                alert("인증번호를 발송하였습니다.");

                // 인증번호전송여부 체크
                certifiedSendFlag = true;
                certifiedFlag = true;

                // 120초간 반복하여 인증시간 갱신
                interval = setInterval(function () {
                    if (Number($('#second').text()) == 0) {
                        // 초기화화
                        certifiedFlag = false;
                        clearInterval(interval);
                    } else {
                        $('#second').text(Number($('#second').text()) - 1);
                    }
                }, 1000);
            });
        });

        /*******************************************************************************
         * 인증번호확인
         *******************************************************************************/
        $('#certified_confirm_btn').on('click', function (e) {
            if (!certifiedSendFlag) {
                alert("인증번호전송을 요청하여 주시기 바랍니다.");
                return;
            }

            if (certifiedConfirmFlag) {
                alert("인증 완료 되었습니다.");
            }

            if (certifiedFlag) {
                // 인증 시간 기록
                var url = "/nhepro/MOBILE_NHPT/certified_confirm.so";
                var param = {
                    CELL_NUM: $('#CELL_NUM1').val() + "-" + $('#CELL_NUM2').val() + "-" + $('#CELL_NUM3').val(),
                    CERTIFIED_NUMBER: $('#CERTIFIED_NUMBER').val()
                };
                $.post(url, param, function (data) {
                    if (data.CONFIRM_FLAG == '1') {
                        certifiedConfirmFlag = true;
                        cellChangeFlag = false;
                        clearInterval(interval);
                        alert("인증 성공하였습니다.");
                    } else {
                        certifiedConfirmFlag = false;
                        alert("인증번호를 다시 확인하여 주시기 바랍니다.");
                    }
                }, 'json');
            } else {
                alert("인증시간이 초과하였습니다.\n재인증 요청하여 주시기 바랍니다.");
            }
        });

        /*******************************************************************************
         * 저장
         *******************************************************************************/
        $('#doSave').on('click', function () {
            // Validation 체크
            var returnFlag = false;
            $('input').each(function(k, v) {
                if (v.type == 'text') {
                    if( !(v.id == 'PASSWORD' || v.id == 'PASSWORD_CFN' || v.id == 'CELL_NUM1' || v.id == 'CELL_NUM2' || v.id == 'CELL_NUM3' || v.id == 'CERTIFIED_NUMBER' ) ) {
                        if(v.value == '') {
                            formUtil.animate(v.id, 'form');
                            returnFlag = true;
                        }
                    }
                }
            });

            if(returnFlag) {
                return alert("필수 값을 입력하여 주시기 바랍니다.");
            }

            if(passChangeFlag) {
                if($('#PASSWORD_CFN').val() == '' && $('#PASSWORD_FLAG').val() == '1') {
                    return;
                } else if($('#PASSWORD_CFN').val() == '') {
                    $('#PASSWORD_CFN').focus();
                    return alert("비밀번호 확인란에 비밀번호를 입력하여 주시기 바랍니다.");
                }
            }

            if(cellChangeFlag) {
                return alert("휴대전화번호를 다시 인증하여 주시기 바랍니다.");
            }

            if(emailChangeFlag) {
                return alert("이메일을 중복체크 하여 주시기 바랍니다.");
            }
			
            var url = "/nhepro/MOBILE_NHPT/doSave.so";
            if(confirm("회원 정보를 수정하시겠습니까?")) {
            	console.log ("returnflag"+ returnFlag);
                $.post(url, $('#form').serialize(), function (data) {
                    if(data.responseCode == 'success') {
                        return alert("${msg.M0016}");
                    } else if(data.responseCode == 'fail') {
                        return alert(data.responseMsg);
                    }
                }, "json");
            }
        })
    });
</script>
</body>