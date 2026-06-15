/**
 * /** Object everDate() Date<br>
 * Date relate Util
 * 
 * @constructor
 * @extends Object
 */
var /**
	 * @author YeonMoo Lee(yeonmoo_lee@stones.com)
	 * 
	 */
everDate = function() {
};

/**
 * calculate Date
 * 
 * @param requestDate
 * @param calNum
 */
everDate.calculateDate = function(requestDate, type, calNum) {

	requestDate = everString.replaceAll(requestDate, "/", "");
	var ieVer = everDate.checkVersion();

	if(ieVer > 8) {

		var reqYear = parseInt(requestDate.substring(0, 4));
		var reqMonth = parseInt(requestDate.substring(4, 6)) - 1;
		var reqDay = parseInt(requestDate.substring(6, 8));

		var calDate = new Date(reqYear + (type === 'Y' ? calNum : 0),
							   reqMonth + (type === 'M' ? calNum : 0),
							   reqDay + + (type === 'D' ? calNum : 0));
	
		reqYear = "20" + (calDate.getYear() - 100);
		reqMonth = (calDate.getMonth()+1) < 10 ? "0"+(calDate.getMonth()+1) : (calDate.getMonth()+1);
		reqDay = calDate.getDate() < 10 ? "0"+calDate.getDate() : calDate.getDate();

	} else {
		
		var reqYear = parseInt(requestDate.substring(0, 4)) + (type === 'Y' ? calNum : 0);
		var reqMonth = parseInt(requestDate.substring(4, 6)) + (type === 'M' ? calNum : 0);
		var reqDay = parseInt(requestDate.substring(6, 8)) + (type === 'D' ? calNum : 0);

		var calDate = new Date(reqYear+"/"+(reqMonth < 10 ? ("0"+reqMonth) : reqMonth)+"/"+(reqDay));

		reqYear = calDate.getFullYear();
		reqMonth = (calDate.getMonth()+1) < 10 ? "0"+(calDate.getMonth()+1) : (calDate.getMonth()+1);
		reqDay = calDate.getDate() < 10 ? "0"+calDate.getDate() : calDate.getDate();
	}

	return reqYear+"/"+reqMonth+"/"+reqDay;
};

everDate.getInternetExplorerVersion = function() {
	
	var rv = -1;
	if (navigator.appName == 'Microsoft Internet Explorer') {
		var ua = navigator.userAgent;
		var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
		if (re.exec(ua) != null)
			rv = parseFloat(RegExp.$1);
	}
	return rv;
}; 

everDate.checkVersion = function() {
	return everDate.getInternetExplorerVersion();
};

everDate.parseIOS6801 = function(dateStringInRange) {
	
	var isoExp = /^\s*(\d{4})-(\d\d)-(\d\d)\s*$/,
	date = new Date(NaN), month,
	parts = isoExp.exec(dateStringInRange);
	
	if(parts == null && dateStringInRange.length == 8) {
		parts = [];
		parts.push(dateStringInRange);
		parts.push(dateStringInRange.substring(0, 4));
		parts.push(dateStringInRange.substring(4, 6));
		parts.push(dateStringInRange.substring(6, 8));
	}
	
	if(parts) {
		date.setFullYear(parts[1], month - 1, parts[3]);
        var month = parts[2];
		if(month != date.getMonth() + 1) {
			date.setTime(NaN);
		}
	}
	return date;
};

/**
 * diff with serverTime
 * 
 * @param requestDate
 * @param hour
 * @param minutes
 * @param sec
 * @param callbackFunction(status,
 *            msg) status - 1: later, 0: same, -1: earlier
 * @param isGrid
 */
everDate.diffWithServerTime = function(requestDate, hour, minutes, sec, callbackFunction, isGrid) {

	var store = new EVF.Store();
	store.setParameter('requestDate', requestDate);
	store.setParameter('hour', hour);
	store.setParameter('minutes', minutes);
	store.setParameter('sec', sec);
    store.setParameter('isGrid', isGrid);
    
	var url = '/common/util/web/everDateController/diffWithServerTime.so';

	store.load(url, function() {
		callbackFunction(this.getParameter('diff'), this.getResponseMessage());
	}, false);
};

/**
 * diffWithServerDate
 * 
 * @param requestDate
 * @param callbackFunction
 * @param isGrid
 */
everDate.diffWithServerDate = function(requestDate, callbackFunction, isGrid) {
    var store = new EVF.Store();
    store.setParameter('requestDate', requestDate);
    store.setParameter('isGrid', isGrid);
    store.load('/common/util/web/everDateController/diffWithServerDate.so', function() {
        callbackFunction(this.getParameter('diff'), this.getResponseMessage());
    }, false);
};

/**
 * yyyymmdd to json
 * 
 * @param dateString
 * @returns json object
 */
everDate.convertYyyymmddToJson = function(dateString) {
	var year = Number(dateString.substring(0, 4));
	var month = dateString.substring(4, 6);
	var day = dateString.substring(6, 8);
	return {
		year : year,
		month : month,
		day : day
	};
};

everDate.convertDdmmyyyyToJson = function(dateString) {
	dateString = dateString.replace(/\//g, "");
	var year = Number(dateString.substring(4, 8));
	var month = dateString.substring(2, 4);
	var day = dateString.substring(0, 2);
	return {
		year : year,
		month : month,
		day : day
	};
};

/**
 * yyyy - �꾨룄 mm - ��* dd - ��* hh - �쒓컙 * mi - 遺�* ss - 珥�
 * 
 * @param srcDate
 * @param targetDate
 * @param srcFormat
 * @param targetFormat
 * @returns -1: srcDate ���좎쭨媛�targetDate���좎쭨蹂대떎 �대Ⅸ 寃쎌슦 (srcDate < targetDate) 0:
 *          srcDate, targetDate �숈씪 (srcDate == targetDate) 1: srcDate媛�
 *          targetDate 蹂대떎 ��� 寃쎌슦 (targetDate < srcDate)
 */
everDate.compareDate = function(srcDate, targetDate, srcFormat, targetFormat) {

	// console.log('srcDate: ' + srcDate + ' - ' + 'targetDate: ' + targetDate);
	// console.log('srcFormat: ' + srcFormat + ' - ' + 'targetFormat: ' + targetFormat);

	srcDate = srcDate.replace(/[^0-9 ]/gi, '');
	targetDate = targetDate.replace(/[^0-9 ]/gi, '');
	srcFormat = srcFormat.replace(/["/"-/.]/gi, '').replace('mm', 'MM').replace('mi', 'mm');
	targetFormat = targetFormat.replace(/["/"-/.]/gi, '').replace('mm', 'MM').replace('mi', 'mm');

	// console.log('srcDate: ' + srcDate + ' - ' + 'targetDate: ' + targetDate);
	// console.log('srcFormat: ' + srcFormat + ' - ' + 'targetFormat: ' + targetFormat);

	srcDate = Date.parseExact(srcDate, srcFormat);
	targetDate = Date.parseExact(targetDate, targetFormat);

	// console.log('srcDate: ' + srcDate + ' - ' + 'targetDate: ' + targetDate);
	// console.log('srcFormat: ' + srcFormat + ' - ' + 'targetFormat: ' + targetFormat);
	// console.log('parsed srcDate: ' + srcDate.toJSONString() + ' - ' + 'parsed targetDate: ' + targetDate.toJSONString());

	var result = srcDate.compareTo(targetDate);
	// console.log('result: ' + result);
	return result;
};

/**
 * 遺�벑�몃� �댁슜���좎쭨 鍮꾧탳 ex) wiseDate.compareDateWithSign('22/06/2012', '<=',
 * '22/07/2012', 'dd/mm/yyyy', 'dd/mm/yyyy');
 * 
 * @param srcDate
 * @param targetDate
 * @param srcFormat
 * @param sign
 * @param targetFormat
 * @returns
 */
everDate.compareDateWithSign = function(srcDate, sign, targetDate, srcFormat, targetFormat) {
	if(srcDate === undefined || everString.lrTrim(srcDate) === '' || targetDate === undefined || everString.lrTrim(targetDate) === ''){
		return false;
	}
	
	var result = everDate.compareDate(srcDate, targetDate, srcFormat, targetFormat);
	// console.log(srcDate + ' ' + sign + ' ' + targetDate);
	return eval(result + sign + 0);
};

everDate.fromTodateValid = function(fromDateId, toDateId, dateFormat){

	var fromDateCmp = EVF.getComponent(fromDateId);
    var toDateCmp = EVF.getComponent(toDateId);
    var fromDateValue = fromDateCmp.getValue();
    var toDateValue = toDateCmp.getValue();

	if(EVF.isEmpty(fromDateValue) || EVF.isEmpty(toDateValue)) {
		return;
	} else {

	}

    return everDate.compareDateWithSign(fromDateValue, '<=', toDateValue, dateFormat, dateFormat);
};


everDate.callbackTimeOut = function(fn) {
	setTimeout(fn, 1000);
};

everDate.calculateTimeUnit = function(secs, unit, mod) {
	return Math.floor(secs / unit) % mod;
};

everDate.getTimeUnitBySecMesure = function(sec) {
	return {
		day : everDate.calculateTimeUnit(sec, 60 * 60 * 24, 9999999),
		hour : everDate.calculateTimeUnit(sec, 60 * 60, 24),
		min : everDate.calculateTimeUnit(sec, 60, 60),
		sec : everDate.calculateTimeUnit(sec, 1, 60)
	};
};

	everDate.checkTermDate = function(fromDateId,toDateId,msg) {	
	
    var fromDate = Number(EVF.C(fromDateId).getValue());
    var toDate = Number(EVF.C(toDateId).getValue());

    if(fromDate > toDate) {
    	alert(msg);
        return false;
    }
    return true;
};

everDate.CountDown = function() {
	return {
		setTime : function(_currentTime, _targetTime) {
			this.currentTime = _currentTime;
			this.targetTime = _targetTime;
		},
		setComponent : function(_component) {
			this.component = _component;
		},
		setMessage : function(_message) {
			this.message = _message;
		},
		setFormat : function(_format) {
			this.format = _format;
		},
		getMessage : function() {
			return this.message;
		},
		getFormat : function() {
			return this.format;
		},

		startTimer : function() {
			var that = this;
			var remainingTime = that.targetTime - that.currentTime;
			that.currentTime += 1;
			var timeUnit = everDate.getTimeUnitBySecMesure(remainingTime);
			// console.log(that.getFormat());
			that.component.setValue(everString.format(that.getFormat(), timeUnit.day, timeUnit.hour, timeUnit.min, timeUnit.sec));
			if (remainingTime === 0) {
				alert(this.getResponseMessage());
				return;
			}
			setTimeout(function() {
				that.startTimer();
			}, 1000);
		},
		initCountDown : function(_currentTime, _targetTime, _component, _message, _format) {
			this.setTime(_currentTime, _targetTime);
			this.setComponent(_component);
			this.setMessage(_message);
			this.setFormat(_format);
			this.startTimer();
		}
	};
};