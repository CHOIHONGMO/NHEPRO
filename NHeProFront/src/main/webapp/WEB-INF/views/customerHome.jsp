<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="everDate" class="com.st_ones.common.util.clazz.EverDate" />
<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <script type="text/javascript" src="../../js/home.js"></script>
    <script type="text/javascript" src="/js/everuxf/lib/jquery.pnotify.min.js"></script>
	<script type="text/javascript" src="/js/ever-alarm.js"></script>
	<script type="text/javascript" src="/js/ever-dwr.js"></script>
	<link rel="stylesheet" href="/css/home.css">
	<link rel="stylesheet" href="/css/jquery.pnotify.default.css">
    <link rel="stylesheet" href="/resource/webfonts/fontawesome-free/css/all.min.css">


	<link rel="shortcut icon" href="/images/favicon.ico"/>
    <title>FIRSTePro - 고객사 ${ses.userNm}님 환영합니다.</title>

    <script>

        var tabs;
        var tabLimit = Number('${tabLimit}');

        $(window).resize(function(){
            // $('#chatRoom').css('top', $(window).height() - 360 );
        });

        $(document).ready(function() {
            $('#mainIframe', parent.parent.document).css('height', '100vh').css('width', '100%');

            var layout = EVF.Properties.layout;
            layout.west.minSize = 282;
            layout.west.maxSize = 282;
            // layout.west.resizable = false;
            layout.west.slidable = true;
            layout.west.closable = true;
            //layout.west.spacing_open = 0;
            //layout.west.spacing_closed = 0;
            $('#e-window-container-body').layout(layout);
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
                function (e) {
                    $(this).addClass('e-topmenu-hover');
                },
                function (e) {
                    $(this).removeClass('e-topmenu-hover');
                }
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

            // 고객사 ADMIN 체크
            if('${ses.mngYn}' != '1') {
                $('#AD').remove();
            }

            resizeComponent();

            // 채팅 관련 - nodejs 설치 필요(nodejs 폴더의 파일 설치)
            // chatStart();
        });
		
        // 2021.04.05 로그인 후 ID, PASSWORD가 동일한 경우 기존 휴대번호, 이메일 정보가 존재하지 않는 경우 개인정보 변경 팝업 오픈하는 경우에 추가
        function init() {
        	
        	var userId = '${ses.userId}';
        	
        	var store = new EVF.Store();
            store.setParameter("userId", userId);
            store.load('/passSameCheck.so', function () {
            	if(this.getResponseCode() == "180") {
            		// 전화번호, 휴대전화번호, E-Mail
                    var telNum = '${ses.telNum}';
                    var cellNum = '${ses.cellNum}';
                    var email = '${ses.email}';
                    var message = '';

                    message += '${ses.userNm} 님!\n';

                    if (telNum == '') {
                        //message += '전화번호\n';
                    }
                    if (cellNum == '') {
                        message += '휴대전화번호\n';
                    }
                    if (email == '') {
                        message += 'E-Mail\n';
                    }
                    message += '정보가 존재하지 않고 비밀번호 변경일이 180일 초과하였습니다. 비밀번호 설정이 필요합니다. 사용자 정보를 변경해 주십시오.';

                    if (cellNum == '' || email == '') { 
                        alert(message);
                        openUserInfo(this.getResponseCode());
                    } else {
                    	//alert('${ses.userNm} 님!\n비밀번호 변경일이 180일 초과하였습니다. 비밀번호를 변경하시기 바랍니다.');
                        openUserInfo(this.getResponseCode());
                    }
                    
                    <c:forEach var="noticePopup" items="${noticeListPopup}">
                        noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
                    </c:forEach>

                    initHome('${topMenu[0].MAIN_MODULE_TYPE}');
            	} else if (this.getResponseCode() == "1"){
            		var telNum = '${ses.telNum}';
                    var cellNum = '${ses.cellNum}';
                    var email = '${ses.email}';
                    var message = '';

                    message += '${ses.userNm} 님!\n';

                    if (telNum == '') {
                        //message += '전화번호\n';
                    }
                    if (cellNum == '') {
                        message += '휴대전화번호\n';
                    }
                    if (email == '') {
                        message += 'E-Mail\n';
                    }
                    message += '정보가 존재하지 않고 초기 비밀번호 설정이 필요합니다. 사용자 정보를 변경해 주십시오.';

                    if (cellNum == '' || email == '') { 
                        alert(message);
                        openUserInfo(this.getResponseCode());
                    } else {
                    	alert('${ses.userNm} 님!\n초기 비밀번호 설정이 필요합니다. 비밀번호를 변경하시기 바랍니다.');
                        openUserInfo(this.getResponseCode());
                    }
                    
                    <c:forEach var="noticePopup" items="${noticeListPopup}">
                        noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
                    </c:forEach>

                    initHome('${topMenu[0].MAIN_MODULE_TYPE}');
            	} else{
					// 전화번호, 휴대전화번호, E-Mail
		            var telNum = '${ses.telNum}';
		            var cellNum = '${ses.cellNum}';
		            var email = '${ses.email}';
		            var message = '';

		            message += '${ses.userNm} 님!\n';

		            if (telNum == '') {
		                //message += '전화번호\n';
		            }
		            if (cellNum == '') {
		                message += '휴대전화번호\n';
		            }
		            if (email == '') {
		                message += 'E-Mail\n';
		            }
		            message += '정보가 존재하지 않습니다. 사용자 정보를 변경해 주십시오.';

		            if (cellNum == '' || email == '') { <%-- telNum == '' --%>
		                alert(message);
		                openUserInfo();
		            }

		            <c:forEach var="noticePopup" items="${noticeListPopup}">
		                noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
		            </c:forEach>

		            initHome('${topMenu[0].MAIN_MODULE_TYPE}');
				}
            }, false);
            
            
        	// 전화번호, 휴대전화번호, E-Mail
            <%-- var telNum = '${ses.telNum}';
            var cellNum = '${ses.cellNum}';
            var email = '${ses.email}';
            var message = '';

            message += '${ses.userNm} 님!\n';

            if (telNum == '') {
                //message += '전화번호\n';
            }
            if (cellNum == '') {
                message += '휴대전화번호\n';
            }
            if (email == '') {
                message += 'E-Mail\n';
            }
            message += '정보가 존재하지 않습니다. 사용자 정보를 변경해 주십시오.';

            if (cellNum == '' || email == '') { telNum == ''
                EVF.alert(message);
                openUserInfo();
            }

            <c:forEach var="noticePopup" items="${noticeListPopup}">
                noticeCookieCheck('${noticePopup.NOTICE_NUM }', 'loginPopupNotice');
            </c:forEach>

            initHome('${topMenu[0].MAIN_MODULE_TYPE}'); --%>
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

        function openUserInfo(code) {
            var param = {};
            if ('${everSslUseFlag}'=='true') {
                window.open('${realDomainUrl}'+'/nhepro/CETR/CETR0010/view.so?popupFlag=true',"사용자정보", "width=700,height=620,scrollbars=yes,resizeable=no,left=150,top=150");
            } else {
            	// 2021.05.27 로그인 후 사용자 정보(전화번호 미등록, 비밀번호 180일 변경 등)를 변경해야 시스템 사용 가능하도록 변경
            	//var url = '/nhepro/CETR/CETR0010/view.so?popupFlag=true';
                //everPopup.openWindowPopup(url, 700, 460, null,'openUserInfo');
                
            	var url = "/nhepro/CETR/CETR0010/view.so";
                var param = {
                    modalYn: true,
                    popupFlag: true,
                    code: code
                };
                everPopup.openModalPopup(url, 700, 620, param);
                
            }
        }
        
        //2021.12.31 Home화면 My Info버튼 클릭시 개인정보 팝업은 닫기버튼 활성화를 위해 팝업오픈 함수 분리
        function openUserMyInfo(code){
        	var param = {};
            if ('${everSslUseFlag}'=='true') {
                window.open('${realDomainUrl}'+'/nhepro/CETR/CETR0010/view.so?popupFlag=true',"사용자정보", "width=700,height=620,scrollbars=yes,resizeable=no,left=150,top=150");
            } else {
            	var url = "/nhepro/CETR/CETR0010/view.so";
                var param = {
                    modalYn: true,
                    popupFlag: true,
                    infoFlag: true,
                    code: code
                };
                everPopup.openModalPopup(url, 700, 620, param);
                
            }
        }

        function openScreenToNewTab(id, text, value, e, data) {

            // 입고 권한 체크
            if (id == 'TM901684' || id == 'TM901687') {
                if('${ses.mngYn}' == '0' && '${ses.grFlag}' == '0') {
                    return EVF.alert("접근 권한이 없습니다.");
                }
            }

            // 정산 권한 체크
            if (id == 'TM901688' || id == 'TM901689') {
                if('${ses.mngYn}' == '0' && '${ses.financialFlag}' == '0') {
                    return EVF.alert("접근 권한이 없습니다.");
                }
            }

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
                <iframe id="ui-tabs-main" src="/eversrm/mypageCustomer/view.so" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" height="100%" src="" style="padding: 0; margin: 0; height: 100%; width: 100%;"></iframe>
                <%--
                <ul>
                    <li><a href="#ui-tabs-main" title="HOME">${homeName}</a></li>
                </ul>
                <iframe id="ui-tabs-main" src="${homeUrl}" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" height="100%" src="" style="padding: 0; margin: 0; height: 100%; width: 100%;"></iframe>
                --%>




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
                        <div id="e-btn-myinfo" class="e-session-btn-wrapper" onclick="openUserMyInfo();">
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
                if (e.target.offsetParent != null) {

                    var offsetParentId = e.target.offsetParent.id;
                    var templ_menu_cd = offsetParentId.substr(offsetParentId.indexOf("TM"), offsetParentId.length);

                    // 탭 메뉴를 선택 시 Screen Id 를 주입한다.
                    $.ajax({
                        url: "/eversrm/tabMainScreenId.so",
                        dataType: "json",
                        data: {
                            "TMPL_MENU_CD": templ_menu_cd
                        },
                        success: function (data) {
                        }
                    });

                    if (oldinnerText == e.target.innerText) {
                        var id = offsetParentId.replace('label-', '');

                        if (id != 'e-main-tab' && id != '') {
                            // document.getElementById(id).contentDocument.location.reload(true);
                        } else {
                            document.getElementById('ui-tabs-main').contentDocument.location.reload(true);
                        }
                    }

                    $(e.target).find('a').trigger('click');

                    oldinnerText = e.target.innerText;
                }
            });
        });
    </script>
</e:ui>