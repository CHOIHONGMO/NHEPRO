/**
 * everSRM common scripts
 */

var everCommon = {};
// popupFlag 여부를 판단하여 ... 제거
if (location.search.indexOf("popupFlag=true") > 0) {
    setTimeout(function () {
        $(".e-ellipsis-icon-wrapper").remove();
    }, 1000);
}

everCommon.blank = function() {
	// <e:search TAG의 readOnly가 true이면 호출됨.
};

// session info alert
shortcut.add("F2", function() {
    var store = new EVF.Store();
    store.load('/common/util/sessionInfo.so', function(){
        var sessionInfo = JSON.parse(this.getParameter('sessionInfoString'));
        var printString = '';
        for(var x in sessionInfo){
            if(sessionInfo.hasOwnProperty(x)){
                printString += x + ': ';
                printString += '[ ' + sessionInfo[x] + ' ]';
                printString += '\n';
            }
        }
        console.table(printString);
    });
});