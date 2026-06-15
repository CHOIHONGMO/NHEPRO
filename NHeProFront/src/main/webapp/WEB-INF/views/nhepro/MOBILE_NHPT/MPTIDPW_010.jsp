<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <meta name="robots" content="index,nofollow">
    <meta name="description" content="FIRSTePro 빠르고 투명한 전자구매/계약 서비스">
    <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
    <link rel="stylesheet" href="/css/nhepro/nhepro-m.css">
    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
</head>
<script>
    function mobileHome() {
        location.href = '/mobileNHPT/index.jsp';
    }

    function confirm() {
        var url = "/nhepro/MOBILE_NHPT/MPTIDPW_010_doSearch.so";
        var param = {
            USER_NM: $('#USER_NM').val(),
            //EMAIL: $('#EMAIL').val()
            CELL_NUM : $('#CELL_NUM').val()
        };
        $.post(url, param, function (data) {
            if(data.responseCode == 'success') {
                var url = "/nhepro/MOBILE_NHPT/MPTIDPW_020/view.so";
                var param = {
                    USER_ID: data.USER_ID
                };

                everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
            } else {
                return alert("이름 또는 휴대전화를 다시 확인하여 주시기 바랍니다."); 

            }
        }, 'json');
    }

    function sendPw() {
        var url = "/nhepro/MOBILE_NHPT/MPTIDPW_010_doSendPw.so";
        var param = {
            USER_ID: $('#USER_ID').val(),
            //EMAIL: $('#EMAIL2').val()
            CELL_NUM : $('#CELL_NUM2').val()
        };
        $.post(url, param, function (data) {
            if(data.responseCode == 'success') {
                var url = "/nhepro/MOBILE_NHPT/MPTIDPW_030/view.so";
                var param = {
                    //EMAIL: data.EMAIL
                    CELL_NUM : data.CELL_NUM
                };

                everPopup.openWindowPopup(url, 700, 600, param, '_self', false);
            } else {
                return alert("아이디 또는 이메일을 다시 확인하여 주시기 바랍니다."); // 아이디 또는 이메일을 다시 확인하여 주시기 바랍니다.

            }
        }, 'json');
    }
</script>
<body>
<div class="header">    
     <h1>아이디/비밀번호 찾기</h1> 
</div>       
<div class="page-wrap">

    <section class="contents">

        <div class="tabs-box">
            <ul class="tabs-menu">
                <li><a href="#find-id">아이디 찾기</a></li>
                <li><a href="#find-pw">비밀번호 찾기</a></li>
            </ul>
            <div class="tabs-contents"> 
                
                <!-- 아이디 찾기 -->
                <div class="cont" id="find-id">
                    <ul class="txt-info">
                        <li><em>※</em><strong>회원가입 시 입력해주신 이름</strong>을 입력해 주세요.</li>
                    </ul>    
                    <fieldset class="ins">
                        <legend class="v-hidden">아이디 찾기</legend>
                        <form>
                            <div class="fbox">
                                <div class="i-text">
                                    <label for="USER_NM"><i class="dot"></i>이름</label>
                                    <input type="text" name="USER_NM" id="USER_NM" value="">
                                </div>
                                <!--  
                                <div class="i-text">
                                    <label for="EMAIL"><i class="dot"></i>이메일</label>
                                    <input type="text" name="c-EMAIL" id="EMAIL" value="">
                                </div>
                                -->              
                                 <div class="i-text" >
                                    <label for="CELL_NUM"><i class="dot"></i>휴대전화</label>
                                     <input type="text" name="CELL_NUM" id="CELL_NUM" class = "tel" maxlength="13" style="text-align: left;">
                                  </div>                                   
                                                                  
                                <div class="btn-area">                        
                                                               
                                    <button type="button" class="btn-darkgray" onclick="javascript:mobileHome();">취소 </button>
                                    <button type="button" class="btn-basic" onclick="javascript:confirm();">확 인</button>
                                </div>
                            </div>
                        </form>                
                    </fieldset>
                    
                </div>
                <!-- //아이디 찾기 -->
                
                <!-- 비밀번호 찾기 -->
                <div class="cont" id="find-pw">
                    <ul class="txt-info">
                        <li><em>※</em>비밀번호를 잊어버리셨다면 본인 확인 절차를 거쳐 비밀번호를 재발급 할 수 있습니다.</li>
                    </ul>    
                    <fieldset class="ins">
                        <legend class="v-hidden">비밀번호 찾기</legend>
                        <form>
                            <div class="fbox">
                                <div class="i-text">
                                    <label for="USER_ID"><i class="dot"></i>아이디</label>
                                    <input type="text" name="USER_ID" id="USER_ID" value="">
                                </div>
                                 <div class="i-text">
                                    <label for="CELL_NUM2"><i class="dot"></i>휴대전화</label>
                                     <input type="text" name="CELL_NUM2" id="CELL_NUM2" class = "tel" maxlength="13" style="text-align: left;">
                                  </div>
                                  <!--  
                                <div class="i-text">
                                    <label for="EMAIL2"><i class="dot"></i>이메일</label>
                                    <input type="text" name="EMAIL2" id="EMAIL2" value="">
                                </div>  
                               -->                               
                                <div class="btn-area">                                
                                    <button type="button" class="btn-darkgray" onclick="javascript:mobileHome();">취소 </button>
                                    <button type="button" class="btn-basic" onclick="javascript:sendPw();">확 인</button>
                                </div>
                            </div>
                        </form>                
                    </fieldset>
                </div>
                <!-- //비밀번호 찾기 -->
            </div>
        </div>
        
    </section>   
</div>
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

        if('${pageFlag}' == 'P') {
            $('ul.tabs-menu li a[href="#find-pw"]').click();
        }

    });
    

</script>
</body>

</html>