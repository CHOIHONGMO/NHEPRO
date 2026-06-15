<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>덕성테크팩</title>
    <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
    <link rel="stylesheet" href="/css/ymro/ui/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/reset.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/common.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/nanumbarungothic.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/lib/jquery.bxslider.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/layout.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/page.css" type="text/css">
    <link rel="stylesheet" href="/css/ymro/ui/paging.css" type="text/css">

    <script type="text/javascript" src="/js/everuxf/everuxf.min.js"></script>
    <script type="text/javascript" src="/js/paging/jquery.bootpag.js"></script>
    <script type="text/javascript" src="/css/ymro/js/lib/jquery.bxslider.js"></script>
    <script type="text/javascript" src="/css/ymro/js/ui/common.js"></script>
    <script type="text/javascript" src="/js/ever-string.js"></script>
    <script type="text/javascript" src="/js/ever-popup.js"></script>
    <style>
        .table_paginate .first,
        .table_paginate .prev,
        .table_paginate .next,
        .table_paginate .last {
            border: none;
        }

        .table_paginate a:active,
        .table_paginate a.active {
            border: none;
            line-height: 29px;
            color: #303030;
            font-weight: bold;
        }

        .table_paginate a {
            height: 27px;
            width: 27px;
        }

        .pagination {
            margin: 0 auto;
            padding-left: 60px;
        }
    </style>
    <script>
        $(document).ready(function () {
            // $('#mainIframe', parent.document).css('height', document.body.scrollHeight + 57);

            doSearch();
        });

        function doSearch() {
            doSearchCount();
            doSearchList();
        }

        function doSearchCount() {
            $('#countFlag').val('1');
            $.post("/ymro/mainNoticeList.so", $('#form').serialize(), function (data) {
                // paging 구현
                // TotalCount 받아오기
                var totalCount = JSON.parse(data).totalCount;
                $('#page-selection').bootpag({
                    total: parseInt((totalCount - 1) / 10 + 1),
                    page: $('#pageNo').val(),
                    maxVisible: 10,
                    leaps: true,
                    firstLastUse: true,
                    first: '<img class="pagingBtnStyle" src="/images/ymro/paging/paging_to_first.jpg" alt="처음">',
                    prev: '<img class="pagingBtnStyle" src="/images/ymro/paging/paging_to_prev.png" alt="이전">',
                    next: '<img class="pagingBtnStyle" src="/images/ymro/paging/paging_to_next.png" alt="다음">',
                    last: '<img class="pagingBtnStyle" src="/images/ymro/paging/paging_to_end.jpg" alt="마지막">',
                    wrapClass: 'pagination',
                    activeClass: 'active',
                    disabledClass: 'disabled',
                    nextClass: 'next',
                    prevClass: 'prev',
                    lastClass: 'last',
                    firstClass: 'first'
                }).on("page", function (event, /* page number here */ num) {
                    // Page 내용 별도 조회
                    $('#pageNo').val(num);
                    doSearchList();
                });
            });
        }

        function doSearchList() {
            $('#countFlag').val('0');
            $.post("/ymro/mainNoticeList.so", $('#form').serialize(), function (data) {
               data = JSON.parse(data);
                var html = "<thead>\n";
                html += "<tr>\n";
                html += "    <th>번호</th>\n";
                html += "    <th>제목</th>\n";
                html += "    <th>작성일</th>\n";
                html += "</tr>\n";
                html += "</thead>\n";
                html += "<tbody>\n";
                for( var i in data ) {
                    html += "<tr style='height: 42px;'>\n";
                    html += "    <td>" + data[i].RN + "</td>\n";
                    html += "    <td><a href=\"javascript:doClick('"+ data[i].NOTICE_NUM +"');\">" + data[i].SUBJECT + "</a></td>\n";
                    html += "    <td>" + data[i].REG_DATE + "</td>\n";
                    html += "</tr>\n";
                }
                for (var i = 0; i < 10 - data.length; i++) {
                    html += "<tr style='height: 42px;'>\n";
                    html += "    <td></td>\n";
                    html += "    <td></td>\n";
                    html += "    <td></td>\n";
                    html += "</tr>\n";
                }
                html += "</tbody>";

                $('.table_list').html(html);
            });
        }

        function doClick(notice_num) {
            var url = "/mainHtml/03_customer/03_notice_detail.jsp";
            var param = {
                NOTICE_NUM: notice_num
            };
            everPopup.openWindowPopup(url, 700, 600, param, '_self', true);
        }

    </script>
</head>
<body>
<!--wrap-->
<form id="form">
    <div class="wrap sub_page">
        <input type="hidden" id="pageNo" name="pageNo" value="1"/>
        <input type="hidden" id="countFlag" name="countFlag" value="1"/>
        <!--header_wrap-->
        <div class="header_wrap">
            <c:import url="../header/header.jsp" charEncoding="UTF-8"/>
        </div>
        <!--// header_wrap-->

        <!--spot_bg-->
        <!--회사소개: spot_intro_company -->
        <div class="spot_bg spot_customer_service"></div>
        <!--// spot_bg-->

        <!--content-->
        <div class="contents contents_cus_center contents_notice">
            <ul class="tabs tabs_col4">
                <!--탭바 클릭됬을 경우 class="active" 추가-->
                <li><a href="/mainHtml/03_customer/03_customer_opinion.jsp"><span>고객의 소리</span></a></li>
                <li><a href="/mainHtml/03_customer/03_join_guide.jsp"><span>가입안내</span></a></li>
                <li class="active"><a href="/mainHtml/03_customer/03_notice_list.jsp"><span>공지사항</span></a></li>
                <li><a href="/mainHtml/03_customer/03_faq_cus.jsp"><span>FAQ</span></a></li>
            </ul>

            <p class="path">
                <span class="one">HOME</span>
                <span class="two">고객지원</span>
                <span class="three current">공지사항</span>
            </p>
            <h3 class="title title_deco_blue_sq"><span class="title_point">타이틀</span>공지사항</h3><br>


            <div class="tabs_contents notice_list">
                <section class="notice_area">
                    <div class="table_search">
                        <fieldset class="board_search">
                            <legend class="screen_out">검색</legend>
                            <select name="selectType" id="selectType">
                                <option value="title">제목</option>
                                <option value="contents">내용</option>
                                <option value="all">전체</option>
                            </select>
                            <input type="text" class="input_search" name="searchText" id="searchText">
                            <a class="btn btn_no_radius btn_search" href="javascript:doSearch();">검색</a>
                        </fieldset>
                    </div>

                    <table class="table_list" summary="공지사항 번호, 제목, 등록일" style="height: 474px;">

                    </table>

                    <!-- 페이징 -->
                    <div class="table_paginate">
                        <div id="page-selection"></div>
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

</form>
</body>
</html>