<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>덕성테크팩</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <link rel="stylesheet" href="/css/ymro/ui/style.css" type="text/css">
    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/css/ymro/js/lib/jquery.bxslider.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>
    <script type="text/javascript" src="/js/ever-formutils.js"></script>
    <script>
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
                return EVF.alert("필수 값을 입력하여 주시기 바랍니다.");
            }

            // I : ID 찾기, P : PW 찾기
            $.post('/register/doSearchInfo.so', $('input').serialize(), function (data) {
                if(sFlag == 'I') {
                    if(data) {
                        // USER_ID 존재 시 보여주기
                        var html = "<dt>사용자 ID</dt>\n";
                        html+= "<dd style='color: red; font-weight: bold;'>"+ data.USER_ID +"</dd>";

                        $('#USER_ID_VIEW').html(html);
                    } else {
                        $('#USER_ID_VIEW').empty();
                        EVF.alert("사용자 ID가 존재하지 않습니다. \n다시 확인하여 주시기 바랍니다.");
                        return ;
                    }
                } else if (sFlag == 'P') {
                    if(data.responseCode == 'fail') {
                        EVF.alert("사용자 정보가 존재하지 않습니다. \n다시 확인하여 주시기 바랍니다.");
                        return;
                    } else if(data.responseCode == 'success') {
                        EVF.alert("사용자 패스워드를 이메일로 전송하였습니다.");
                        return;
                    } else {
                        EVF.alert("비밀번호 이메일 전송중 오류가 발생하였습니다. \n운영자에게 문의하여 주시기 바랍니다.");
                        return;
                    }
                }

            }, "json");
        }
    </script>
</head>
<body>
    <!--wrap-->
    <div class="wrap sub_page">
        <!--header_wrap-->
        <div class="header_wrap">
            <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
        </div>
        <!--// header_wrap-->

        <!--spot_bg-->
        <div class="spot_bg spot_user_registery"></div>
        <!--// spot_bg-->

        <!--content-->
        <div class="contents contents_user contents_search_id">
            <div class="clearfix">
                <h3 class="title title_h_28">ID/PW 찾기</h3>

                <section>
                    <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>아이디 찾기</h3>
                    <input type="hidden" id="sFlag" name="sFlag">
                    <div class="search_info">
                        <dl class="clearfix">
                            <dt>사용자구분</dt>
                            <dd>
                                <input type="radio" name="I_USER_TYPE" value="O" alt="사용자구분"/> 운영사
                                <input type="radio" name="I_USER_TYPE" value="C" alt="사용자구분"/> 고객사
                                <input type="radio" name="I_USER_TYPE" value="V" alt="사용자구분"/> 공급사
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>사용자명</dt>
                            <dd>
                                <input type="text" id="I_USER_NM" name="I_USER_NM" alt="사용자명">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>E-mail</dt>
                            <dd>
                                <input type="text" id="I_EMAIL" name="I_EMAIL" alt="E-mail">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>휴대전화</dt>
                            <dd>
                                <input type="text" id="I_CELL_NO" name="I_CELL_NO" alt="휴대전화">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>사업자등록번호</dt>
                            <dd>
                                <input type="text" id="I_IRS_NO" name="I_IRS_NO" alt="사업자등록번호">
                            </dd>
                        </dl>
                        <dl class="clearfix" id="USER_ID_VIEW" name="USER_ID_VIEW">
                        </dl>

                    </div>
                    <div class="btn_wrap">
                        <a href="javascript:doSearch('I');" class="btn btn_no_icon btn_middle">아이디 찾기</a>
                    </div>
                </section>
                <section>
                    <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>비밀번호 찾기</h3>
                    <div class="search_info">
                        <dl class="clearfix">
                            <dt>사용자 ID</dt>
                            <dd>
                                <input type="text" id="P_USER_ID" name="P_USER_ID">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>사용자명</dt>
                            <dd>
                                <input type="text" id="P_USER_NM" name="P_USER_NM">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>E-mail</dt>
                            <dd>
                                <input type="text" id="P_EMAIL" name="P_EMAIL">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>휴대전화</dt>
                            <dd>
                                <input type="text" id="P_CELL_NO" name="P_CELL_NO">
                            </dd>
                        </dl>
                        <dl class="clearfix">
                            <dt>사업자등록번호</dt>
                            <dd>
                                <input type="text" id="P_IRS_NO" name="P_IRS_NO">
                            </dd>
                        </dl>
                    </div>
                    <div class="btn_wrap">
                        <a href="javascript:doSearch('P');" class="btn btn_no_icon btn_middle">비밀번호 찾기</a>
                    </div>
                </section>
            </div>
        </div>
        <!--// content-->

        <!--footer_wrap-->
        <div class="footer_wrap">
            <c:import url="../footer/footer.jsp" charEncoding="UTF-8"/>
        </div>
        <!--// footer_wrap-->
    </div>
    <!--// wrap-->

</body>
</html>