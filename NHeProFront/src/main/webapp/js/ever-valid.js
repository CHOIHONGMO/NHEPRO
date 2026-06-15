var valid = function() {
    {
    }
};

/*
 * 비교하고자 하는 Column의 동일 여부를 판단하여
 * 동일하면 리턴값을 반환한다.
 */
valid.equalMultiColValid = function(oriGrid, column) {
    var selRowIds = grid.jsonToArray(grid.getSelRowId()).value;
    // Validation 전체 데이터 체크
    for(var i = 0; i < oriGrid.getRowCount(); i++) {
        for(var idx in selRowIds) {
            if(i != selRowIds[idx]) {
                for(var idxs in column) {
                    if(oriGrid.getCellValue(i, column[idxs]) == oriGrid.getCellValue(idx, column[idxs])) {
                        var td = oriGrid._getCellTag(i, column[idxs]);
                        td.css('color', '#fff').css('background-color', '#ff988c');
                        td.find("a").css('color', '#fff').css('background-color', '#ff988c');

                        setTimeout(function() {
                            td.animate({backgroundColor: "#fff",color: "#333"}, 1000);
                            td.find("a").animate({backgroundColor: "#fff",color: "blue"}, 1000);
                        }, 4000);

                        alert("동일한 데이터가 존재합니다.\n"+column[idxs]+" : "+oriGrid.getCellValue(i, column[idxs]));
                        oriGrid.setCellValue(idx, column[idxs], "");
                        return true;
                    }
                }
            }
        }
    }
};

/*
 * 팝업에서 값을 선택하여 화면으로 내려줄 시 동일한 값이 있으면 삭제 후
 * 동잃하지 않은 값을 리턴해준다.
 */
valid.equalPopupValid = function(data, addGrid, column) {
    data = JSON.parse(data);

    // 동일코드 여부 확인
    var grdhStr = "";
    var rowCount = addGrid.getRowCount();

    if(rowCount > 0) {
        for(var i = 0; i < rowCount; i++) {
            for(var idx in data ) {
                if(addGrid.getCellValue(i, column) == data[idx][column]) {
                    grdhStr += column +" : "+data[idx][column]+"\n";

                    // 동일 데이터 삭제
                    data.splice(idx,1);
                }
            }
        }

        if(grdhStr != "")
            alert("동일한 데이터가 존재합니다.\n"+grdhStr.substring(0, grdhStr.length -1));
        return data;
    } else {
        return data;
    }
};

/*
 * value 값과 그리드의 값을 비교하여 동일 여부를 판단 후 아닐 시 리턴값을 반환한다.
 */
valid.notEqualColValid = function(grid, column, value) {
    var selRowIds = grid.jsonToArray(grid.getSelRowId()).value;

    var array = [];
    var flag = false;
    for(idx in selRowIds) {
        if(grid.getCellValue(selRowIds[idx], column) != value) {
            array.push(grid._getCellTag(selRowIds[idx], column));

            var td = grid._getCellTag(selRowIds[idx], column);
            td.css('color', '#fff').css('background-color', '#ff988c');
            td.find("a").css('color', '#fff').css('background-color', '#ff988c');

            flag = true;
        }
    }

    validAnimateSetTime(array);

    return flag;
};

/*
 * 그리드의 선택 된 데이터를 지정 된 값과 비교하여 같으면 animate 표시를 한다.
 * 파라미터 값은 : grid, 선택 grid, 비교 컬럼, 비교 값, 적용 컬럼
 */
valid.equalColValid = function(grid, column, value) {
    var selRowIds = grid.jsonToArray(grid.getSelRowId()).value;

    var array = [];
    var flag = false;
    for(idx in selRowIds) {
        if(grid.getCellValue(selRowIds[idx], column) == value) {
            array.push(grid._getCellTag(selRowIds[idx], column));

            var td = grid._getCellTag(selRowIds[idx], column);
            td.css('color', '#fff').css('background-color', '#ff988c');
            td.find("a").css('color', '#fff').css('background-color', '#ff988c');

            flag = true;
        }
    }

    validAnimateSetTime(array);

    return flag;
};

/*
 * 그리드의 데이터를 지정 된 value 값과 비교하여 row 전체를 animate 표시한다.
 * function(grid, validation체크 컬럼, 체크 값, 키 컬럼)
 * 호출방식 : if(valid.equalMultiRowValid(grid, columns, "", "VENDOR_CD")) { return; }
 */
valid.equalMultiRowValid = function(grid, column, value, keyColumn) {
    var selRowIds = grid.jsonToArray(grid.getSelRowId()).value;

    var msg = "데이터를 확인하여 주시기 바랍니다.\n\n";
    var array = [];
    var flag = false;

    // Validation 전체 데이터 체크
    for(var i = 0; i < selRowIds.length; i++) {
        var n = 0;
        for(idx in column) {
            if(grid.getCellValue(selRowIds[i], column[idx]) == value) {

                if(n == 0) {
                    if(grid.getCellValue(selRowIds[i], keyColumn).text != undefined) {
                        msg += "["+grid.getCellValue(selRowIds[i], keyColumn).text + "]\n";
                    } else {
                        msg += "["+grid.getCellValue(selRowIds[i], keyColumn) + "]\n";
                    }
                }

                array.push(grid._getRowTag(i));

                var td = grid._getRowTag(i);
                td.css('color', '#fff').css('background-color', '#ff988c');
                td.find("a").css('color', '#fff').css('background-color', '#ff988c');

                msg += idx + " : " + value + "\n";
                n++;
                flag = true;
            }
        }
    }

    validAnimateSetTime(array);

    if(flag)
        alert(msg);

    return flag;
};

function validAnimateSetTime(array) {

    setTimeout(function() {
        for(var idxs in array) {
            array[idxs].animate({backgroundColor: "#fff",color: "#333"}, 1000);
            array[idxs].find("a").animate({backgroundColor: "#fff",color: "blue"}, 1000);
        }
    }, 4000);
}