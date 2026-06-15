/**
 * @author YEON-MOO
 */
/**
 * Object Popup() 팝업 화면들을 호출 하는 class 입니다.
 *
 * @constructor
 * @extends Object
 */
var everPopup = function() {};

everPopup.openModalPopup = function(url, width, height, param){
    var _param = param;
    if(_param == null) {
        param = {};
    }
    param.popupFlag = true;
    var id = new EVF.ModalWindow(url, _param, width, height).open();

    return id;
};

everPopup.openWindowPopup = function(url, width, height, param, name, resizable){

    var _param = param;
    if(_param != null) {
        _param.detailView = param.detailView || false;
    }

    if(resizable === undefined) {
    	resizable = true;
    }
    if(resizable == null) {
    	resizable = true;
    }
    everPopup.createWindowPopup(url, width, height, _param, name, resizable);
};

everPopup.openWindowPopupParamIsStr = function(url, width, height, paramStr, name, resizable){

	var param = JSON.parse(everString.replaceAll(paramStr, "@@@", "\\n"));

	var _param = param;
	if(_param != null) {
		_param.detailView = param.detailView || false;
	}

	if(resizable === undefined) {
		resizable = true;
	}
	if(resizable == null) {
		resizable = true;
	}
	everPopup.createWindowPopup(url, width, height, _param, name, resizable);
};

everPopup.createWindowPopup = function(url, width, height, param, name, resizable) {

    if (name === undefined || $.trim(name) === '') {
        name = "newPopup" + String(Math.random()).substring(2,7);
    }
    var maxHeight = window.screen.availHeight - 70;
    if(maxHeight < height){
        height = maxHeight;
    }
    name = everString.replaceAll(name, ' ', '');

    var top = (maxHeight - height)/2;
    var left = (window.screen.availWidth - width)/2;

    if(param != null) {
        param.popupFlag = true;
    } else {
        param = { popupFlag:true };
    }

    var property = { "url" : url,
        "fullscreen" : false,
        "directories" : false,
        "location" : false,
        "menubar" : false,
        "status" : false,
        "toolbar" : false,
        "scrollbars" : true,
        "method" : 'post',
        "param" : param,
        "width" : width,
        "height" : height,
        "top" : top,
        "left" : left,
        "name" : name,
        "resizable" : resizable};
    var form = everPopup.makePostForm(property, param);
    var popWindow = window.open('', name, everPopup.argsToString(property));
    form.submit();
    popWindow.focus();
};

everPopup.makePostForm = function (property, param) {

    var postFormEl;

    postFormEl = document.createElement("form");
    postFormEl.setAttribute("method", "post");
    postFormEl.setAttribute("accept-charset", 'UTF-8');
    postFormEl.setAttribute('action', property.url);
    postFormEl.setAttribute('target', property.name);

    for (var p in param) {
    	var input = document.createElement('input');
        input.setAttribute('type', 'hidden');
        input.setAttribute('name', p);
        input.setAttribute('value', (param[p] !== null ? param[p] : ''));
        postFormEl.appendChild(input);
    }

    document.body.appendChild(postFormEl);
    return postFormEl;
};

everPopup.argsToString = function (property) {

    var rtn = [];
    rtn.push('top=' + property.top);
    rtn.push('left=' + property.left);

    rtn.push('fullscreen=' + property.fullscreen || 'false');
    rtn.push('height=' + property.height || '100%');
    rtn.push('width=' + property.width || '100%');

    rtn.push('directories=' + (property.directories == true ? 'yes' : 'no'));
    rtn.push('location=' + (property.location == true ? '1' : '0'));
    rtn.push('menubar=' + (property.menubar == true ? 'yes' : 'no'));
    rtn.push('resizable=' + (property.resizable == true ? 'yes' : 'no'));

    rtn.push('status=' + (property.status == true ? '1' : '0'));
    rtn.push('toolbar=' + (property.toolbar == true ? '1' : '0'));
    rtn.push('scrollbars=' + (property.scrollbars == true ? '1' : '0'));
    return rtn.join(',');
};

/**
 * @param param
 * {YOUR PARAMETER JSON TYPE}
 * @param commonId
 * POPUP ID
 */
everPopup.openCommonPopup = function(param, commonId, width, height){

    if(param == null) {
        param = {};
    }

    param.popupFlag = true;

    var baseUrl = '/common/popup/commonPopup';
    var store = new EVF.Store();
    store.setParameter("COMMON_ID", commonId);
    store.load(baseUrl + '/getDimension.so', function() {

        param.COMMON_ID = commonId;
        width = this.getParameter('width');
        height = this.getParameter('height');

        if(width === undefined || width === '' || width == null) {
        	width = 700;
        }

        if(height === undefined || height === '' || height == null) {
        	height = 600;
        }

        // everPopup.openWindowPopup(baseUrl + '/view.so', width, height, param, 'commonPopup');
        new EVF.ModalWindow(baseUrl+'/view.so', param, width, height).open();
    }, false);
};

everPopup.openCommonWindowPopup = function(param, commonId, width, height){

    if(param == null) {
        param = {};
    }

    param.popupFlag = true;

    var baseUrl = '/common/popup/commonPopup';
    var store = new EVF.Store();
    store.setParameter("COMMON_ID", commonId);
    store.load(baseUrl + '/getDimension.so', function() {

        param.COMMON_ID = commonId;
        width = this.getParameter('width');
        height = this.getParameter('height');

        if(width === undefined || width === '' || width == null) {
            width = 700;
        }

        if(height === undefined || height === '' || height == null) {
            height = 600;
        }

        everPopup.openWindowPopup(baseUrl+'/view.so', width, height, param)
    }, false);
};

// 다국어팝업
everPopup.openMultiLanguagePopup = function(param){
    var url = '/eversrm/manager/screen/MSRA0031/view.so';
    if(param.callBackFunction === undefined || $.trim(param.callBackFunction) === ''){
        param.callBackFunction = 'multiLanguagePopupCallBack';
    }
    new EVF.ModalWindow(url, param, 600, 400).open();
};

// 사용자별 컬럼 정의
everPopup.openUserColumnList = function(param) {
    var url = "/eversrm/manager/screen/MSRA0033/view.so";
    if(param === undefined){
        param = {};
    }
    everPopup.openWindowPopup(url, 650, 500, param, "UserColumnListPopup", true);
};

// 첨부파일
everPopup.fileAttachPopup = function (param) {

    if (EVF.isEmpty(param.bizType)) {
        return EVF.alert("bizType 이 존재하지 않습니다.\n확인하여 주시기 바랍니다.");
    }

    if (EVF.isEmpty(param.fileExtension)) {
        param.fileExtension = "*";
    }
    
    if (EVF.isEmpty(param.maxFileSize)) {
        param.maxFileSize = "100mb";
    }

    var url = '/common/popup/commonFileAttach/view.so';
    everPopup.openModalPopup(url, 600, (param.detailView == true ? 310 : 340), param);
};

// 첨부파일
everPopup.fileAttachWindowPopup = function (param) {

    if (EVF.isEmpty(param.bizType)) {
        return EVF.alert("bizType 이 존재하지 않습니다.\n확인하여 주시기 바랍니다.");
    }

    if (EVF.isEmpty(param.fileExtension)) {
        param.fileExtension = "*";
    }
    
    if (EVF.isEmpty(param.maxFileSize)) {
        param.maxFileSize = "100mb";
    }

    var url = '/common/popup/commonFileAttach/view.so';
    everPopup.openWindowPopup(url, 600, (param.detailView == true ? 310 : 340), param);
};

// 첨부파일
everPopup.readOnlyFileAttachPopup = function(param) {

    if (EVF.isEmpty(param.bizType)) {
        return EVF.alert("bizType 이 존재하지 않습니다.\n확인하여 주시기 바랍니다.");
    }

    if (EVF.isEmpty(param.fileExtension)) {
        param.fileExtension = "*";
    }
    
    if (EVF.isEmpty(param.maxFileSize)) {
        param.maxFileSize = "100mb";
    }

    var url = '/common/popup/commonFileAttach/view.so';
    everPopup.openModalPopup(url, 600,320, param);
};

// 코멘트 입력 창
everPopup.commonTextInput = function(param) {
    var url = '/common/popup/common_text_input/view.so';
    everPopup.openModalPopup(url, 500, 320, param);
};

// 코멘트 조회 창
everPopup.commonTextView = function(param) {
    var url = '/common/popup/common_text_view/view.so';
    everPopup.openModalPopup(url, 500, 320, param);
};

//입찰기간변경사유 코멘트 조회 창
everPopup.AppcommonTextInput = function(param) {
    var url = '/common/popup/common_text_input/view.so';
    everPopup.openModalPopup(url, 700, 320, param);
};

// 사용자조회
everPopup.userSearchPopup = function(callBackFunction, nRow, userNm, mode){
    if(userNm === undefined){
    	userNm = '';
    }
    if(nRow === undefined){
        nRow = -1;
    }
    if(mode === undefined){
        mode = '';
    }

    var popupUrl = "/eversrm/master/user/BADU_050/view.so?" ;
    var param = {
        callBackFunction:callBackFunction,
        nRow: nRow,
        userNm: userNm,
        mode: mode
    };
    new EVF.ModalWindow(popupUrl, param, 700, 600).open();

};

// 전자결재 - 결재요청 (일반)
everPopup.openApprovalRequestIPopup = function(param){
    var url = '/nhepro/CWOR/CWOR0050/view.so';
    //everPopup.openWindowPopup(url, 1170, 920, param, 'openApprovalRequestIPopup');
    everPopup.openModalPopup(url, 1170, 920, param, 'openApprovalRequestIPopup');
};

// 전자결재 - 결재요청 (전결)
everPopup.openApprovalRequestIIPopup = function(param){
    var url = '/eversrm/eApproval/eApprovalBox/BAPP_550/view.so';
    everPopup.openWindowPopup(url, 1100, 850, param, 'openApprovalRequestIIPopup');
};

// 전자결재 - 결재요청상세
everPopup.openApprovalOrRejectPopup = function(params) {
    var url = '/nhepro/CWOR/CWOR0011/view.so';
    everPopup.openWindowPopup(url, 1250, 1080, params, 'approvalOrRejectPopup');
};

// 전자결재 - 승인/반려 사유 (approvalType E:승인, R:반려)
everPopup.openApprovalRemarkPopup = function(param) {
    var url = '/nhepro/CWOR/CWOR0014/view.so';
    everPopup.openModalPopup(url, 700, 640, param);
};

// 전자결재 - 나의결재경로
everPopup.openMyApprovalPathPopup = function() {
    var url = '/nhepro/CWOR/CWOR0042/view.so';
    everPopup.openModalPopup(url, 570, 400, {}, 'myApprovalPathPopup');
};

// 전자결재 - 결재경로조회
everPopup.approvalPathSearchPopup = function(param){
    var url = '/nhepro/CWOR/CWOR0012/view.so';
    everPopup.openWindowPopup(url, 1000, 500, param);
};

// Screen ID Popup
everPopup.openScreenIdPopup = function(params) {
    var url = '/eversrm/system/screen/BSYS_030/view.so';
    everPopup.openWindowPopup(url, 1000, 500, params, 'BSYS_030',false);
};

// 메뉴템플릿코드
everPopup.openMenuTemplateGroupCodePopup = function(params) {
    var url = '/eversrm/manager/menu/MNUA0016/view.so';
    everPopup.openWindowPopup(url, 950, 450, params, 'menuTemplateGroupCd');
};

// 화면속성관리
everPopup.openMultiLanguageList = function(param) {
    var url = "/eversrm/manager/screen/MSRA0030/view.so";
//
    if(param === undefined){
        param = {};
    }
    everPopup.openWindowPopup(url, 1000, 700, param, "multiLangListPopup", true);
};

everPopup.openPopupByScreenId = function(screenId, width, height, param){

	if(param === undefined){param = {};}
    if(width === undefined){width = 800;}
    if(height === undefined){height = 600;}

    param.screenId = screenId;
    if(param.detailView === undefined) {
        param.detailView = true;
    }
    if(param.popupFlag === undefined) {
        param.popupFlag = true;
    }
    var store = new EVF.Store();
    store.setParameter('SCREEN_ID', screenId);
    store.load('/common/menu/getScreenInfo.so', function() {
        var url = this.getParameter('SCREEN_URL');
        if (url == 'NOTFOUNDSCRRENID') {
            return EVF.alert(url);
        }
        if(url.indexOf('?') === -1){
            url = url + '?';
        }
        if(screenId == 'CHARTVIEW') screenId='';

        if(screenId === 'commonFileAttach' || screenId === 'commonTextContents' || screenId === 'commonImgFileAttach') {
            new EVF.ModalWindow(url, param, width, height).open();
        } else {
        	everPopup.openWindowPopup(url, width, height, param, screenId, true);
        }
    }, false);
};

// 화면액션관리
everPopup.openScreenActionManagement = function(param) {
    var url = "/eversrm/manager/screen/MSRA0020/view.so";
    if(param === undefined){
        param = {};
    }
    everPopup.openWindowPopup(url, 1000, 700, param, "", true);
};

/**
 *  구매사품목코드 변경이력
 * @param param
 */
everPopup.im01_021open= function(param) {
    everPopup.openPopupByScreenId("IM01_021", 900, 500, param);
};


/**
 *  납품지역 일괄변경
 * @param param
 */
everPopup.im01_002open= function(param) {
    everPopup.openPopupByScreenId("IM01_002", 900, 300, param);
};


/**
 *  공급사정보 변경이력
 * @param param
 */
everPopup.bs03_007open= function(param) {
    everPopup.openPopupByScreenId("BS03_007", 900, 400, param);
};


/**
 *  공급사 평가등록
 * @param param
 */
everPopup.bs03_008open= function(param) {
    everPopup.openPopupByScreenId("BS03_008", 950, 950, param);
};


/**
 *  품목상세(운영사)
 * @param param
 */
everPopup.oitr0022_open= function(param) {
    everPopup.openPopupByScreenId("OITR0022", 1150, 850, param);
};

everPopup.oita0024_open= function(param) {
    everPopup.openPopupByScreenId("OITA0024", 1150, 663, param);
};

/**
 *  품목_속성팝업
 * @param param
 */
everPopup.citr0047_open= function(param) {
    var url = '/nhepro/CITI/CITR0047/view.so';
    everPopup.openModalPopup(url, 520, 450, param);
};

everPopup.oita0025_open= function(param) {
    var url = '/nhepro/OITR/OITA0025/view.so';
    everPopup.openModalPopup(url, 520, 450, param);
};


/**
 *  품목계약정보_납품지역
 * @param param
 */
everPopup.im03_012open= function(param) {
    var url = '/evermp/IM03/IM0304/IM03_012/view.so';
    everPopup.openModalPopup(url, 650, 150, param);
};


/**
 *  단가적용대상
 * @param param
 */
everPopup.im03_013open= function(param) {
    everPopup.openPopupByScreenId("IM03_013", 800, 450, param);
};


/**
 *  품목상세_view화면
 * @param param
 */
everPopup.im03_014open= function(param) {
    everPopup.openPopupByScreenId("IM03_014", 1000, 810, param);
};


/**
 *  품목별판가관리 History 상세
 * @param param
 */
everPopup.uinfoHistory= function(param) {
    everPopup.openPopupByScreenId("IM02_013", 900, 350, param);
};

/**
 *  독점현황 상세 팝업
 * @param param
 */
everPopup.soitView= function(param) {
    everPopup.openPopupByScreenId("IM01_071", 850, 350, param);
};

/**
 *  이미지상세보기 (view)
 * @param param
 */
everPopup.imgReadOnlyView= function(param) {
    everPopup.openPopupByScreenId("IM01_072", 500, 500, param);
};

/**
 *  sendbill 사용자 상세 팝업
 * @param param
 */
everPopup.sendBillUser= function(param) {
    everPopup.openPopupByScreenId("TX02_010", 800, 450, param);
};

/**
 *  수기견적상세 팝업
 * @param param
 */
everPopup.DirectEstimate= function(param) {
    everPopup.openPopupByScreenId("IM01_073", 1100, 650, param);
};

/**
 * 발주서 출력
 */
everPopup.printPoReport = function(po_num) {
    var param = {
        poNum: po_num,
        'resizable': true,
        'scrollbars': true,
        'menubar' : true,
        'toolbar' : true
    };
    everPopup.openPopupByScreenId('poReport', 1000, 700, param);
};

/**
 * 거래명세서 출력
 */
everPopup.printInvoice = function(param) {
    everPopup.openPopupByScreenId('BPOI_010_Report', 1000, 700, param);
};

/**
 * Item Catalog Popup, 품목검색
 * @param param
 * @Author : St-Ones
 */
everPopup.openItemCatalogPopup = function(param) {
    var url = "/eversrm/master/catalog/BPR_041/view.so";
    if(param.callBackFunction === undefined || $.trim(param.callBackFunction) === ''){
        param.callBackFunction = 'closePopup';
    }
    param.SCREEN_ID = 'BPR_041';
    everPopup.openWindowPopup(url, 1000, 700, param, 'itemCatalogPopup');
};

/**
 * Sup Management Popup, 협력사 등록/수정
 * @param param
 * @Author : St-Ones
 */
everPopup.openSupManagementPopup = function(params) {
    var url = '/eversrm/master/vendor/BBV_010/view.so?SCREEN_ID=BBV_010';
    if (params === undefined || params.VENDOR_CD === undefined || params.VENDOR_CD === "") return;
    if (params.detailView === undefined){
        params.detailView = true;
    }
    everPopup.openWindowPopup(url, 1000, 750, params, 'vendorInfo');
};

/**
 * RFX detail information popup, 견적/입찰요청
 * @param gateCd, rfxNum, rfxCnt, rfxType
 * Name : Su
 */
everPopup.openRfxDetailInformation = function(param) {
    var url = '/eversrm/solicit/solicitRequestReg/BSOX_010/view.so';
    param.detailView = true;
    everPopup.openWindowPopup(url, 1000, 800, param, '');
};

/**
 * Parameter : [flag, qtaNum, qtaSq, detailView, callBackFunction]
 * @Author : St-Ones
 */
everPopup.openCostItemNeed = function(param) {
    var Turl = param.url;
    if(param.callBackFunction === undefined || $.trim(param.callBackFunction) === ''){
        param.callBackFunction = 'setCostItemNeed';
    }
    everPopup.openWindowPopup(Turl, 1000, 720, param, 'setCostItemNeed');
};

/**
 * item detail information, 품목 상세정보
 *@param params
 *
 *St-Ones
 */
everPopup.openItemDetailInformation = function(param){
    var url = "/eversrm/master/item/BBM_040/view.so";
    if(param === undefined) {
        return;
    } else {
        if (param.ITEM_CD === undefined || param.ITEM_CD === "") return;
        param.onClose = 'closePopup';
    }
    if (param.detailView === undefined){
        param.detailView = true;
    }
    everPopup.openPopupByScreenId("CITR0041", 1150, 663, param);
//    everPopup.openWindowPopup(url, 1000, 700, param, "");
};

/**
 * @Task Pr Request Detail Infomation, 구매요청서작성
 * @param PR_NUM
 * @Author: jin
 */
everPopup.openPRDetailInformation = function(prNum){
    var param = {
        prNum:prNum,
        popupFlag : true,
        detailView: true
    };

    if (param.prNum === null || param.prNum === '') return;
    var url = "/eversrm/purchase/prMgt/prRequestReg/BPRM_010/view.so";
    everPopup.openWindowPopup(url, 1000, 750, param, "prRegistration", true);
};

/**
 * openPoDetailInformation, 발주 상세정보
 *@param params
 *
 * james
 */
everPopup.openPoDetailInformation = function(param){
    var url = "/eversrm/po/poMgt/poRegistration/BPOM_020/view.so";
    if(param.detailView === undefined){
        param.detailView = true;
    }
    everPopup.openWindowPopup(url, 1000, 700, param, "PoDetailInformation");
};

/**
 * Open eContract Change Popup
 * @param params
 * @Name : Su
 */
everPopup.openContractChangeInformation = function(params) {
	var url = params.url;
    if(params.callBackFunction === undefined || $.trim(params.callBackFunction) === ''){
        params.callBackFunction = 'alert';
    }
    if(params.contractEditable === undefined || $.trim(params.contractEditable) === ''){
        params.contractEditable = false;
    }
    everPopup.openWindowPopup(url, 1200, 900, params, 'openContractChangeInformation');
};

/**
 * 주소 팝업 호출
 *@param url
 *@param param
 *
 * james
 */
everPopup.jusoPop= function(url, param) {
    //document.domain = window.location.hostname;
    //window.name = "jusoPop";
    var pop = window.open(url + "?" + $.param(param),"pop","width=570,height=420, scrollbars=yes, resizable=yes");
};

//입찰보증취소사유
everPopup.openBidGuarRemarkPopup = function(param) {
    var url = '/nhepro/SBDR/SBDI0014/view.so';
    everPopup.openModalPopup(url, 500, 320, param);
};