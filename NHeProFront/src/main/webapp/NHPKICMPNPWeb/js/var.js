﻿/////////////////////////////////////////////////////////
// NHPKI Non Plugin CMP Client Toolkit Common Script v2.0.0.1
//==========================================================
//	Version 	||      Date 		||		Comment
// 2.0.0.1    		||  18 Aug 2020 	|| 	Initial Version
//==========================================================
/////////////////////////////////////////////////////////

// TODO To Delete 로그인 아이디 - 본인인증시 처리데이터
var mpcId = "TESTs";

// 법인용 인증서 발급시 session 값
var companyCd = "";
var superUser = "";
var superUserFlag = "";

var NHPKICMPNP_WEB_PROTOCOL = window.location.protocol;
var NHPKICMPNP_WEB_URL = NHPKICMPNP_WEB_PROTOCOL+"//"+window.location.host;
var NHPKICMPNP_WEB_IP = window.location.hostname;

//개발서버 - 443
//운영서버 - 10443
//개발환경 - 9092
var NHPKICMPNP_WEB_PORT = "10443";
var WELCOME_URL = NHPKICMPNP_WEB_PROTOCOL+"//"+window.location.host+"/welcome.so";
var WebPagePath = "/NHPKICMPNPWeb";

var NPCMP_TIMEOUT = 3;                  // Wait x seconds for NP CMP plugin to start
var client_url;
var root_url;
var rootDir = '/NHPKICMPNP';			// website root
var setupDir = '/NHPKICMPNPWeb/setup'; 			    // Setup directory
var homeDir = '';				    	// Full web URL
var NHPKICMPNP_VERSION = '2.0.0.1';
var SETUP_EXE_URL = window.location.protocol + "//" + location.host + setupDir + "/NHPKICMPNP_Setup_" + NHPKICMPNP_VERSION + ".exe"; 	// Full setup download path

root_url = window.location.protocol + "//" + location.host; 			// web server root
homeDir = root_url + rootDir;

client_url = "https://127.0.0.1:28880";	    // local web server
was_url = "https://127.0.0.1:8080/api/SampleUrl";

var PLUGIN_URL = "NHPKICMPNP://";                        		// Plugin URL

var certTypeP = "1.2.410.200057.2.2.1.1";   // 개인용
var certTypeC = "1.2.410.200057.2.2.1.2";   // 법인용

//배포되는 서버 정보에 따라 아래 사항 수정 필요
var NHPKICMPNP = {
    caip: NHPKICMPNP_WEB_IP,       		// 사설인증센터 WAS 중계 서버 IP (변경필요)
    caport: NHPKICMPNP_WEB_PORT,             // 사설인증센터 WAS 중계 서버 Port (변경필요)
    reqURI: "/certapi/connRest.so",   // 사설인증센터 WAS 중계 서버 URI
    certUseKind: "",            // 인증서발급종류 Default ""(빈문자열)
    localURL: client_url,
    pluginVer: NHPKICMPNP_VERSION,
    pluginURL: PLUGIN_URL
};

/* Warning Message Config */
var MSG_WARNING_LANGCHECK_KO = "인증서 발급에 필요한 사용자 명은 한글만 지원합니다";
var MSG_WARNING_LANGCHECK_NUM = "인증서 발급에 필요한 10자리 사업자등록번호를 입력하세요.";
var MSG_WARNING_LANGCHECK_ALL = "인증서 발급에 필요한 사업자 명은 특수문자를 사용할 수 없습니다.";

var MSG_WARNING_REQ_USER_INFO = "인증서 발급에 필요한 사용자 정보를 입력하세요";
var MSG_WARNING_REQ_CORPORATION_INFO = "인증서 발급에 필요한 사업자 정보를 모두 입력하세요";

var MSG_WARNING_USER_INFO_OUTOFLENGTH = "개인용 인증서 사용자명은 100자리 이하의 한글만 입력 가능합니다.";
var MSG_WARNING_CORPORATION_INFO_OUTOFLENGTH = "법인용 인증서 사업자명은 100자리 이하의 한글만 입력 가능합니다.";
var MSG_PLUGIN_VIEWCERT_SUCCESS = "인증서 검증이 완료되었습니다.";
var MSG_PLUGIN_VIEWCERT_ALREADY_REVOKED = "(9997) 이미 폐기된 인증서입니다.";


/* Spinner */
var spinner;
var opts = {
    lines: 10                // The number of lines to draw
    , length: 30             // The length of each line
    , width: 5               // The line thickness
    , radius: 30             // The radius of the inner circle
    , scale: 1               // Scales overall size of the spinner
    , corners: 1             // Corner roundness (0..1)
    , color: '#4169E1'       // #rgb or #rrggbb or array of colors
    , opacity: 0.25          // Opacity of the lines
    , rotate: 16             // The rotation offset
    , direction: 1           // 1: clockwise, -1: counterclockwise
    , speed: 2.0             // Rounds per second
    , trail: 30              // Afterglow percentage
    , fps: 20                // Frames per second when using setTimeout() as a fallback for CSS
    , zIndex: 2e9            // The z-index (defaults to 2000000000)
    , className: 'spinner'   // The CSS class to assign to the spinner
    , top: '51%'             // Top position relative to parent
    , left: '50%'            // Left position relative to parent
    , shadow: true           // Whether to render a shadow
    , hwaccel: false         // Whether to use hardware acceleration
    , position: 'absolute'   // Element positioning
};
