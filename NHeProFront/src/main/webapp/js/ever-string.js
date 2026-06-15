/**
 * Object everString() 일반적인 Util을 제공 합니다.
 * general Util
 *
 * @constructor
 * @extends Object
 */
var everString = function() {
};

everString.contains = function(str, it){
    return str.indexOf(it) != -1;
};
/**
 * replaceAll
 * @param str
 * @param src
 * @param target
 * @returns replaced String
 */
everString.replaceAll = function (str, src, target) {
    str = str.split(src).join(target);
    return str;
};

/**
 * right trim
 * @param str
 * @returns {String}
 */
everString.rTrim = function (str) {
    return str.replace(/^\s+/,'');
};

/**
 * left trim
 *
 * @param {String}
 *            str
 * @returns {String}
 */
everString.lTrim = function (str) {
    return str.replace(/\s+$/,'');
};

/**
 * lrTrim
 * @param str
 * @returns {String}
 */
everString.lrTrim = function (str) {
    return str.replace(/^\s+/,'').replace(/\s+$/,'');
};

/**
 * Determine whether the number string
 * @param num
 * @returns {Boolean}
 */
everString.isNumber = function (num) {
    var pattern = /^\d+$/;
    return pattern.test(num);
};

/**
 * trim left 0 character
 * @param str
 * @returns {String}
 */
everString.zero_LTrim = function (str) {
    return str.replace(/^0+/g, '');
};

/**
 * delete ch in str
 * @param str
 * @param ch
 * @returns replaced
 */
everString.deleteChar = function (str, ch) {
    return everString.replaceAll(str, ch, '');
};

/**
 * hsaSpace
 * @param str
 * @returns boolean
 */
everString.hsaSpace = function (str) {
    return /\s/g.test(str);
};


/**
 * isEmpty
 * @param str
 * @returns {Boolean}
 */
everString.isEmpty = function (str) {
    return str === undefined || str === null || str === '';
};

everString.isEmptyNum = function (str) {
    return str === undefined || str === null || str === '0' || str === 0;
};


everString.isNotEmpty = function (str) {
    return !everString.isEmpty(str);
};


/**
 * check include korean
 * @param str
 * @returns {Boolean}
 */
everString.hasKoreanChar = function (str) {
    return /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/.test(str);
};

/**
 * is tel number character
 * @param num
 * @returns {Boolean}
 */
everString.isTel = function (str) {
	if (str=='') return true;
	var regTel = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})[-][0-9]{3,4}[-][0-9]{4}$/;
	return regTel.test(str);
};

/**
 * isValidEmail
 * @param input
 * @returns regex
 *
 * everString.isValidEmail = function (input) {
 *     return /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/.test(input);
 * };
 */

/**
 * 2022-11-11 이메일 검증 정규식 변경
 * isValidEmail
 * @param input
 * @returns regex
 */
everString.isValidEmail = function (input) {
    return /^[a-zA-Z0-9]([-_\.]?[a-zA-Z0-9])*@[a-zA-Z0-9]([-_\.]?[a-zA-Z0-9])*\.[a-zA-Z0-9]{2,8}$/i.test(input);
};


/**
 * isValidHome
 * @param input
 */
everString.isValidHome = function (input) {
    return /^((\w|[\-\.])+).((\w|[\-\.])+)\.([A-Za-z]+)$/.test(input);
};

/**
 * isNumAndComma
 * @param str
 * @returns boolean
 */
everString.isNumAndComma = function (str) {
    return /^[\d|,]+$/.test(str);
};

/**
 * 아이디 생성 시, 아이디 자리수 확인
 * @param str
 * @returns {boolean}
 */
everString.isChkId = function (str) {
    return /^[A-Za-z0-9]{4,12}$/.test(str);
};

/**
 * 패스워드 % 입력불가
 * @param str
 * @returns {map}
 */
everString.getCheckPassWord = function (str) {
	var map = {
        success: true,
        msg: ""
    };
    
    if (str == '') return map;
    
    var reg_pwd = new Array();
	reg_pwd.push("%");
	for(var i=0; i < reg_pwd.length; i++){
		if(str.indexOf(reg_pwd[i])!= -1){
    		map = {
	            success: false,
	            msg: "비밀번호 입력 시 % 특수문자는 사용할 수 없습니다."
	        };

	        return map;
		}
	}
	
	return map;
};

/**
 * 패스워드 체크
 * @param str
 * @returns {map}
 */
everString.getChkPwd = function (str) {
    var map = {
        success: true,
        msg: ""
    };
    
    if (str == '') return map;
    console.log("str===> "+str);
    var SamePass_1 = 0;
    var SamePass_2 = 0;

    var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    var reg_pwd2 = /^.*(?=.{10,20})(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
    var reg_pwd3 = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[!@#$%^&+=]).*$/;
    var reg_pwd4 = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
    
    if(reg_pwd.test(str) || reg_pwd2.test(str)|| reg_pwd3.test(str)|| reg_pwd4.test(str)){
    	
    } else {
        map = {
            success: false,
            msg: "비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요."
        };

        return map;
    }
    
    if(str.length > 20){
        map = {
            success: false,
            msg: "비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자리\n또는 두가지 조합으로 10~20자리 입력해주세요."
        };
    }
    
    for(var i = 0; i < str.length; i++) {
        var chr_pass_0 = str.charAt(i);
        var chr_pass_1 = str.charAt(i+1);
        
        var SamePass_0 = 0;
        
        for(var j = i; j < str.length; j++) {
			if(chr_pass_0 == str.charAt(j)) {
				SamePass_0 = SamePass_0 + 1
			}
		}
        
        if(SamePass_0 > 2) {
            map = {
                success: false,
                msg: "동일문자를 3번 이상 사용할 수 없습니다."
            };
        }
        
        var chr_pass_2 = str.charAt(i+2);
        if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
            SamePass_1 = SamePass_1 + 1
        }
        if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
            SamePass_2 = SamePass_2 + 1
        }
        console.log("SamePass_0 ====> "+SamePass_0);
    }

    if(SamePass_1 > 1 || SamePass_2 > 1 ) {
        map = {
            success: false,
            msg: "연속된 문자열(123 또는 321, abc, cba 등)을 3자 이상 사용 할 수 없습니다."
        };
    }

    return map;
};


/**
 * 콤마 처리
 * @param str, 예시) 123, 1234, 1234 원, 1234.56 % 등등
 * @returns string
 */
everString.comma = function (str) {
    var val = str;
    var p;

    if(!this.isNumber(str)) {
        val = str.replace(/[^\d.]/g, "");

        if(/\./.test(val)) {
            var t = val.split(".");
            val = t[0];
            p = t[1];
        }
    }

    var ret;
    if(val.length > 3){
        var loop = Math.ceil(val.length / 3);
        var offset = val.length % 3;
        if((val.length % 3)==0){
            offset = 3;
        }
        ret = val.substring(0, offset);
        for(var i=1;i<loop;i++){
            ret += "," + val.substring(offset, offset+3);
            offset += 3;
        }
    } else {
        ret = val;
    }

    if(p == undefined) {
        ret += str.replace(/[\d.]/g, "");
    } else {
        ret += "." + p + str.replace(/[\d.]/g, "");
    }

    return ret;
};

/**
 * getMessage
 * @param msg
 * @param obj
 * @returns message
 */
everString.getMessage = function(msg, obj) {
    return msg.replace('@', obj);
};

everString.format = function() {
    var str = arguments[0];
    for (var i = 1; i < arguments.length; i++) {
        str = everString.replaceAll(str, '{' + String(i-1) + '}', arguments[i]);
    }
    return str;
};

/**
 * sortBy 			- sort an array of JSON
 * @param field 	: field to sort
 * @param reverse 	: true - revesed order; false - normal order
 * @param primer 	: function for comparison
 * @returns sortIndex
 */
everString.sortBy = function(field, reverse, primer){
    var _reverse = reverse ? reverse : false;
    var _key = function (x) {return primer ? primer(x[field]) : x[field]};
    return function (a,b) {
        var A = _key(a), B = _key(b);
        return ((A < B) ? -1 : (A > B) ? +1 : 0) * (_reverse ? -1 : 1);
    };
};

/*
 * left 기준으로 자릿수 채울 때 사용 ex) everString.leftPad(value,'0',2)
 * 앞자리 0으로 채움
 */
everString.leftPad = function(str, fillChar, length) {

    if (fillChar.length != 1) {
        alert('fillChar must be a single character');
        return "";
    }

    if (str.length > length)
        return str;

    var returnStr = "";
    var i;
    for (i = str.length; i < length; i++) {
        returnStr = returnStr + fillChar;
    }

    returnStr = returnStr + str;

    return returnStr;
};

/*
 * right 기준으로 자릿수 채울 때 사용 ex) everString.rightPad(value,'0',2)
 * 뒷자리 0으로 채움
 */
everString.rightPad = function(str, fillChar, length) {

    if (fillChar.length != 1) {
        alert('fillChar must be a single character');
        return "";
    }

    if (str.length > length)
        return str;

    var returnStr = str;
    var i;
    for (i = str.length; i < length; i++) {
        returnStr = returnStr + fillChar;
    }

    return returnStr;
};

everString.Injection = function(str) {
	var map = {
	        success: true,
	        msg: ""
	    };
	    
	if (str == '') return map;
	var stringValue = str;
	
	if (stringValue.toUpperCase().indexOf("JAVASCRIPT") != -1) {
        map = {
                success: false,
                msg: "JAVASCRIPT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("JSCRIPT") != -1) {
    	map = {
                success: false,
                msg: "JSCRIPT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
    	map = {
                success: false,
                msg: "VBSCRIPT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("SCRIPT") != -1) {
    	map = {
                success: false,
                msg: "SCRIPT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("IFRAME") != -1) {
    	map = {
                success: false,
                msg: "IFRAME는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("FRAME") != -1) {
    	map = {
                success: false,
                msg: "FRAME는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("EXPRESSION") != -1) {
    	map = {
                success: false,
                msg: "EXPRESSION는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ALERT") != -1) {
    	map = {
                success: false,
                msg: "ALERT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf(".OPEN") != -1) {
    	map = {
                success: false,
                msg: ".OPEN는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("DECALRE") != -1) {
    	map = {
                success: false,
                msg: "DECALRE는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("COLUMN_NAME") != -1) {
    	map = {
                success: false,
                msg: "COLUMN_NAME는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("TABLE_NAME") != -1) {
    	map = {
                success: false,
                msg: "TABLE_NAME는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("OPENROWSET") != -1) {
    	map = {
                success: false,
                msg: "OPENROWSET는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("SYSOBJECTS") != -1) {
    	map = {
                success: false,
                msg: "SYSOBJECTS는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("SYSCOLUMNS") != -1) {
    	map = {
                success: false,
                msg: "SYSCOLUMNS는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("&#") != -1) {
    	map = {
                success: false,
                msg: "&#는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("COOKIE") != -1) {
    	map = {
                success: false,
                msg: "COOKIE는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
    	map = {
                success: false,
                msg: "VBSCRIPT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("APPLET") != -1) {
    	map = {
                success: false,
                msg: "APPLET는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("OBJECT") != -1) {
    	map = {
                success: false,
                msg: "OBJECT는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("BGSOUND") != -1) {
    	map = {
                success: false,
                msg: "BGSOUND는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONBLUR") != -1) {
    	map = {
                success: false,
                msg: "ONBLUR는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONCHANGE") != -1) {
    	map = {
                success: false,
                msg: "ONCHANGE는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONCLICK") != -1) {
    	map = {
                success: false,
                msg: "ONCLICK는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONDBLCLICK") != -1) {
    	map = {
                success: false,
                msg: "ONDBLCLICK는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONERROR") != -1) {
    	map = {
                success: false,
                msg: "ONERROR는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONFOCUS") != -1) {
    	map = {
                success: false,
                msg: "ONFOCUS는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONLOAD") != -1) {
    	map = {
                success: false,
                msg: "ONLOAD는 금지어 입니다."
            };
    }
    if (stringValue.toUpperCase().indexOf("ONMOUSE") != -1) {
    	map = {
                success: false,
                msg: "ONMOUSE는 금지어 입니다."
            };
    }

    if (str.toUpperCase().indexOf("ONSCROLL") != -1) {
    	map = {
                success: false,
                msg: "ONSCROLL는 금지어 입니다."
            };
    }

    if (str.toUpperCase().indexOf("ONSUBMIT") != -1) {
    	map = {
                success: false,
                msg: "ONSUBMIT는 금지어 입니다."
            };
    }

    if (str.toUpperCase().indexOf("ONUNLOAD") != -1) {
    	map = {
                success: false,
                msg: "ONUNLOAD는 금지어 입니다."
            };
    }
    
    return map;
};


