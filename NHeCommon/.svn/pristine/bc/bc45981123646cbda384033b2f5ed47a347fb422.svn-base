package com.st_ones.common.util.excel.upload;

import jxl.read.biff.BiffException;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : AbstExcelImportProc.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public abstract class AbstExcelImportProc {

    InputStream inputStream;
    protected List<String> headerValues = new ArrayList<String>();
    protected List<List<String>> contentsRows = new ArrayList<List<String>>();
    protected Map<String, String> colInfoMap;
    protected Map<String, String> paramOptions;

    public void setParamOptions(Map<String, String> paramOptions) {
        this.paramOptions = paramOptions;
    }

    public void setInputStream(InputStream inputStream) {
        this.inputStream = inputStream;
    }

    public abstract List<Map<String, String>> read() throws InvalidFormatException, IOException, BiffException;

    public abstract String read2() throws Exception;

    public Map<String, String> getParamOptions(){
        return this.paramOptions;
    }

    public void setColInfo(Map<String, String> colInfo) {
        this.colInfoMap = colInfo;
    }

    public List<String> getIdList() {
        List<String> idList = new ArrayList<String>();
        return idList;
    }
}