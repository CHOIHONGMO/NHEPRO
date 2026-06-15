<%@ page import="com.st_ones.everf.serverside.config.PropertiesManager" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String CP_CD = PropertiesManager.getString("kcb.company.id");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Referrer" content="origin">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-mobile-web-app-title" content="FIRSTePro" />
    <meta name="robots" content="index,nofollow" />
    <meta name="description" content="FIRSTePro" />
    <meta name="keywords" content="FIRSTePro" />
    <meta name="format-detection" content="telephone=no" />
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/fonts/NanumGothic.css">
    <link rel="stylesheet" href="/css/nhepro/bootstrap.min.css">
    <link rel="stylesheet" href="/css/nhepro/page.css">
    <script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="/js/nhepro/bundle.js"></script>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-formutils.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>
    
    <style type="text/css">
		.loading {
			background: url(/images/icon/loader-indicator6.gif) center center no-repeat #fff;
		}
	</style>
	
    <script>
        var url = "/register/";
		var kcbData;
        function doSearch(sFlag) {
            $('#sFlag').val(sFlag);

            // validation 체크
            var returnFlag = false;
            $('input[name*='+ sFlag +'_]').each(function(k, v) {
                var val = "";
                if(v.type == 'radio') {
                    val = $('input[name='+ v.name +']:checked').val();
                } else {
                    val = $('input[name='+ v.name +']').val();
                }

                if(val == undefined || val == '' || val == null) {
                    formUtil.animate(v.name, 'form');
                    returnFlag = true;
                }
            });

            if(returnFlag) {
                return alert("필수 값을 입력하여 주시기 바랍니다.");
            }

            if (!everString.isTel($("#I_CELL_NO").val())) {
                return alert("형식이 일치하지 않습니다. ex)010-0000-0000");
            }

            if (!everString.isTel($("#P_CELL_NO").val())) {
                return alert("형식이 일치하지 않습니다. ex)010-0000-0000");
            }

            // I : ID 찾기, P : PW 찾기
            
            //2021.12.06 ID찾기 시 조회가 오래 걸리는 이유로 로딩바 표현
            if(sFlag == 'I') {
            	var to = document.getElementById("a");
            	to.classList.add("loading");
            }
            $.post(url + "doSearchInfo.so", $('input').serialize(), function (data) {
                if(sFlag == 'I') {
                	var to = document.getElementById("a");
                	to.classList.remove("loading");
                    if(data) {
                        // USER_ID 존재 시 보여주기
                        var html = "<div class='col-title'>사용자 ID</div>\n";
                        html+= "<div class='col-desc' style='color:red; font-weight: bold; line-height: 2.5;'>"+ data.USER_ID +"</div>";
                        $('#USER_ID_VIEW').html(html);
                    } else {
                        $('#USER_ID_VIEW').empty();
                        alert("사용자 ID가 존재하지 않습니다. \n다시 확인하여 주시기 바랍니다.");
                        return ;
                    }
                    
                } else if (sFlag == 'P') {
	                // kcbCallbackFunction({RSLT_MSG: "본인인증 완료", RSLT_NAME: "조지아"});
                    if(data.responseCode == 'fail') {
                        alert("사용자 정보가 존재하지 않습니다. \n다시 확인하여 주시기 바랍니다.");
                        return;
                    } else if(data.responseCode == 'success') {
                        // 핸드폰 인증(KCB)
                        var url = "/kcb/phone_popup2.jsp";
                        var param = {
                            CP_CD: "<%=CP_CD%>",
                            SITE_NAME: "농협정보시스템"
                        };
                        everPopup.openWindowPopup(url, 430, 640, param, 'auth_popup', true);
                    } else {
                        alert("비밀번호 문자 전송중 오류가 발생하였습니다. \n운영자에게 문의하여 주시기 바랍니다.");
                        return;
                    }
                }
            }, "json");
        }
		
        function kcbCallbackFunction(data) {
	        kcbData = data;
            if (data.RSLT_MSG == "본인인증 완료" && data.RSLT_NAME == $("#P_USER_NM").val() &&  data.TEL_NO.replace(/\-/g,'') == $("#P_CELL_NO").val().replace(/\-/g,'') ) {
                // PW 핸드폰 전송
                $.post(url + "doSendPwSMS.so", $('input').serialize(), function (data) {
					alert("사용자 패스워드를 이메일, 핸드폰으로 전송하였습니다.");
                });
            } else {
                alert("본인인증 정보가 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
			}
        }
    </script>
</head>
<body>
<div class="wrap">
    <!--header_wrap-->
    <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
    <!--// header_wrap-->

    <section class="personal sign_in find-info">
        <h2 class="sr-only">아이디 / 패스워드 찾기</h2>
        <div class="title">
            <p>아이디 / 패스워드 찾기</p>
        </div>
        <div class="box">
            <div class="content">
                <div class="p-content">
                    <p class="p-title">ID/PW 찾기</p>
                    <div class="row">
                        <div class="col-5">
                            <p class="title"><i class="fas fa-dot-circle"></i>아이디 찾기</p>
                            <input type="hidden" id="sFlag" name="sFlag">
                            <div class="row">
                                <div class="border-top pt-4"></div>
                                <div class="col-title">사용자구분</div>
                                <div class="col-desc">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="customRadio1" name="I_USER_TYPE" class="custom-control-input" value="O">
                                        <label class="custom-control-label font-weight-bold" for="customRadio1">운영사</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="customRadio2" name="I_USER_TYPE" class="custom-control-input" value="B">
                                        <label class="custom-control-label font-weight-bold" for="customRadio2">고객사</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="customRadio3" name="I_USER_TYPE" class="custom-control-input" value="S">
                                        <label class="custom-control-label font-weight-bold" for="customRadio3">공급사</label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">사용자명</div>
                                <div class="col-desc">
                                    <input type="text" id="I_USER_NM" name="I_USER_NM" class="form-control" title="example" placeholder="회원 가입시 입력한 사용자명">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">E-mail</div>
                                <div class="col-desc">
                                    <input type="email" id="I_EMAIL" name="I_EMAIL" class="form-control" title="example" placeholder="">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">휴대전화</div>
                                <div class="col-desc">
                                    <input type="text" id="I_CELL_NO" name="I_CELL_NO" class="form-control" title="example" placeholder="">
                                </div>
                            </div>
                            <%--<div class="row">
                                <div class="col-title">사업자등록번호</div>
                                <div class="col-desc">
                                    <input type="text" id="I_IRS_NO" name="I_IRS_NO" class="form-control" title="example" placeholder="">
                                </div>
                                <div class="border-top mt-4"></div>
                            </div>--%>
                            <div class="row" id="USER_ID_VIEW" name="USER_ID_VIEW"></div>
                            <div class="btn_wrap">
                                <a id="a" href="javascript:doSearch('I');" class="btn btn_no_icon btn_middle">아이디 찾기</a>
                            </div>
                        </div>

                        <div class="offset-1 col-5">
                            <p class="title"><i class="fas fa-dot-circle"></i>비밀번호 초기화</p>
                            <div class="row">
                                <div class="border-top pt-4"></div>
                                <div class="col-title">사용자 ID</div>
                                <div class="col-desc">
                                    <input type="text" id="P_USER_ID" name="P_USER_ID" class="form-control" title="example" placeholder="">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">사용자명</div>
                                <div class="col-desc">
                                    <input type="text" id="P_USER_NM" name="P_USER_NM" class="form-control" title="example" placeholder="핸드폰 본인인증을 위한 실 사용자명">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">E-mail</div>
                                <div class="col-desc">
                                    <input type="email" id="P_EMAIL" name="P_EMAIL" class="form-control" title="example" placeholder="">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-title">휴대전화</div>
                                <div class="col-desc">
                                    <input type="text" id="P_CELL_NO" name="P_CELL_NO" class="form-control" title="example" placeholder="">
                                </div>
                            </div>
                            <%--<div class="row">
                                <div class="col-title">사업자등록번호</div>
                                <div class="col-desc">
                                    <input type="text" id="P_IRS_NO" name="P_IRS_NO" class="form-control" title="example" placeholder="">
                                </div>
                                <div class="border-top mt-4"></div>
                            </div>--%>
                            <div class="btn_wrap">
                                <a href="javascript:doSearch('P');" class="btn btn_no_icon btn_middle">비밀번호 초기화</a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>
    <!--footer_wrap-->
    <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
    <!--// footer_wrap-->
</div>
    <!--// wrap-->
    <script>
        $(document).ready(function() {
            $(".set > a").on("click", function() {
                if ($(this).hasClass("active")) {
                    $(this).removeClass("active");
                    $(this)
                    .siblings(".content")
                    .slideUp(100);
                } else {
                    // $(".set > a").removeClass("active");
                    $(this).addClass("active");
                    // $(".content").slideUp(200);
                    $(this)
                    .siblings(".content")
                    .slideDown(100);
                }
            });
        });
    </script>
</body>
</html>