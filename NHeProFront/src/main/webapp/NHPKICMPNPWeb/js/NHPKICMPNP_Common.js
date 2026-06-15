/**
 * Web Publishing Common Source
 * NHPKICMPNP 메인 페이지, 폐기 페이지, 설치 페이지 CSS 관련 스크립트.
 */
$(document).ready(function () {
  "use strict";
  $("#version").html("v" + NHPKICMPNP_VERSION);
  $(".placeholder").autoClear();
  //var kcbSeq = document.getElementById('kcbSeq').value;
});

/*tab*/
$(function () {
  $("#tabs").tabs();
  $(".ML_NH_tab_wrap").find("#tabs").tabs("option", "active", 1); // 0 : 개인용  , 1: 법인용
  
  // 개인용 disabled처리 - 210608 팀장님 요청
  $("a[href='#tabs-1']").hide();
  $("li[aria-labelledby='ML_NH_ui-id-2']").width('739px');
});

/*enter*/
var enterCheck = false;

function enterEvent(evt, type) {
  var keyCode = evt.which ? evt.which : event.keyCode;
  if (keyCode === 13 && enterCheck === false) {
    if (type === false) {
      $("#issueCert_false").click();
      entervalueTrue();
      return false;
    } else {
      $("#issueCert_true").click();
      entervalueTrue();
      return false;
    }
  }
}

function entervalueFalse() {
  enterCheck = false;
}

function entervalueTrue() {
  enterCheck = true;
}

/*alert popup*/
$(function () {
  "use strict";
  var appendthis = "<div class='modal-overlay js-modal-close'></div>";
  $("a[data-modal-id]").click(function (e) {
    e.preventDefault();
    $("#popup").append(appendthis);
    $(".modal-overlay").fadeTo(500, 0.7);
    //$(".js-modalbox").fadeIn(500);
    var modalBox = $(this).attr("data-modal-id");
    $("#" + modalBox).fadeIn($(this).data());
  });
  $(".js-modal-close, .modal-overlay").click(function () {
    $(".modal-box, .modal-overlay").fadeOut(500, function () {
      $(".modal-overlay").remove();
    });
  });
  $("#popup").resize(function () {
    $(".modal-box").css({
      top: ($("#popup").height() - $(".modal-box").outerHeight()) / 2,
      left: ($("#popup").width() - $(".modal-box").outerWidth()) / 2,
    });
  });
  $("#popup").resize();
});

////////////////////////////////////////////////////////////////////////////////
/**
 * 삭제페이지 초기정보
 */
function delInitialization() {
  getDelUserInfo();
}

/**
 * Check NHPKICMPNP Plugin Status & Version
 * 클라이언트 플러그인 버전 및 상태 체크 스크립트.
 */
function initialization() {
  console.log("KCBSEQ : " + kcbSeq);
  /*
	if ( kcbSeq == null || kcbSeq == ''){
		alert("본인인증이 필요합니다.");
    	window.location.replace(WELCOME_URL);
	}
	*/
  getUserInfo();
  spinner = new Spinner(opts).spin();
  document.body.appendChild(spinner.el);
  checkPluginStatus();
}

var RetryCount = 0;
var MaxRetryCount = 3;

// 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 체크 로직 추가)	
var userNm;
var cellNum; 

getUserInfo = function () {
  console.log("getUserInfo START!!");
  $.ajax({
    url: NHPKICMPNP_WEB_URL + "/certapi/getUserInfo.so",
    dataType: "json",
    timeout: 5000,
    cache: false,
    success: function (response) {
      console.log("success => " + JSON.stringify(response));
      userId = response.userId;
      companyNm = response.companyNm;

      // 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 체크 로직 추가)	
      userNm = response.userNm;
      cellNum = response.cellNum;
    },
    error: function (response) {
      alert("로그인이 필요합니다.");
      window.location.replace(WELCOME_URL);
    },
  });
};

getDelUserInfo = function () {
  console.log("getUserInfo START!!");
  $.ajax({
    url: NHPKICMPNP_WEB_URL + "/certapi/getUserInfo.so",
    dataType: "json",
    timeout: 5000,
    cache: false,
    success: function (response) {
      console.log("success => " + response);
      userId = response.userId;
      companyNm = response.companyNm;

      getCertDelInfo();
    },
    error: function (response) {
      alert("로그인이 필요합니다.");
      window.location.replace(WELCOME_URL);
    },
  });
};

getCertDelInfo = function () {
  console.log("getCertDelInfo START!!" + userId);
  $.ajax({
    contentType: "application/json; charset=UTF-8",
    url: NHPKICMPNP_WEB_URL + "/certapi/getCertDelInfo.so",
    dataType: "json",
    method: "POST",
    data: JSON.stringify({
      mpcId: userId,
    }),
    timeout: 5000,
    cache: false,
    success: function (response) {
      console.log("success => ");
      var result = response;
      var str = "<TR>";
      $.each(result, function (i) {
        str +=
          "<TD>" +
          result[i].NUM +
          "</TD><TD>" +
          result[i].CERT_CN +
          "</TD><TD>" +
          result[i].CERT_OU +
          "</TD><TD>" +
          result[i].IS_CORPORATION +
          "</TD><TD>" +
          result[i].CERT_STATUS +
          "</TD><TD>" +
          result[i].CERT_DATE +
          '</TD><TD style="display:none;">' +
          result[i].BCID +
          "</TD></TR>";
      });
      $("#deletetbl").append(str);
    },
    error: function (response) {
      console.log("error => ");
      var str =
        '<TR><TD colspan="6">발급한 인증서가 없습니다. 인증서를 발급하십시오.</TD></TR>';
    },
  });
};

checkPluginStatus = function () {
  $.ajax({
    url: NHPKICMPNP.localURL + "/test.html",
    dataType: "jsonp",
    timeout: 500, // TODO 3초에서 0.5초로 변경
    cache: false,
    success: function (data) {
    //  console.log("success => " + data);
      RetryCount = 0;
      if (data === "OK") {
        checkPluginVersion();
      }
    },
    error: function (data) {
      console.log("error => " + data.statusText);
      if (RetryCount >= MaxRetryCount) {
        spinner.stop();
        alert(
          "인증서 발급을 위한 프로그램 설치페이지로 이동합니다. 설치 후 페이지를 새로고침 해주십시요."
        );
        location.href = "NHPKICMPNP_Setup.html";
        return;
      }
      RetryCount++;
      sendURLScheme();
      setTimeout(checkPluginStatus, 500);
    },
  });
};

checkPluginVersion = function () {
  $.ajax({
    url: NHPKICMPNP.localURL + "/check_version.html",
    dataType: "jsonp",
    timeout: 500,
    success: function (data) {
     // console.log("success => " + data);
      spinner.stop();
      if (data !== NHPKICMPNP.pluginVer) {
        alert(
          "CMP 프로그램의 버전이 맞지 않아 프로그램 설치페이지로 이동합니다."
        );
        window.location.replace(SETUP_EXE_URL);
      } else {
        // alert("WEB Config Ver : "+NHPKICMPNP.pluginVer+"\nClient Ver : "+data);
      }
    },
    error: function (data) {
      console.log("error => Fail to version check " + data);
    },
  });
};

sendURLScheme = function () {
  var brow = getBrowser();

  if (brow.indexOf("MSIE 8") > -1) {
    var popup = window.open(
      "./NHPKICMPNP_call.html",
      "NHPKICMPNP",
      "width=11,height=11,left=5000,top=5000,resizable=no,toolbar=no,location=no,status=no"
    );
    setTimeout(function () {
      popup.close();
    }, 1000);
  } else if (brow.indexOf("MSIE 7") > -1) {
    var popup = window.open(
      "./NHPKICMPNP_call.html",
      "NHPKICMPNP",
      "width=11,height=11,left=5000,top=5000,resizable=no,toolbar=no,location=no,status=no"
    );
    setTimeout(function () {
      popup.close();
    }, 1000);
  } else if (brow.indexOf("MSIE 9") > -1) {
    var popup = window.open(
      "./NHPKICMPNP_call.html",
      "NHPKICMPNP",
      "width=11,height=11,left=5000,top=5000,resizable=no,toolbar=no,location=no,status=no"
    );
    setTimeout(function () {
      popup.close();
    }, 1000);
  } else if (brow.indexOf("MSIE") > -1 || brow.indexOf("Firefox") > -1) {
    var popup = window.open(
      NHPKICMPNP.pluginURL,
      "NHPKICMPNP",
      "width=11,height=11,left=5000,top=5000,resizable=no,toolbar=no,location=no,status=no"
    );
    setTimeout(function () {
      popup.close();
    }, 1000);
  } else if (brow.indexOf("Chrome") > -1) {
    window.document.getElementById("NHPKICMPNPIframe").src =
      NHPKICMPNP.pluginURL;
  } else if (brow.indexOf("Safari") > -1) {
    window.document.getElementById("NHPKICMPNPIframe").src =
      NHPKICMPNP.pluginURL;
  } else {
    window.document.getElementById("NHPKICMPNPIframe").src =
      NHPKICMPNP.pluginURL;
  }
};

getBrowser = function () {
  var browser = "";

  var ua = navigator.userAgent,
    tem;
  var ualow = ua.toLowerCase();

  if (ualow.indexOf("edge") > -1) {
    browser = "Edge" + ualow.substr(ualow.indexOf("edge") + 4, 3);
    browser = browser.replace("/", " ");
    return browser;
  } else {
    M =
      ua.match(
        /(OPR|edge|opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i
      ) || [];
    if (/trident/i.test(M[1])) {
      tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
      browser = "IE " + (tem[1] || "");
    }
    if (M[1] === "Chrome") {
      tem = ua.match(/\bOPR\/(\d+)/);
      if (tem != null) return (browser = "Opera " + tem[1]);
    }
    M = M[2] ? [M[1], M[2]] : [navigator.appName, navigator.appVersion, "-?"];
    if ((tem = ua.match(/version\/(\d+)/i)) != null) M.splice(1, 1, tem[1]);
    browser = M.join(" ");
    return browser;
  }
};

afterInstalled = function () {
  $.ajax({
    url: NHPKICMPNP.localURL + "/test.html",
    dataType: "jsonp",
    timeout: 500,
    cache: false,
    success: function (data) {
      console.log("success => " + data);
      RetryCount = 0;
      if (data === "OK") {
        location.href = "NHPKICMPNP_Main.html";
      }
    },
    error: function (data) {
      console.log("error => " + data.statusText);
      if (RetryCount >= MaxRetryCount) {
        return;
      }
      RetryCount++;
      sendURLScheme();
      setTimeout(afterInstalled, 500);
    },
  });
};

////////////////////////////////////////////////////////////////////////////////
/**
 * 클라이언트 프로그램 동작 종료요청 스크립트
 */
// try to stop plugin
function unload() {
  unloadPlugin();
}

unloadPlugin = function () {
  $.ajax({
    url: NHPKICMPNP.localURL + "/run.html",
    dataType: "jsonp",
    data: "exit",
  });
};
//////////////////////////////////////////////////////////////////////////////////
/**
 * WEB -> Client 호출 스크립트.
 */
/* 인증서 발급종류 디폴트 값 */
var isCorporation = true;

/* 인증서 종류 선택 */
function selCorporation() {
  isCorporation = true;
}

function selUser() {
  isCorporation = false;
}

var kcbData;
var kcbResult = "";
function smsUserCheck() {
  block_screen();
  // 핸드폰 인증(KCB)
  window.open("", "auth_popup", "width=430,height=640,scrollbar=yes");
  var form1 = document.form1;
  form1.target = "auth_popup";
  form1.submit();
}

function kcbCallbackFunction(data) {
  kcbData = data;
  
  // 2021/03/11 본인확인 추가개발 부분 (사용자 이름, 전화번호 체크 로직 추가)	
  if (data.RSLT_CD == "B000" && kcbData.RSLT_NAME == userNm && kcbData.TEL_NO.replace(/\-/g,'') == cellNum.replace(/\-/g,'')) {

    kcbResult = kcbData.RSLT_CD;
    $("#popup_psn").show();
    document.getElementById("kcbSeq").value = kcbData.DI;
    initUserInfo();

  } else if (data.RSLT_CD == "B000") {

    alert("로그인 정보와 본인인증 정보가 다릅니다.\n확인하여 주시기 바랍니다.");
    unblock_screen();
    return;

  } else {

    alert("본인인증 정보가 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
    unblock_screen();
    return;

  }
}

function closeModal() {
  $("#popup_psn").block();
  unblock_screen();
}

/* 개인용/법인용 인증서 발급창 취소 및 닫기 후 사용자 정보 입력값 초기화 */
function initUserInfo() {
  document.getElementById("user_name").value = ""; // 개인용(사용자 이름)
  document.getElementById("corporation_name").value = companyNm; // 법인용(사업자 명)
  document.getElementById("corporation_num").value = ""; // 법인용(사업자 등록번호)
  enterCheck = 0;
}

/* 인증서 발급 요청시 사용자 입력값의 정규식을 확인 후 인증서 발급을 진행한다. */
function issueCertReq() {
  if (isCorporation === false) {
    if (kcbResult !== "B000") {
      alert("본인인증 정보가 일치하지 않습니다.\n확인하여 주시기 바랍니다.");
      $("#issueCertCancel_false").click();
      return;
    }
  }
  if (enterCheck === 0) {
    /* 1. 인증서 발급시 필수 입력값 확인 */
    var userName = document.getElementById("user_name").value.trim();
    var corporationName = document
      .getElementById("corporation_name")
      .value.trim();
    var corporationNum = document
      .getElementById("corporation_num")
      .value.trim();

    /* 2. 인증서 발급시 필수 입력값 빈값 확인 */
    if (isEmpty(userName) === true && isCorporation === false) {
      alert(MSG_WARNING_REQ_USER_INFO);
      initUserInfo();
      return;
    } else if (
      (isEmpty(corporationName) === true || isEmpty(corporationNum) === true) &&
      isCorporation === true
    ) {
      alert(MSG_WARNING_REQ_CORPORATION_INFO);
      initUserInfo();
      return;
    }

    /* 3. 입력값 정규식 확인 */
    if (isCorporation === false) {
      if (langCheck("KO", userName) === -1) {
        initUserInfo();
        return;
      }
    } else {
      if (
        langCheck("ALL", corporationName) === -1 ||
        langCheck("NUM", corporationNum) === -1
      ) {
        initUserInfo();
        return;
      }
    }

    /* 4. 인증서 발급 요청 */
    if (isCorporation === true) {
      // 사업자 번호 체크 후 인증서 발급 요청
      checkCompanyCd();
    } else {
      issueCert();
      entervalueTrue();
    }
  }
}

function checkCompanyCd() {
  var corporationNum = document.getElementById("corporation_num").value.trim();
  var data = JSON.stringify({ companyCd: corporationNum, mpcId: userId });
  $.ajax({
    url: NHPKICMPNP_WEB_URL + "/certapi/checkCompanyCd.so",
    contentType: "application/json; charset=UTF-8",
    data: data,
    method: "POST",
    dataType: "json",
    success: function (data) {
      if (data.check === "false") {
        alert("사업자번호가 불일치합니다.\n사업자번호를 확인해주세요.");
        return;
      }

      if (data.superFlag === "false") {
        alert("법인 사설인증서 발급권한이 없습니다.");
        return;
      }

      issueCert();
    },
    error: function (data) {
      console.log("error => " + data.message);
    },
  });
}

/* 인증서 내보내기/가져오기 요청시 다이얼로그창 오픈 */
function beforeExportImportReq() {
  $("#exportAndImport").trigger("click");
}

/* 인증서 발급 요청 */
issueCert = function () {
  NHPKICMPNP.callFunction_v2("certissue", null);
};

/* 인증서 보기/검증 요청 */
viewCert = function () {
  NHPKICMPNP.callFunction_v2("viewcert", null);
};

/* 인증서 저장매체변경 요청 */
copyCert = function () {
  NHPKICMPNP.callFunction("copycert", null);
};

/* 인증서 삭제 요청 */
deleteCert = function () {
  NHPKICMPNP.callFunction("deletecert", null);
};

/* 인증서 비밀번호 변경 요청 */
changeCertPasswd = function () {
  NHPKICMPNP.callFunction("changecertpasswd", null);
};

/* 인증서 내보내기 요청 */
exportCert = function () {
  NHPKICMPNP.callFunction("exportcert", null);
};

/* 인증서 가져오기 요청 */
importCert = function () {
  NHPKICMPNP.callFunction("importcert", null);
};

function skm_LockScreen(str) {
  var lock = document.getElementById("skm_LockPane");
  if (lock) lock.className = "LockOn";
  lock.innerHTML = str;
}

function skm_LockOffScreen() {
  var lock = document.getElementById("skm_LockPane");
  if (lock) lock.className = "LockOff";
  lock.innerHTML = "";
}

function block_screen(sender, args) {
  skm_LockScreen("");
}

function unblock_screen(sender, args) {
  skm_LockOffScreen();
}

NHPKICMPNP.init = function () {
  NHPKICMPNP.args = {
    caip: NHPKICMPNP.caip,
    caport: NHPKICMPNP.caport,
    reqURI: NHPKICMPNP.reqURI,
    certUseKind: NHPKICMPNP.certUseKind,
  };
};

NHPKICMPNP.callFunction = function (func, params, callback) {
  NHPKICMPNP.init();
  block_screen();

  if (isCorporation === false) {
    var userName = document.getElementById("user_name").value.trim();

    NHPKICMPNP.args.isCorporation = "false";
    NHPKICMPNP.args.oid = certTypeP;
    NHPKICMPNP.args.userInfo = Base64.encode(userName);
    /*
     * MEMO 2020.04.22 고객사측 신원확인 기능 불필요 통보확인
     * MEMO 2020.05.15 인증서 발급요청문(CSR) 발급을 위한 임의의 IDN값(13자리) 사용
     */
    NHPKICMPNP.args.strIDN = "1234567890123";
  } else if (isCorporation === true) {
    var corporationName = document
      .getElementById("corporation_name")
      .value.trim();
    var corporationNum = document
      .getElementById("corporation_num")
      .value.trim();

    NHPKICMPNP.args.isCorporation = "true";
    NHPKICMPNP.args.oid = certTypeC;
    NHPKICMPNP.args.userInfo = Base64.encode(corporationName);
    NHPKICMPNP.args.strIDN = corporationNum;
  }
  // 인증서 관리업무(인증서 저장매체변경,삭제, 비밀번호 변경 등) 제대로 안뜨는 부분 해결 - 21.04.09
  //NHPKICMPNP.args.mpcId = kcbData.DI; // Mobile Phone Confirm ID

  if (isEmpty(params)) {
    NHPKICMPNP.args.func = func;
  } else {
    NHPKICMPNP.args.func = func + encodeURIComponent("##" + params);
  }

  var data = JSON.stringify(NHPKICMPNP.args);
  var url = NHPKICMPNP.localURL + "/run.html";
  $.ajax({
    url: url,
    method: "POST",
    dataType: "jsonp",
    data: data,
    success: function (data) {
      if (
        data.RespMsg.indexOf("This certificate has already been revoked") === 64
      ) {
        data.RespMsg = "Error Code : (9997)이미 폐기된 인증서입니다.";
      }
      if (isEmpty(data)) {
        alert("Invalid response received : " + data);
        unblock_screen();
      } else {
        showAlertModal(func, data);
      }
      unblock_screen();
    },
    error: function (data) {
      showAlertModal(func, data);
      unblock_screen();
    },
  });
};

showAlertModal = function (func, data) {
  switch (func) {
    case "certissue":
      document.getElementById("modalSubName").innerHTML = "인증서 발급 결과";
      break;
    case "viewcert":
      document.getElementById("modalSubName").innerHTML =
        "인증서 보기/검증 결과";
      break;
    case "copycert":
      document.getElementById("modalSubName").innerHTML =
        "인증서 저장매체 변경 결과";
      break;
    case "deletecert":
      document.getElementById("modalSubName").innerHTML = "인증서 삭제 결과";
      break;
    case "changecertpasswd":
      document.getElementById("modalSubName").innerHTML =
        "인증서 비밀번호 변경 결과";
      break;
    case "exportcert":
      document.getElementById("modalSubName").innerHTML =
        "인증서 내보내기 결과";
      break;
    case "importcert":
      document.getElementById("modalSubName").innerHTML =
        "인증서 가져오기 결과";
      break;
  }

  if (data.RespMsg === undefined) {
    document.getElementById("modalContent").innerHTML = data;
  } else {
    document.getElementById("modalContent").innerHTML = data.RespMsg;
  }

  $("#callModal").trigger("click");
};

/* 빈값 확인 함수 */
var isEmpty = function (value) {
  return (
    value === "" ||
    value == null ||
    (typeof value == "object" && !Object.keys(value).length)
  );
};

/* 입력값 정규식 확인 */
var langCheck = function (type, value) {
  var check = "";
  switch (type) {
    case "KO":
      check = /[a-z0-9ㄱ-ㅎㅏ-ㅣ]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:"'\\]/g;
      if (value.length > 10) {
        alert(MSG_WARNING_USER_INFO_OUTOFLENGTH);
        return -1;
      }
      if (check.test(value)) {
        alert(MSG_WARNING_LANGCHECK_KO);
        return -1;
      }
      break;
    case "NUM":
      check = /[^0-9]/g;
      if (value.length !== 10 || check.test(value)) {
        alert(MSG_WARNING_LANGCHECK_NUM);
        return -1;
      }
      break;
    case "ALL":
      check = /[{}\[\]\/?.,;:|)*~`!^\-+<>@#$%&\\=('"]/gi;
      if (value.length > 200) {
        alert(MSG_WARNING_CORPORATION_INFO_OUTOFLENGTH);
        return -1;
      }
      if (check.test(value)) {
        alert(MSG_WARNING_LANGCHECK_ALL);
        return -1;
      }
      break;
  }
};

installPlugin = function () {
  window.location.replace(SETUP_EXE_URL);
  alert("플러그인 설치 완료 후 '새로고침'을 눌러주세요");
};
