<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="everDate" class="com.st_ones.common.util.clazz.EverDate" />
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">

    <script type="text/javascript" src="/js/home.js"></script>
    <script type="text/javascript" src="/js/everuxf/lib/jquery.pnotify.min.js"></script>
	<script type="text/javascript" src="/js/ever-alarm.js"></script>
	<script type="text/javascript" src="/js/ever-dwr.js"></script>
	<%--<script type="text/javascript" src="/dwr/engine.js"></script>--%>
	<%--<script type="text/javascript" src="/dwr/interface/everAlarm.js"></script>--%>
	<%--<script type="text/javascript" src="/dwr/util.js"></script>--%>
	<script src="/resource/webfonts/fontawesome-free/js/all.min.js"></script>
    <link rel="stylesheet" href="/css/home.css">
	<link rel="stylesheet" href="/css/jquery.pnotify.default.css">
	<link rel="stylesheet" href="/resource/webfonts/fontawesome-free/css/all.min.css">

    <link rel="shortcut icon" href="/images/favicon.ico"/>
    <title>FIRSTePro - 협력사 ${ses.userNm}님 환영합니다.</title>

    <script>

        var tabs;
        var tabLimit = Number('${tabLimit}');

        $(window).resize(function(){
        });

        $(document).ready(function() {

            $('#mainIframe', parent.parent.document).css('height', '100vh').css('width', '100%');

            var layout = EVF.Properties.layout;
            layout.west.minSize = 282;
            layout.west.maxSize = 282;
            //layout.west.resizable = false;
            layout.west.slidable = true;
            layout.west.closable = true;
            //layout.west.spacing_open = 0;
            //layout.west.spacing_closed = 0;
            $('#e-window-container-body').layout(layout);

            tabs = $('#e-main-tab').height( ($('.ui-layout-center').height()) ).tabs();

            //dwr.engine.setActiveReverseAjax(true);
            //everAlarm.init('${ses.userType}', '${ses.userId}', '${ses.companyCd}');
            homeJs.warningUser('${ses.ipAddress}', '${getYear}.${getMonth}.${getDay} ${getFormattedTime}');

            $('.e-topmenu-wrapper').click(function(e) {
                $('.e-topmenu-wrapper').removeClass('e-topmenu-selected');
                $(this).toggleClass('e-topmenu-selected');
            });

            $('.e-topmenu-wrapper').hover(
                function(e) { $(this).addClass('e-topmenu-hover'); },
                function(e) { $(this).removeClass('e-topmenu-hover'); }
            );

            <%-- 탭버튼에 X 닫기 버튼 --%>
            tabs.delegate("span.ui-icon-close", "click", function() {
                var panelId = $(this).closest('li').remove().attr("aria-controls");
                $('#'+panelId).attr('src', null);
                $('#'+panelId).remove();
                tabs.tabs('refresh');
                if(typeof CollectGarbage == 'function') {
                    CollectGarbage();
                }
            }).css({"cursor":"pointer"});

            $.contextMenu({
                selector: '.ui-tabs-nav li',
                callback: function(key, options) {
                    switch(key) {
                        case 'closeOtherTabs':
                            var thisId = $('a', $(this)).attr('href');
                            $('#e-main-tab ul li').each(function(index, b) {
                                var targetTabId = $('a', $(b)).attr('href');
                                if( !(targetTabId == '#ui-tabs-main' || thisId == targetTabId) ) {
                                    var tid = targetTabId.replace('#', '');
                                    $('#e-main-tab ul li[aria-controls='+tid+']').remove();
                                    $('#e-main-tab iframe[id='+tid+']').remove();
                                }
                            });

                            $('#e-main-tab').tabs('refresh');
                            $('#e-main-tab').tabs('option', 'active', 1);

                            if(typeof CollectGarbage == 'function') {
                                CollectGarbage();
                            }

                            break;
                        case 'closeAllTabs':
                            $('#e-main-tab ul li').each(function(index, b) {
                                var targetTabId = $('a', $(b)).attr('href');
                                if( targetTabId != '#ui-tabs-main' ) {
                                    var tid = targetTabId.replace('#', '');
                                    $('#e-main-tab ul li[aria-controls='+tid+']').remove();
                                    $('#e-main-tab iframe[id='+tid+']').remove();
                                }
                            });

                            $('#e-main-tab').tabs('refresh');
                            $('#e-main-tab').tabs('option', 'active', 0);

                            if(typeof CollectGarbage == 'function') {
                                CollectGarbage();
                            }

                            break;
                        case 'popupThisTab':
                            var $iframe = $($('a', $(this)).attr('href'));
                            var param = 'height='+(Number($iframe.outerHeight(true))-150)
                                +',width='+(Number($iframe.outerWidth(true))-150)
                                +',menubar=no,toolbar=no,status=no,location=no,resizable=yes,scrollbars=yes';
                            window.open($iframe.attr('src')+"&popupFlag=true", '', param);

                            break;
                    }
                },
                items: {
                    'closeOtherTabs': {name: '다른 탭 닫기', icon: 'ui-tab--arrow'},
                    'closeAllTabs':   {name: '전체 탭 닫기', icon: 'ui-tab--minus'},
                    'popupThisTab':   {name: '이 탭 팝업하기', icon: 'ui-tab--plus'}
                }
            });

            resizeComponent();

            if("${supplierIrsSameIdYN}"=="Y") {
                EVF.alert("새로운관리자를 생성하십시오.\n사업자 번호와 같은 아이디는 사용안함 처리 바랍니다.\n일정기간이후 사업자번호와 동일한 아이디는 삭제됩니다.");
                openScreenToNewTab("TM901295","회사/사용자 정보","/siis/M03/M03_003/view.so","");
            } else if("${supplierNewYN}"=="Y"){
                openScreenToNewTab("TM901295","회사/사용자 정보","/siis/M03/M03_003/view.so","");
            }
        });

        function init() {

            // 전화번호, 휴대전화번호, E-Mail
            var telNum = '${ses.telNum}';
            var cellNum = '${ses.cellNum}';
            var email = '${ses.email}';

            var message = '';

            message += '${ses.userNm} 님!\n';

            if (telNum == '') {
                message += '전화번호\n';
            }
            if (cellNum == '') {
                message += '휴대전화번호\n';
            }
            if (email == '') {
                message += 'E-Mail\n';
            }
            message += '정보가 존재하지 않습니다. 사용자 정보를 변경해 주십시오.';

            if("${supplierChagePWYN}"=="Y"){
                message = '아이디와 비밀번호가 동일합니다. 비밀번호를 변경해주십시오.';
            }
            if (
                telNum == ''
                ||cellNum == ''
                ||email == ''
                ||"${supplierChagePWYN}"=="Y"
            ) {
                EVF.alert(message);
                openUserInfo();
            }

            <c:forEach var="noticePopup" items="${noticeListPopup}">
                noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
            </c:forEach>

            initHome('${topMenu[0].MAIN_MODULE_TYPE}');
        }

        function noticeCookieCheck(noticeNum, loginPopupNotice) {
            var blnCookie = cookie.getCookie('div_laypopup' + noticeNum);
            if (!blnCookie) {
                openNotice(noticeNum, loginPopupNotice);
            }
        }

        <%-- 창닫기 --%>
        function closeWinAt00(winName, expiredays) {
            cookie.setCookie(winName, "done", expiredays);
        }

        function openNotice(noticeNum, loginPopupNotice) {
            var url = "/eversrm/board/notice/BBON_010/view.so";
            var param = {
                NOTICE_NUM: noticeNum,
                popupFlag: true,
                detailView: true,
                loginPopupNotice: loginPopupNotice
            };
            everPopup.openWindowPopup(url, 1100, 670, param, 'NOTICE' + noticeNum);
        }

        function logout() {
            if (confirm('${msg.M0039}')) {
                var store = new EVF.Store();
                store.setParameter("userId", "${ses.userId }");
                store.setParameter("userName", "${ses.userNm }");
                store.load('/logout.so', function() {
                    EVF.alert(this.getResponseMessage());
                    location.href = this.getParameter('locationAfterLoggedOut');
                });
            }
        }

        function goHome() {
            var store = new EVF.Store();
            if(!store.validate()) return;
            store.load('/eversrm/system/cacheSync.so', function(){
                location.href="/home.so";
            }, false);
        }

        function openUserInfo() {
            var param = {};
            if ('${everSslUseFlag}'=='true') {
                window.open('${realDomainUrl}'+'/nhepro/CETR/CETR0010/view.so?popupFlag=true',"사용자정보", "width=700,height=620,scrollbars=yes,resizeable=no,left=150,top=150");
            } else {
                var url = '/nhepro/CETR/CETR0010/view.so?popupFlag=true';
                everPopup.openWindowPopup(url, 700, 620, null,'openUserInfo');
            }
        }

        function openScreenToNewTab(id, text, value, e, data) {
            if ($('#ui-tabs-' + id).length > 0) {
                if( data ) {
                    $('#ui-tabs-label-' + id).remove();
                    $('#ui-tabs-' + id).remove();
                    $('#e-main-tab').tabs('refresh');
                } else {
                    return $('#e-main-tab').tabs('option', 'active', $('li#ui-tabs-label-'+id).index());
                }
            }

            // Parameter 처리
            var param = '';
            if( data ) {
                for(var i in data) {
                    param += "&" + i + "=" + encodeURIComponent(data[i]);
                }
            }

            if ($('#e-main-tab li').length > tabLimit) {

                var title = $('#e-main-tab ul li').eq(1).prop('title');
                EVF.confirm('탭의 제한수[' + tabLimit + '개]가 초과되었습니다.\n\n[' + title + '] 탭을 닫고 선택하신 화면을 여시겠습니까?', function () {

                    $('#e-main-tab ul li').eq(1).remove();
                    $('#e-main-tab iframe').eq(1).attr('src', null).remove();

                    openTab(id, text, value, param);
                });

            } else {
                openTab(id, text, value, param);
            }

            if ($('#sitemapMenu').css('display') == 'block') {
                $("#sitemapMenu").slideToggle();
            }

        }

        function openTab(id, text, value, param) {

            var store = new EVF.Store();
            store.setParameter('tmpl_menu_cd', id);
            store.setParameter('moduleName', value);
            store.setParameter('jobDesc', text);
            store.setParameter('methodName', "menuClick");
            store.setParameter('actionCode', "menuClick");
            store.load('/common/util/' + 'menuClickSave.so', function () {

                if (this.getResponseCode() == '1') {

                    var screenName = encodeURIComponent(text);
                    var $tabLabel = $('<li id="ui-tabs-label-' + id + '" name=' + text + ' title="' + text + '"><a href="#ui-tabs-' + id + '" style="width: 80px; padding-right: 0px;">' + text + '</a> <span class="ui-icon ui-icon-close" role="presentation"></span></li>').hide();
                    $('#e-main-tab ul').append($tabLabel);
                    $tabLabel.slideDown('fast');

                    if (text == '사용자정보') {

                        if ('${everSslUseFlag}'=='true') {
                            value = '${realDomainUrl}' + value;
                        }
                    }

                    var $iframes = $('#e-main-tab iframe');

                    $('#e-main-tab').append($('<iframe id="ui-tabs-' + id + '" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" height="100%" src="' + value + '?tmpl_menu_cd=' + id + '&screen_name=' + screenName + param +'" style="padding: 0; margin: 0; height: 100%;"></iframe>'));
                    $('#e-main-tab').tabs('refresh');
                    var $tabs = $('#e-main-tab').tabs('option', 'active', ($('#e-main-tab > ul > li').length - 1));

                    // 탭 이동
                    $tabs.find(".ui-tabs-nav").sortable({
                        axis: "x",
                        stop: function () {
                            $tabs.tabs("refresh");
                        }
                    });

                    resizeComponent();
                }

            }, false);
        }

    </script>
    <e:window id="e-body" width="100%" height="100%" onReady="init" initData="${initData}" padding="0 0 0 0">

        <div id="contentsBody" class="ui-layout-center" style="width: 100%;">
            <div id="e-main-tab" class="e-main-tab" style="height: 100%; width: 100%; cursor: default !important;">
                <%--
                <div class="e-user-info-div">
                    <div style="font-size: 12px;display: table-cell;vertical-align: middle;height: 20px;">${ses.userNm}</div>
                    <div style="font-size: 17px;vertical-align: middle;display: table-cell;padding: 0;margin: 0;width: 26px;">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div style="font-size: 17px;vertical-align: middle;display: table-cell;padding: 0;margin: 0;width: 26px;" onclick="javascript:logout();">
                        <i class="fas fa-sign-out-alt"></i>
                    </div>
                </div>
                --%>
                <ul>
                    <li><a href="#ui-tabs-main" title="HOME">HOME</a></li>
                </ul>
                <iframe id="ui-tabs-main" src="/eversrm/mypageSupplier/view.so" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" height="100%" src="" style="padding: 0; margin: 0; height: 100%; width: 100%;"></iframe>
                <%--<ul>
                    <li><a href="#ui-tabs-main" title="HOME">발주접수현황</a></li>
                </ul>
                <iframe id="ui-tabs-main" src="/nhepro/SPOR/SPOR0010/view.so" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" height="100%" src="" style="padding: 0; margin: 0; height: 100%; width: 100%;"></iframe>--%>
            </div>
        </div>

        <div class="ui-layout-west">
            <div class="ui-layout-center">
                <%-- 로고 --%>
                <div style="height: 28px;width: 100%;cursor:pointer;background: url(/images/nhepro/common/top_slogan_2.png) 50% 50% no-repeat;margin-top: 5px;margin-bottom: 3px;" title="로고" onclick="goHome();"></div>
                <div style="height: 40px;width: 100%;cursor:pointer;background: url(/images/nhepro/common/logo_firstepro.png) 50% 50% no-repeat;margin-bottom: 3px;" title="로고" onclick="goHome();"></div>
                <%-- Line --%>
                <div id="line" style="height: 1px; width: 100%; background-color: #d6d6d6;"></div>
                <%-- 로그인 정보 --%>
                <div style="height: 54px; width: 100%; background-color: #ededed;">
                    <div style="width: 134px; float: left; vertical-align: middle; line-height: 17px; padding: 9px; text-overflow: ellipsis; white-space: nowrap;">
                        <span style="color: #027bc2; font-size: 10pt;">${ses.userNm}</span><br/>
                        <span style="color: #484848; font-size: 10pt;">${ses.deptNm}</span>
                    </div>
                    <div style="width: 74px; float: right; position: relative; top: 3px; right: 4px;">
                        <div id="e-btn-myinfo" class="e-session-btn-wrapper" onclick="openUserInfo();">
                            <i class="fas fa-user-circle"></i>
                            <span class="e-session-btn-text-wrapper" title="사용자 정보를 확인하려면 클릭하세요.">MY INFO</span>
                        </div>
                        <div id="e-btn-logout" class="e-session-btn-wrapper" onclick="logout();">
                            <i class="fas fa-sign-out-alt"></i>
                            <span class="e-session-btn-text-wrapper" title="로그아웃하시려면 클릭하세요.">LOGOUT</span>
                        </div>
                    </div>
                </div>
                <%-- Line --%>
                <div id="line" style="height: 2px; width: 100%; background-color: #d6d6d6;"></div>
                <div style="height:100%; width:74px; float: left; background-color: #134e80;">
                    <div style="width: 100%; text-align: center; user-select: none; background-color: #134e80;">
                        <c:forEach items="${topMenu}" var="menu">
                            <div id="${menu.CODE}" class="e-topmenu-wrapper" onclick="fetchLeftMenu('${menu.CODE}')">
                                <div class="e-topmenu-icon-wrapper">
                                    <c:choose>
                                        <c:when test="${menu.CODE eq 'MP'}"><span style="color: #fff;"><i class="fas fa-user fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'OG'}"><span style="color: #fff;"><i class="fas fa-sitemap fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'CU'}"><span style="color: #fff;"><i class="fas fa-building fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'IT'}"><span style="color: #fff;"><i class="fas fa-boxes fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'CM'}"><span style="color: #fff;"><i class="fas fa-calculator fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'SRM'}"><span style="color: #fff;"><i class="fas fa-thumbs-up fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'ST'}"><span style="color: #fff;"><i class="fas fa-tasks fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'MA'}"><span style="color: #fff;"><i class="fas fa-cog fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'AP'}"><span style="color: #fff;"><i class="fas fa-edit fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'BI'}"><span style="color: #fff;"><i class="fas fa-exclamation-circle fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'PR'}"><span style="color: #fff;"><i class="fas fa-dolly-flatbed fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'SM'}"><span style="color: #fff;"><i class="fas fa-stamp fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'OM'}"><span style="color: #fff;"><i class="fas fa-file-alt fa-2x"></i></span></c:when>
                                        <c:when test="${menu.CODE eq 'AD'}"><span style="color: #fff;"><i class="fas fa-id-card fa-2x"></i></span></c:when>
                                    </c:choose>
                                </div>
                                <div class="e-topmenu-text-wrapper">
                                    <span class="e-topmenu-text" title='${menu.CODE}/${menu.CODE_DESC}'>${menu.CODE_DESC}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div style="height:100%; margin: 0; padding: 0; overflow:hidden; float: left; position: relative;">
                    <%-- 메뉴트리 --%>
                    <div style="overflow: auto; width: 100%;">
                        <e:treePanel id="leftMenuTree" width="100%" height="100%" onClickNode="openScreenToNewTab"/>
                    </div>
                </div>
            </div>
        </div>

        <div class="sitemap scrollbar" id="sitemapMenu" style="display:none;">
            <a href="#" onclick="closeLayout();" style="text-decoration: none;" class="btn-layerClose">X</a>
            <c:forEach items="${topMenu}" var="topMenuList" varStatus="idx">
                <%--<c:if test="${idx.count eq '1' or idx.count eq '7'}">--%>
                <div>
                        <%--</c:if>--%>
                    <script>
                        // 화면 사이즈 계산
                        $('.sitemap div').css('width', 'calc(100% - ' + '${topMenu.size()}' + ')');
                    </script>
                    <div class="force-overflow">
                        <ul>
                            <p>${topMenuList.CODE_DESC}</p>
                            <c:forEach items="${leftMenuAll}" var="leftMenu">
                                <c:if test="${leftMenu.moduleType eq topMenuList.CODE }">
                                    <c:if test="${leftMenu.value == null}">
                                        <li style="font-weight: 900;">${leftMenu.text}</li>
                                        <c:forEach items="${leftMenuAll}" var="leftMenu2">
                                            <c:if test="${leftMenu.id eq leftMenu2.parentId}">
                                                <li>
                                                    <div class="e-window-toolbar" title="">
                                                        <div class="e-bookmark-icon-wrapper" style="width: 23px;">
                                                            <c:choose>
                                                                <c:when test="${leftMenu2.BOOKMARK_CNT > 0}">
                                                                    <div name="bookmark" title="자주 쓰는 메뉴를 즐겨찾기해서 사용할 수 있습니다." class="e-icon-bookmark-on" data-name="${leftMenu2.id}"></div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div name="bookmark" title="자주 쓰는 메뉴를 즐겨찾기해서 사용할 수 있습니다." class="e-icon-bookmark-off" data-name="${leftMenu2.id}"></div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <a href="#none" onclick="openScreenToNewTab('${leftMenu2.id}', '${leftMenu2.text}', '${leftMenu2.value}', this, '${leftMenu2.outUrl}', '${leftMenu2.popup}');">${leftMenu2.text}</a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:if>
                            </c:forEach>
                        </ul>
                    </div>
                        <%--<c:if test="${idx.count eq '6' or idx.last}">--%>
                </div>
                <%--</c:if>--%>
            </c:forEach>
        </div>
    </e:window>
    <script>
        var oldinnerText = "screenDefault";
        $(document).ready(function () {
            $('#e-main-tab').on('dblclick', function (e) {
                var id = e.target.offsetParent.id.replace('label-', '');

                if(id != 'e-main-tab' && id != '') {
                    $('#' + e.target.offsetParent.id).remove();
                    $('#' + id).remove();
                    tabs.tabs('refresh');

                }
            });

            $('#e-main-tab').on('click', function (e) {
                if(oldinnerText == e.target.innerText) {
                    var id = e.target.offsetParent.id.replace('label-', '');

                    if(id != 'e-main-tab' && id != '') {
                        // document.getElementById(id).contentDocument.location.reload(true);
                    } else {
                        document.getElementById('ui-tabs-main').contentDocument.location.reload(true);
                    }
                }

                $(e.target).find('a').trigger('click');

                oldinnerText = e.target.innerText;
            });
        });
    </script>
</e:ui>